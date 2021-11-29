using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LocksContinued.WorkStealing
{

    class CircularArray
    {
        private int logCapacity; // логическая емкость
        private Task[] currentTasks; //массив задач

        public CircularArray(int myLogCapacity)
        {
            logCapacity = myLogCapacity; 
            currentTasks = new Task[1 << logCapacity]; //битовый сдвиг 1 влево лог.вм. =  2^логической вместимости
        }
        public int Capacity => 1 << logCapacity; //емкость = битовый сдвиг 1 влево лог.вм. = 2^логической вместимости

        //получить задачу
        public Task Get(int i)
        {
            return currentTasks[i % Capacity]; //вовзращаем задачу по индексу остатка от деления на емкость
        }

        //положить задачу
        public void Put(int i, Task task)
        {
            currentTasks[i % Capacity] = task; //кладем задачу в массив по индексу остатка от деления на емкость
        }

        //изменить размер массива
        public CircularArray Resize(int bottom, int top)
        {
            CircularArray newTasks =
            new CircularArray(logCapacity + 1); //создаем новый циклический массив логической емкостью на 1 больше, чем было
            for (int i = top; i < bottom; i++)
            {
                newTasks.Put(i, Get(i)); //переносим все элементы в новый массив
            }
            return newTasks; //возвращаем новый заполненный циклический массив
        }
    }

    public class UnboundedDEQueue : IDEQueue<Task>
    {
        const int LOG_CAPACITY = 4;
        private volatile CircularArray tasks; //задачи
        volatile int bottom; //нижняя граница
        volatile int top; //верхняя граница
        public UnboundedDEQueue(int logCapacity)
        {
            tasks = new CircularArray(logCapacity); //инициализируем циклический массив
            top = 0; 
            bottom = 0;
        }

        //важен порядок, потому что топ не уменьшается
        public bool IsEmpty()
        {
            int localTop = top; //читаем верхний индекс
            int localBottom = bottom; //читаем нижний индекс
            return (localBottom <= localTop); //если нижний предел меньше или равен верхнему тогда очередь пуста
        }

        public void PushBottom(Task t)
        {
            int oldBottom = bottom; //запоминаем нижний индекс
            int oldTop = top; //запоминаем верхний индекс
            int size = oldBottom - oldTop; //вычисляем разницу между верхним индексом и нижним
            if (size >= tasks.Capacity - 1) //если она больше, чем вмсетимость - 1
            {
                tasks = tasks.Resize(oldBottom, oldTop); //меняем размер циклического массива
            }
            tasks.Put(oldBottom, t); //кладем задачу в конец очереди
            bottom = oldBottom + 1; //двигаем нижний индекс
        }

        public Task PopTop()
        {
            int oldTop = top; //запоминаем верхний индекс
            int newTop = oldTop + 1; //запоминаем новый верхний индекс
            int oldBottom = bottom; //запоминаем нижний индекс
            int size = oldBottom - oldTop; //вычисляем разницу между нижним и верхним индексом
            if (size <= 0) return null; //если нижний меньше либо равен верхнему, тогда размер <= 0, задач нет
            Task t = tasks.Get(oldTop); //берем задачу по верхнему индексу
            if (Interlocked.CompareExchange(ref top, oldTop, newTop) == oldTop) // если удалось заменить страую верхнюю границу на новую
               return t; //урали элемент
            return null; //иначе нет
            }

        public Task PopBottom()
        {
            bottom--; //уменьшаем нижний индекс
            int oldTop = top; //запоминаем верхний индекс
            int newTop = oldTop + 1; //запоминаем новый верхний индекс
            int size = bottom - oldTop; //вычисляем разницу между нижним и верхним индексом
            if (size < 0) //если нижний индекс меньше верхнего, очередь пуста
            {
                bottom = oldTop; //сбрасываем нижний индекс в верхний
                return null;//не отдаем задачу
            }
            Task t = tasks.Get(bottom); //берем задачу по нижнему индексу
            if (size > 0) //если нижний индекс больше верхнего, значит задача есть
                return t; //отдаем ее
            if (Interlocked.CompareExchange(ref top, oldTop, newTop) != oldTop)
                //если не удалось поменять верхний индекс на новый
                t = null; //пустая задача, потому что параллельный ее украл
            //вне зависимости от успешности установки 
            bottom = oldTop + 1; //нижний индекс = верхний + 1
            return t; //возврашаем задачу
        }
    }
}
