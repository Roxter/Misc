using LocksContinued.Locks;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LocksContinued.WorkStealing
{
    //Мы видели, что в алгоритмах кражи работы пустые потоки крадут задачи у других. 
    //Альтернативный подход состоит в том, чтобы каждый поток периодически балансировал 
    //свои рабочие нагрузки со случайно выбранным партнером. 
    //Чтобы убедиться, что сильно загруженные потоки не теряют усилий, пытаясь восстановить баланс, 
    //мы повышаем вероятность того, что слегка загруженные потоки будут инициировать восстановление баланса. 
    //Точнее, каждая нить периодически подбрасывает смещенную монету, чтобы решить, 
    //стоит ли балансировать с другой. 

    //. Поток перебалансируется путем случайного выбора жертвы равномерно, 
    //и, если разница между его рабочей нагрузкой и нагрузкой жертвы превышает 
    //предварительно определенный порог, они переносят задачи до тех пор, 
    //пока их очереди не содержат одинаковое количество задач. 
    public class WorkSharingThread
    {
        Dictionary<int, Queue<Task>> queue; //словарь ключ - идентификатор потока, значение - очередь заданий
        Random random;
        const int THRESHOLD = 42;
        public WorkSharingThread(Dictionary<int, Queue<Task>> myQueue)
        {
            queue = myQueue;
            random = new Random();
        }
        public void Run()
        {
            int me = Thread.CurrentThread.ManagedThreadId; //определяем идентификатор текущего потока
            while (true) //бесконечный цикл
            {
                Task task; 
                lock (queue[me]) //синхронизируемся на очереди задач текущего потока 
                {
                    task = queue[me].Dequeue(); //берем задачу 
                }
                if (task != null) task.Start(); // если задача не пустая, запускаем ее
                int size = queue[me].Count; //определяем количество задач в нашей очереди
                if (random.Next(size + 1) == size) // поток решает перебалансироваться с вероятностью 1 / (s + 1) 
                {
                    int victim = queue.Keys.ToList()[random.Next(queue.Keys.Count)];//выбирается случайная жертва
                    int min = (victim <= me) ? victim : me;
                    int max = (victim <= me) ? me : victim;
                    //блокируем обе очереди в порядке по id
                    lock (queue[min])
                    {
                        lock (queue[max])
                        {
                            Balance(queue[min], queue[max]); //выполняем перебалансировку
                        }
                    }
                }
            }
        }
        private void Balance(Queue<Task> q0, Queue<Task> q1)
        {
            //если количество в первой меньше, чем во второй меньшая очередь вторая, иначе первая
            var qMin = (q0.Count < q1.Count) ? q0 : q1; 
            //если количество в первой меньше чем во второй, то максимальная очередь вторая, иначе первая
            var qMax = (q0.Count < q1.Count) ? q1 : q0;
            //разница между количеством задач в максимальной и минимальной очередях
            int diff = qMax.Count - qMin.Count;
            //если оно больше определенного значения
            if (diff > THRESHOLD)
                while (qMax.Count > qMin.Count) //пока в макимальной не станет столько же сколько в минимальной
                    qMin.Enqueue(qMax.Dequeue()); //минимальной передаем значения из начала максимальной очереди
        }
    }
}
