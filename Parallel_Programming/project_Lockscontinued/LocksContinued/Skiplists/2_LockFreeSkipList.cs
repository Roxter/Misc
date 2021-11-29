using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LocksContinued.Skiplists
{
    //Представляя алгоритмические подробности, читатель должен помнить, 
    //что абстрактный набор определяется только списком нижнего уровня.
    //Узлы в списках верхнего уровня используются только как ярлыки в списке нижнего уровня
    public class LockFreeSkipList<T>
    {
        const int MAX_LEVEL = 42; //максимальный уровень
        readonly Node<T> head = new Node<T>(int.MinValue); //левый столбик - голова
        readonly Node<T> tail = new Node<T>(int.MaxValue); //правый стоблик - хвост
        public LockFreeSkipList()
        {
            for (int i = 0; i < head.Next.Length; i++)
            {
                head.Next[i] = new AtomicMarkableReference<Node<T>>(tail, false);
                //все следующие у головы направить на хвост 
            }
        }

        private class Node<T>
        {
            public T Value; //хранимое значение
            public int Key; //ключ
            public AtomicMarkableReference<Node<T>>[] Next; //сслыка на следующий
            public int TopLevel; //верхний уровень
            //конструктор сентинелов
            public Node(int key)
            {
                Value = default(T); //дефолтное
                this.Key = key; //сохраняем ключ
                Next = new AtomicMarkableReference<Node<T>>[MAX_LEVEL + 1]; //инициализируем столбик следующих
                for (int i = 0; i < Next.Length; i++)
                {
                    //для всего столбика следующих инициализируем ссылки налл
                    Next[i] = new AtomicMarkableReference<Node<T>>(null, false);
                }
                TopLevel = MAX_LEVEL; //максимальный уровень 
            }
            //конструктор обычных нод
            public Node(T x, int height)
            {
                Value = x; //сохраняем значение
                Key = x.GetHashCode(); //ключ - хэш значения
                Next = new AtomicMarkableReference<Node<T>>[height + 1]; //инициализируем массив ссылток для следующих
                for (int i = 0; i < Next.Length; i++)
                {
                    //для всего столбика следующих инициализируем ссылки налл
                    Next[i] = new AtomicMarkableReference<Node<T>>(null, false);
                }
                TopLevel = height; //максимальный уровень = высоте
            }
        }

        public bool Add(T x)
        {
            int topLevel = new Random().Next(0, MAX_LEVEL); //для ноды случайно выбирается уровень
            int bottomLevel = 0; //нижний уровень 
            Node<T>[] preds = new Node<T>[MAX_LEVEL + 1]; //массив предыдущих
            Node<T>[] succs = new Node<T>[MAX_LEVEL + 1]; //массив успешных
            while (true) //бесконечный цикл
            {
                bool found = Find(x, preds, succs); //проверяем найден элемент или нет
                if (found) //если найден
                {
                    return false; //говорим, что не добавили
                }
                else //иначе
                {
                    Node<T> succ; //успешная нода
                    Node<T> newNode = new Node<T>(x, topLevel); //создаем новую ноду
                    for (int level = bottomLevel; level <= topLevel; level++) // гуляем по уровням с нижнего до верхнего
                    {
                        succ = succs[level]; //успешный берем из массива успешных по индексу текущего уровня
                        newNode.Next[level].Set(succ, false); //у новой ноды индекс на следующий ставим на успешный и не отмеченный
                    }
                    Node<T> pred = preds[bottomLevel]; //предыдущий берем из предыдущих с нижнего уровня
                    succ = succs[bottomLevel]; //успешный становится успешным на нижнем уровне
                    if (!pred.Next[bottomLevel].CompareAndSet(succ, newNode, false, false))
                    {
                        //если не удалось на нижнем уровне заменить успешный на новую ноду, продолжаем цикл
                        continue;
                    }
                    for (int level = bottomLevel + 1; level <= topLevel; level++) //с нижнего уровня + 1 до верхнего
                    {
                        while (true) //бесконечный цикл
                        {
                            pred = preds[level];// берем предыдущий из предыдущих на текущем уровне
                            succ = succs[level];// берем успешный из успешных на текущем уровне
                            if (pred.Next[level].CompareAndSet(succ, newNode, false, false))
                                //если получилось поменять у предыдущей ноды указатель на следующий на новую ноду 
                                break; //выходим из цикла
                            //иначе, если нас опередели, получем новые успешные и новые текущие
                            Find(x, preds, succs);
                        }
                    }
                    return true; //возвращаем, что добавили успешно
                }
            }
        }

        bool Remove(T x)
        {
            int bottomLevel = 0; //нижний уровень 
            Node<T>[] preds = new Node<T>[MAX_LEVEL + 1]; //массив предыдущих
            Node<T>[] succs = new Node<T>[MAX_LEVEL + 1]; //массив удачных
            Node<T> succ; //ужачная нода
            while (true) //бесконечный цикл
            {
                bool found = Find(x, preds, succs); //ищем удаляемый элемент
                if (!found) //если не нашли
                {
                    return false; //кричим, что его нет и мы не удалили
                }
                else //иначе
                {
                    bool marked;
                    Node<T> nodeToRemove = succs[bottomLevel]; //нода для удаления - успешная на нижнем уровне
                    for (int level = nodeToRemove.TopLevel; level >= bottomLevel + 1; level--) 
                        //с верхнего уровня ноды, до нижнего + 1 ходим
                    {
                        marked = false; 
                        succ = nodeToRemove.Next[level].Get(out marked); //получем следующий за удаляемым и его отметку
                        while (!marked) //пока не отмечено
                        {
                            //устанавливаем уследующей за удаляемой нодой отметку на удаление
                            nodeToRemove.Next[level].CompareAndSet(succ, succ, false, true);
                            succ = nodeToRemove.Next[level].Get(out marked); //берем следующий элемент
                        }
                    }
                    marked = false;
                    succ = nodeToRemove.Next[bottomLevel].Get(out marked); //берем в успешный следующий у удаляемого на нижнем уровне
                    while (true) //бесконечный цикл
                    {
                        bool iMarkedIt =
                        nodeToRemove.Next[bottomLevel].CompareAndSet(succ, succ, false, true);
                        //отметка Я пометил его успешо ли у успешного поменялась отметка
                        succ = succs[bottomLevel].Next[bottomLevel].Get(out marked);
                        //в отметку кладем из успешных на нижнем уровне следующий за ним
                        if (iMarkedIt)
                        { //если я его отметил
                            Find(x, preds, succs); //физически удаляю
                            return true; //говорю тру
                        }
                        else if (marked) return false; //если отмечен на удаление, говорим, не удалили
                    }
                }
            }
        }

        //возвращает нашел или нет
        bool Find(T x, Node<T>[] preds, Node<T>[] succs)
        {
            int bottomLevel = 0; //нижний уровень
            int key = x.GetHashCode(); //берем ключ у сикомого значения
            bool marked = false; //отметка
            bool snip; //успешность операции устновки
            Node<T> pred = null, curr = null, succ = null; //предыдущий, текущий, успешный
            retry: //метка
            while (true) //бесконечный цикл
            {
                pred = head; //в предыдущий сохраняем голову 
                for (int level = MAX_LEVEL; level >= bottomLevel; level--) //пока уровень больше либо равен нижнему ходим с верхнего
                {
                    curr = pred.Next[level].GetReference(); //в текущий сохраняем ссылку на следующий у предыдущего на текущем уровне
                    while (true) //бесконечный цикл
                    {
                        succ = curr.Next[level].Get(out marked); //в успешный сохраняем следующий у текущего на данном уровне, берем отметку
                        //предполагаем физическое удаление цепочки отмеченых
                        while (marked) //пока отмечено
                        {
                            //пытаемся ссылку на следующий перекинуть на следующий у текущего
                            snip = pred.Next[level].CompareAndSet(curr, succ, false, false);
                            if (!snip) goto retry; //если не получилось идем в верхний бесконечный цикл
                            curr = pred.Next[level].GetReference(); // иначе в текущий кладем следующий у предыдущего
                            succ = curr.Next[level].Get(out marked); // в успешный кладем следующий у текущего и получем его метку
                        }
                        if (curr.Key < key) //если ключ текущего меньше искомого ключа
                        {
                            //предыдущий двигаем на текущий, а текущий на следующий 
                            pred = curr; curr = succ; 
                        }
                        else
                        {
                            //выходим из цикла
                            break;
                        }
                    }
                    preds[level] = pred; //предыдущий на уровне 
                    succs[level] = curr; //успешный на уровне
                }
                return (curr.Key == key); //возвращаем равенство ключей
            }
        }

        public bool Contains(T x)
        {
            int bottomLevel = 0; //нижний уровень
            int v = x.GetHashCode(); //берем ключ у искомого
            bool marked = false; //отметка
            Node<T> pred = head, curr = null, succ = null; //предыдущий на голову, тукущий и успешный пока пустые
            for (int level = MAX_LEVEL; level >= bottomLevel; level--) //с максимального уровня дл нижнего
            {
                //был косяк
                curr = pred.Next[level].GetReference(); // в текущий кладем следующий у предыдущего
                while (true) //в бесконечном цикле
                {
                    succ = curr.Next[level].Get(out marked); //успешный - следующий у текущего и получается метка
                    while (marked) //пока помечено
                    {
                        //пока идет процесс удаления
                        curr = pred.Next[level].GetReference(); // в текущий кладем следующий у предыдущего
                        succ = curr.Next[level].Get(out marked); //успешный - следующий у текущего и получается метка
                    }
                    if (curr.Key < v) //если ключ текущего меньше нашего значения
                    {
                        pred = curr; //двигаем предыдущий
                        curr = succ; //двигаем следующий
                    }
                    else //иначе
                    {
                        break; //идем на следующий уровень
                    }
                }
            }
            return (curr.Key == v); //тру = ключ текущего равен искомому
        }
    }
}
