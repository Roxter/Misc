using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LocksContinued.WorkStealing
{
    //Для пула исполнителей DEQueue наиболее распространенным случаем является то, 
    //что поток выталкивает и извлекает задачу из собственной очереди, вызывая pushBottom () и popBottom (). 
    //Необычный случай - украсть задачу из DEQueue другого потока, вызвав popTop ().

    public class BDEQueue : IDEQueue<Task>
    {
        Task[] tasks; //массив задач
        volatile int bottom; //нижняя граница
        AtomicStampedReference<int> top; //верхняя граница + сколько раз ее меняли
        public BDEQueue(int capacity)
        {
            tasks = new Task[capacity];
            top = new AtomicStampedReference<int>(0, 0);
            bottom = 0;
        }
        public void PushBottom(Task t)
        {
            tasks[bottom] = t; //добавляем задачу в конец
            bottom++; //инкрементируем нижнюю границу
        }

        // важен порядок
        public bool IsEmpty()
        {
            int localTop = top.GetReference(); //сначала читает верхнюю границу
            int localBottom = bottom; //читает нижнюю границу
            return localBottom <= localTop; //если нижний предел меньше или равен верхнему тогда очередь пуста
        }

        public Task PopTop()
        {
            int stamp = 0; //инициализируем штамп
            int oldTop = top.Get(out stamp), newTop = oldTop + 1; 
            //запоминаем верхнюю границу , а новую верхняя = старая + 1
            int oldStamp = stamp, newStamp = oldStamp + 1;
            //запоминаем штамп и новый штамп увеличиваем старый на единицу
            if (bottom <= oldTop) //близко к вершине или сама вершина
                return null; //если нижняя граница меньше либо равно верхней, возвращаем налл (типа красть нечего)
            Task t = tasks[oldTop]; //берет задачу из запомненой верхней границы
            if (top.CompareAndSet(oldTop, newTop, oldStamp, newStamp))
                //если удалось заменить старую верхнюю границу на новую и поменять штамп изменений
                return t; // отдаем элемент
            return null; //иначе возвращаем, что не смогли украсть
        }

        public Task PopBottom()
        {
            if (bottom == 0)
                return null; //если очередь пуста, немедленно возвращаемся
            bottom--; // уменьшаем значение нижней границы, чтобы воры увидели, что брать нечего, если это последняя задача
            Task t = tasks[bottom]; //берем последнюю задачу
            int stamp; 
            int oldTop = top.Get(out stamp); //сохраняем верхний индекс со штампом
            int newTop = 0; //объявляем новый верхний индекс
            int oldStamp = stamp, newStamp = oldStamp + 1; // сохраняем старый штамп и делаем новый, увеличив старый на 1
            if (bottom > oldTop) //проверяем, больше ли лекущий нижний индекс, чем верхний // задачи есть
                return t; //возвращаем задачу
            //если верхний равен нижнему элементу
            if (bottom == oldTop)
            {
                //только одна задача и возможен конфликт с вором
                bottom = 0; // нижний индекс устанавливаем в 0
                if (top.CompareAndSet(oldTop, newTop, oldStamp, newStamp))
                    //если сбросился верхний индекс в 0 и поменялся штамп на новый
                    return t; //отдаем задачу
            }
            top.Set(newTop, newStamp); //двигаем глобальную верхнюю вершину в 0 с новым штампом
            return null;//говорим, что нечего отдать
        }
    }
}
