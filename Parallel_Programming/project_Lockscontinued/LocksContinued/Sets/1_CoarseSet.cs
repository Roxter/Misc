using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LocksContinued.Sets
{
    //блокируется и на добавление и на запись на одном объекте
    public class CoarseList<T>
    {
        private Node<T> head; //голова списка
        private object sync = new object(); //объект синхронизации для монитора
        public CoarseList()
        {
            head = new Node<T>(int.MinValue); //фиктивный начальный элемент
            head.Next = new Node<T>(Int32.MaxValue); //фиктивный конечный элемент
        }

        public bool Add(T item)
        {
            Node<T> pred, curr; //объявляем следующий и предыдущий для вставляемого узла
            int key = item.GetHashCode(); //ключ - то, куда мы вставляем
            Monitor.Enter(sync); //захватывам монитор
            try
            {
                pred = head; //голова множества
                curr = pred.Next; //текущий, следующий за фиктивным элемент
                while (curr.Key < key) //пока ключ куда вставлять больше, чем ключ текущего элемента, двигаемся по списку
                    //ищем место для вставки перед текущим!
                {
                    pred = curr;
                    curr = curr.Next;
                }
                //если ключ уже есть, то возвращаем, что элемент не был добавлен
                if (key == curr.Key)
                {
                    return false;
                }
                //если нет
                else
                {
                    //создаем новый узел, с тем, что нам дали для вставки
                    Node<T> node = new Node<T>(item);

                    //указатель на следующего у нового узла, делаем равным текущему
                    node.Next = curr;
                    //указатель у того, что было перед текущим, на следующий элемент перебрасываем на нашу новую ноду
                    pred.Next = node;
                    //говорим, что добавили
                    return true;
                }
            }
            finally
            {
                //в любом случае снимаем блокировку
                Monitor.Exit(sync);
            }
        }

        public bool Remove(T item)
        {
            Node<T> pred, curr; // объявляем текущий и тот что идет перед ним
            int key = item.GetHashCode(); // берем ключ, того что будет добавлено
            Monitor.Enter(sync);// берем блокировку
            try
            {
                pred = head; //берем фиктивную голову
                curr = pred.Next;//берем первый элемент за фиктивной головой
                while (curr.Key < key) 
                    //ищем элемент, который будем удалять по ключу
                {
                    pred = curr;
                    curr = curr.Next;
                }
                //если текущий равен удаляемому, значит указатель на следующий элемент у того, что перед удаляемым, перекидываем
                //на следующий у удаляемого
                //говорим, что успешно удалили
                if (key == curr.Key)
                {
                    pred.Next = curr.Next;
                    return true;
                }
                //если не равен, тогда элемента нет, говорим, что не смогли
                else
                {
                    return false;
                }
            }
            finally
            {
                //в любом случае снимаем блокировку с монитора
                Monitor.Exit(sync);
            }
        }
    }
}
