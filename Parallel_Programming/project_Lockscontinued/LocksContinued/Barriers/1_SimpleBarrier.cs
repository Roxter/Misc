using LocksContinued.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LocksContinued.Barriers
{
    public class SimpleBarrier : IBarrier
    {
        volatile int count; //количество потоков, которое осталось дождаться
        int size; // количество потоков, которые мы ожидаем
        public SimpleBarrier(int n)
        {
            count = n;
            size = n;
        }

        //когда вызвали метод await() значит мы достигли барьера
        public void Await()
        {
            //уменьшаем на 1 количество потоков, которые осталось дождаться, и запоминаем
            int position = Interlocked.Decrement(ref count);
            //если оно 0, значит мы последние и скидываем ожидаемые, до общего количества потоков
            if (position == 0)
            {
                count = size;
            }
            //если мы не последние, то ждем, пока прибудет последний
            else
            {
                while (count != 0) { }; //предположим операционная система усыпила поток
                //если счетчик сбросили раньше, чем вращающийся поток прочитал значение
                //то он будет бесконечно висеть в барьере
            }

        }
    }
}
