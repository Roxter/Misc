using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LocksContinued.Monitors
{
    //Семафор - это обобщение блокировок взаимного исключения.Каждый семафор имеет емкость, 
    //обозначаемую c для краткости.Вместо того, чтобы разрешать только один поток за один раз в критическую секцию, 
    //семафор разрешает не более c потоков, где емкость c определяется при инициализации семафора.
    // Сам семафор является просто счетчиком: он отслеживает количество потоков, которым было разрешено войти.
    // Если новый вызов acqu () собирается превысить емкость c, вызывающий поток приостанавливается до тех пор, пока не освободится место. 
    //Когда поток покидает критическую секцию, он вызывает release (), чтобы уведомить ожидающий поток о том, что теперь есть место.
    public class Semaphore
    {
        int capacity; //емкость
        int state; //состояние 
        object sync = new object(); //объект синхронизации

        public Semaphore(int c)
        {
            capacity = c; //начальная емкость
            state = 0; //колчиество потоков в семафоре

        }

        public void Acquire()
        {
            Monitor.Enter(sync); //берем блокировку на объект синхронизации

            try
            {
                while (state == capacity) //пока все места заняты
                {
                    Monitor.Wait(sync); //ждем уведомления
                }
                state++; //увеличиваем количество потоков в семафоре на 1
            }
            finally
            {
                Monitor.Exit(sync); //отпускаем монитор
            }
        }

        public void Release()
        {
            Monitor.Enter(sync); //захватываем монитор
            try
            {
                state--;// уменьшаем количество потоков в семафоре 
                Monitor.PulseAll(sync); //оповещаем всех ожидающих
            }
            finally
            {
                Monitor.Exit(sync);// снимаем блокировку
            }
        }
    }
}