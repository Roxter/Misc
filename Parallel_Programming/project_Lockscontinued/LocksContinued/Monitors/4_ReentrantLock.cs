using System;
using System.Threading;

namespace LocksContinued.Monitors
{

    // решение ситуации, когда поток при повторной блокировке, удерживаемой блокировки блокирует сам себя
    //Блокировка реентерабельна, если она может быть получена несколько раз одним и тем же потоком.

    public class SimpleReentrantLock : ILock
    {
        object sync = new object(); //поле блокировки
        int owner; //поток, последним получивший блокировку
        int holdCount; //увеличивается при каждой блокировке и уменьшается при каждой разблокировке
        public SimpleReentrantLock()
        {
            owner = 0;
            holdCount = 0; //блокировка свободна, когда  holdCount = 0;
        }

        public void Lock()
        {
            int me = Thread.CurrentThread.ManagedThreadId; //получаем номер текущего потока
            Monitor.Enter(sync); //захватываем монитор
            try
            {
                if (owner == me) //если я владелец
                {
                    holdCount++; //увеличиваем количество выданных блокировок на 1
                    return; //выходим из метода
                }
                while (holdCount != 0) // если мы не владелец и блокировка не свободна
                {
                    Monitor.Wait(sync); //идем ждать
                }
                owner = me; //когда дождались, говорим, что мы владелец блокировки
                holdCount = 1; //изменяем holdCount с 0 на 1, что блокировка не свободна
            }
            finally
            {
                Monitor.Exit(sync); //отпускаем монитор
            }
        }

        public void Unlock()
        {
            Monitor.Enter(sync); //захватываем монитор
            try
            {
                //если количество удерживающих == 0 или владелец не мы
                if (holdCount == 0 || owner != Thread.CurrentThread.ManagedThreadId) 
                    throw new InvalidOperationException(); //кидаем исключение
                holdCount--; //иначе уменьшаем количество деражщих блокировку
                if (holdCount == 0) //если блокировка освободилась
                {
                    Monitor.Pulse(sync);//оповещаем ожидающих
                }
            }
            finally
            {
                Monitor.Exit(sync); //отпускаем монитор
            }
        }
    }
}