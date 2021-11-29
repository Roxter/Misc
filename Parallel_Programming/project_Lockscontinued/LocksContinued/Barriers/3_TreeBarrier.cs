using LocksContinued.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LocksContinued.Barriers
{
    //Разделите большой барьер на дерево меньших барьеров, и пусть потоки объединяют запросы, 
    //идущие вверх по дереву, и распространяют уведомления, идущие вниз по дереву.
    
    public class TreeBarrier : IBarrier
    {
        int radix;
        Node[] leaf; // массив листьев
        int leaves; //количество листьев
        ThreadLocal<bool> threadSense; //локальное состояние барьера

        //древовидный барьер характеризуется размером n, общим числом потоков и r, числом дочерних узлов каждого листа. 
        public TreeBarrier(int n, int r)
        {
            radix = r; 
            leaves = 0; 
            
            leaf = new Node[n / r]; // задаем количество листьев - дочерних узлов
            int depth = 0;
            threadSense = new ThreadLocal<Boolean>(() => true);

            //предположим, что существует ровно n = rd потоков, где d- глубина дерева
            // определяем глубину дерева
            while (n > 1)
            {
                depth++;
                n = n / r;
            }
            //создаем корень
            Node root = new Node(radix, threadSense);
            //строим дерево от корня
            Build(root, depth - 1);
        }

        //дерево Node
        //рекурсивный построитель дерева барьеров
        void Build(Node parent, int depth)
        {
            //если глубина = 0, тогда в листья попадает только родительский узел
            if (depth == 0)
            {
                leaf[leaves++] = parent;
            }
            else
            {
                //до количества дочерних  узлов
                for (int i = 0; i < radix; i++)
                {
                    //делаем дочерний узел
                    Node child = new Node(parent, radix, threadSense);
                    //рекурсивно строим поддеревья
                    Build(child, depth - 1);
                }
            }
        }

       //подходим к барьеру, вызываем метод await(), который вызывает метод await() у соответствующего родительского узла
        public void Await()
        {
            // диапазон от 0 до n-1
            int me = Thread.CurrentThread.ManagedThreadId; //считываем свой идентификатор 

            Node myLeaf = leaf[me / radix]; //определяем барьер
            myLeaf.Await();
        }

        private class Node
        {
            ThreadLocal<bool> threadSense; //локальное состояние 
            int radix; //число дочерних узлов

            volatile int count; //количество оставшихся дочерних узлов

            Node parent; //родительский узел
            volatile bool sense; // состояние глобальное у узла

            //конструктор для корня
            public Node(int radix, ThreadLocal<bool> threadSense)
            {
                this.radix = radix;
                this.threadSense = threadSense;
                sense = false;
                parent = null;
                count = radix;
            }

            //конструктор для дочерних узлов, у которых есть родитель
            public Node(Node myParent, int radix, ThreadLocal<bool> threadSense) 
                : this(radix, threadSense)
            {
                parent = myParent;
            }

            //принципиальным отличием которого является то, что последний поток, 
            //который завершает барьер, посещает родительский барьер до пробуждения других потоков. 
            public void Await()
            {
                // считываем наше состояние
                bool mySense = threadSense.Value;
                //берем количество оставшихся и уменьшаем на 1 и кладем себе
                int position = Interlocked.Decrement(ref count);

                //если мы последние
                if (position == 0)
                { // I’m last
                  //если у нас есть корень, то у него вызываем метод барьера 
                   //(если мы последнее поддерево, то он выйдет, если нет, то будет висеть)
                    if (parent != null)
                    { 
                        parent.Await();
                    }
                    //сбрасываем количество ожидаемых
                    count = radix;
                    // устанавливаем глобальное состояние узла, такое же как у последнего, тем самым пробуждаем окружающих
                    sense = mySense;
                }
                //если не последние, то ждем пока последний сменит состояние
                else
                {
                    while (sense != mySense) { };
                }
                //устанавливаем наше состояние противоположное, глобальному
                threadSense.Value = !mySense;
            }
        }
    }
}
