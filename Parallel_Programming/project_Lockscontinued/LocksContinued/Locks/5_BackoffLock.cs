using System.Threading;

namespace LocksContinued.Locks
{
    //

    //идея давать конкурирующим потокам шанс закончить работу, когда мы отступим от попытки получить блокировку 
    //на некоторое время
    partial class BackoffLock : ILock
    {
        //проблема когерентности кэша
        private volatile int state = 0;  //0 -свободно, 1 - занято
        const int MIN_DELAY = 10;
        const int MAX_DELAY = 1000;

        public void Lock()
        {
            Backoff backoff = new Backoff(MIN_DELAY, MAX_DELAY); //инициализируем бэкофф 

            while (true) //бесконечный цикл
            {
                while (state == 1) { }; //ждем пока занято

                //если состояние предыдущее свободно, то пытаемся установить 1 вместо 0
                if (Interlocked.CompareExchange(ref state, 1, 0) == 0)
                {
                    return; //взяли лок
                }
                else
                {
                    //не удалось получить блокировку, которая у него была
                    backoff.DoBackoff(); //иначе даем шанс другим потокам и ждем
                    //Thread.Sleep(0); - мьютекс - сигнал планировщику, что нам делать нечего //одноместный семафор
                }
            }
        }
        public void Unlock()
        {
            state = 0; //скидываем состояние в 0
        }
    }
}
