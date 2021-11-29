using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LocksContinued.WorkStealing
{
    public class WorkStealingThread
    {
        Dictionary<int, IDEQueue<Task>> queue; //словарь ключ - идентификатор потока, значение - очередь заданий двунаправленная
        Random random;
        public WorkStealingThread(Dictionary<int, IDEQueue<Task>> myQueue)
        {
            queue = myQueue; 
            random = new Random();
        }
        public void Run()
        {
            int me = Thread.CurrentThread.ManagedThreadId; //определяем номер текущего потока
            Task task = queue[me].PopBottom(); //берем по ключу из словаря очеред заданий, берем задание с конца
            while (true) //бесконечный цикл
            {
                while (task != null) //пока задание не налл
                {
                    task.Start(); //запускаем задание
                    task = queue[me].PopBottom();//берем следующее с конца очереди заданий из словаря по ключу
                }
                while (task == null) //пока задание
                {
                    Thread.Yield();//передаем управление другому потоку
                    int victim = queue.Keys.ToList()[random.Next(queue.Keys.Count)]; //случайно выбираем жертву
                    if (!queue[victim].IsEmpty()) //если очередь жертвы не пуста
                    {
                        task = queue[victim].PopTop(); //крадем задание из головы ее очереди
                    }
                }
            }
        }
    }
}
