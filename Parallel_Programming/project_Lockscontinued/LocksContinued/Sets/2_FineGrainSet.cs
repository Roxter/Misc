using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LocksContinued.Sets
{
    //Мы можем улучшить параллелизм, блокируя отдельные узлы, а не блокируя список в целом. Вместо того, 
    //чтобы устанавливать блокировку по всему списку, давайте добавим Lock к каждому узлу вместе с методами lock () и unlock ().
 
    public class FineGrainedSet<T>
    {
        private Node<T> head; //голова списка
        //private object sync = new object(); //объект синхронизации
        public FineGrainedSet()
        {
            head = new Node<T>(int.MinValue); //фиктивная голова
            head.Next = new Node<T>(Int32.MaxValue); //фиктивный хвост
        }

        public bool Add(T item)
        {
            int key = item.GetHashCode(); //получаем хэш того, что добавляем в множество
            head.Lock.Lock(); // берем блокировку на голову списка
            Node<T> pred = head; //устанавливаем предыдущий на голову
            try
            {
                Node<T> curr = pred.Next; //текущий устанавливаем на следующий от предыдущего
                curr.Lock.Lock(); //берем блокировку на текущий
                try
                {
                    while (curr.Key < key) //ищем место, куда добавить
                    {
                        pred.Lock.Unlock(); //разблокируем предыдущий
                        pred = curr; //перемещаем указатель с предыдущего на текущий
                        curr = curr.Next; //меняем текущий, на следующий
                        curr.Lock.Lock(); //блокируем текущий
                    }
                    //если на месте для вставки уже что-то есть, то кричим, что не добавили
                    if (curr.Key == key)
                    {
                        return false;
                    }
                    //иначе создаем новую ноду из добавляемого элемента
                    Node<T> newNode = new Node<T>(item);
                    newNode.Next = curr; //назначаем следующим элементом текущий
                    pred.Next = newNode;//у предыдущего назначаем следующим нашу новую ноду
                    return true; //говорим, что прошло успешно
                }
                finally
                {
                    //в любом случае снимаем блокировку с текущего узла
                    curr.Lock.Unlock();
                }
            }
            finally
            {
                //в любом случае снимаем блокировку с предыдущего узла
                pred.Lock.Unlock();
            }
        }

        //важно сохранять порядок блокировки
        public bool Remove(T item)
        {
            Node<T> pred = null, curr = null; //объявляем текущий и предыдущий
            int key = item.GetHashCode(); //получаем хэш того, что хотим добавить
            head.Lock.Lock(); // берем блокировку на голову
            try
            {
                pred = head; //присваиваем предыдущий
                curr = pred.Next; //присваиваем текущий
                curr.Lock.Lock(); //берем блокировку на текущий
                try
                {
                    while (curr.Key < key) //ищем, что удалить
                    {
                        pred.Lock.Unlock(); //снимаем блокировку на предыдущий
                        pred = curr; //присваиваем текущему предыдущий
                        curr = curr.Next; //текущему присваиваем следующий у текущего
                        curr.Lock.Lock(); //блокируем текущий
                    }
                    //если нашли ключ
                    if (curr.Key == key)
                    {
                        //перебрасываем указатель на следующий у Pred на следующий у curr 
                        pred.Next = curr.Next;
                        return true;
                    }
                    //иначе его там нет
                    return false;
                }
                finally
                {
                    //снимаем блокировку с текущего
                    curr.Lock.Unlock();
                }
            }
            finally
            {
                //снимаем блокировку с предыдущего
                pred.Lock.Unlock();
            }
        }
    }
    //Более того, потоки, обращающиеся к непересекающимся частям списка, могут по-прежнему блокировать друг друга. 
    //Например, поток, удаляющий второй элемент в списке, блокирует все параллельные потоки, ищущие более поздние узлы
}
