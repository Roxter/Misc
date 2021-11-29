using LocksContinued.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LocksContinued.Barriers
{
    class SenseBarrier:IBarrier
    {
        volatile int count; //количество потоков, которые осталось дождаться //за это поле драка
        int size; //общее количество потоков
        volatile bool sense = false; // глобальное состояние барьера //надо для единовременного уведомления
        ThreadLocal<bool> threadSense; //индивидуальное состояние потока

        public SenseBarrier(int n)
        {
            // количество оставшихся = размеру барьера
            count = n;
            size = n;
            //глобальное состояние барьера
            sense = false;
            //локальное состояние потока = отрицание глобального состояния барьера
            threadSense = new ThreadLocal<bool>(() => !sense);
        }

        //достигли барьера
        public void Await()
        {
            // считываем свое состояние
            bool mySense = threadSense.Value;
            //уменьшаем на 1 количество потоков, которые осталось дождаться, и запоминаем
            int position = Interlocked.Decrement(ref count);
            //если мы пришли последние
            if (position == 0)
            {
                //скидываем количество ожидаемых
                count = size;
                //устанавливаем состояние барьера, как состояние последнего потока
                sense = mySense;
            }
            //если не последние, то висим, пока наше состояние не станет таким же как у всего барьера
            else
            {
                while (sense != mySense) { } //даже если тут уснуло, то при просыпании оно прочитает нужное значение
            }
            //устанавливаем свое состояние противоположно глобальному состоянию барьера
            threadSense.Value = !mySense;
        }
    }
}
