namespace LocksContinued
{
    //иногда полезно пометить узлы как логически удаленные, прежде чем физически удалять их из списка

    public class LockFreeSet<T>
    {
        private AtomicNode<T> _tail = new AtomicNode<T>(); //атомарная  запись хвост
        private AtomicNode<T> _head = new AtomicNode<T>(); //атомарная запись голова 

        public LockFreeSet()
        {
            _head.Next = new AtomicMarkableReference<AtomicNode<T>>(_tail); //следующий у головы указывает на хвост
        }

        public bool Add(T item)
        {
            int key = item.GetHashCode(); //получаем хэш того, что собрались добавить
            while (true) //бесконечный цикл
            {
                Window<T> window = Find(_head, key); //ищем окно в котором находится добавляемый элемент (предыдущий и текущий у добавлемого)
                AtomicNode<T> pred = window.Pred, curr = window.Curr; //инициализируем предыдущий и текущий из окна
                if (curr.Key == key) //если ключ текущего равен тому, что доавляем
                {
                    return false; //говорим, что добавить не удалось
                }
                else //иначе
                {
                    AtomicNode<T> node = new AtomicNode<T>() //заводим новую ноду под добавляемый элемент, где сслыка на следущий = текущий
                    {
                        Key = key,
                        Value = item,
                        Next = new AtomicMarkableReference<AtomicNode<T>>(curr, false)
                    };
                    //если у предыдущего указатель на следующий удалось с текущего заменить на новую ноду, то
                    if (pred.Next.CompareAndSet(curr, node, false, false))
                    {
                        return true; //говорим, что добавили 
                    }
                }
            }
        }

        public bool Remove(T item)
        {
            int key = item.GetHashCode();  // берем хэш удаляемого элемента
            bool snip; //флаг успешности утсановки
            while (true) //бесконечный цикл
            {
                Window<T> window = Find(_head, key); //ищем в каком окне наш элемент
                AtomicNode<T> pred = window.Pred, curr = window.Curr; //берем из окна предыдущий и текущий
                if (curr.Key != key) //если ключ текущего не равен ключу удаляемого, то
                {
                    return false; //говорим, что удалять нечего
                }
                else //иначе
                {
                    AtomicNode<T> succ = curr.Next.GetReference(); // берем следующий у текущего
                    //пытаемся у текущего следующий пометить на удаление (следующий не меняется, а меняется отметка)
                    snip = curr.Next.CompareAndSet(succ, succ, false, true); 
                    if (!snip) //если установка прошла неудачно
                        continue; // начинаем цикл с начала
                    //если успешно, пытаемся сменить у предыдущего указатель на следующий с текущего на следующий у текущего 
                    pred.Next.CompareAndSet(curr, succ, false, false);
                    return true; //говорим, что удалили
                }
            }
        }

        //физические не удаляет узлы
        public bool Contains(T item)
        {
            bool marked = false;
            int key = item.GetHashCode(); //берем хэш искомого
            AtomicNode<T> curr = _head; //текущий присваиваем голове
            while (curr.Key < key) // пока ключ текущего меньше ключа искомого
            {
                curr = curr.Next.GetReference(); // двигаем текущий на следующий за ним
                AtomicNode<T> succ = curr.Next.Get(out marked);  //взять следующий у текущего и положить отмечен текущий он или нет
            }
            return (curr.Key == key && !marked); //текущим не отмечен и у текущего совпадает ключ с искомым
        }

        //принимает голову и ключ 
        //пытается установить pred для узла с наибольшим ключом, меньшим чем key 
        //curr на узел с наименьшим ключом, большим или равным key
        private Window<T> Find(AtomicNode<T> head, int key) 
        {
            AtomicNode<T> pred = null, curr = null, succ = null; // атомарные записи
            bool marked; //помечен
            bool snip;// флаг успешности физического удаления

            while (true) //бесконечный цикл
            {
                 
                pred = head; //предыдущий указывает на голову
                curr = pred.Next.GetReference(); // текущий указывает на следующий за предыдущий
                while (true)//бесконечный цикл
                {
                    bool proceedWithNextCycle = false; //флаг , нужна ли обработка в еще одном цикле

                    succ = curr.Next.Get(out marked); //взять следующий у текущего и положить отмечен текущий или нет
                    while (marked) //пока помечен 
                    {
                        //пытаемся физически удалить узел, установив в текущем curr, значение следующего succ
                        snip = pred.Next.CompareAndSet(curr, succ, false, false); 
                        if (!snip) //если установка прошла неудачно
                        {
                            proceedWithNextCycle = true;// говорим, что обработан в соедующем цикле
                            break;//выходим из цикла с меткой
                        }
                        //если удачно прошло
                        curr = succ; //текущий устанавливаем в следующий
                        succ = curr.Next.Get(out marked); //следующий устанавливаем в следующий у текущего, получая метку для текущего
                    }

                    if (proceedWithNextCycle) break; //если нужена обработка, начинаем цикл с самого самого начала

                    if (curr.Key >= key)
                        return new Window<T>(pred, curr); //если ключ текущего больше или равен искомому ключу, то возвращаем 
                    //предыдущее и следующее - окно в котором элемент

                    pred = curr; //ждвигаем предыдущий в текущий
                    curr = succ; //двигаем текущий в следкющий
                }
            }
        }
    }

}
   
