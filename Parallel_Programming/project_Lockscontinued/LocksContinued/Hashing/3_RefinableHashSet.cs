using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LocksContinued
{
    //уточнить детализацию блокировки по мере увеличения размера таблицы, чтобы число мест в полосе не увеличивалось непрерывно
    //Одним из ограничений этого алгоритма является то, что потоки не могут получить доступ к элементам в таблице во время изменения размера.
    public class RefinableHashSet<T>:BaseHashSet<T>
    {
        AtomicMarkableReference<Thread> _owner; // владелец - ссылка на поток + логическое значение в прцессе изменения размера
        //владелец используется как флаг взаимного исключения между resize и любым add
        volatile Mutex[] _locks; //массив блокировок
        public RefinableHashSet(int capacity) : base(capacity) //вызываем конструктор базового класса
        {

            _locks = new Mutex[capacity];  //инициализируем список блокировок в размере вместимости
            for (int i = 0; i < capacity; i++)
            {
                _locks[i] = new Mutex();//для каждого бакета инициализируем свой мьютекс (на начальном этапе)
            }
            _owner = new AtomicMarkableReference<Thread>(null, false); //никто не меняет размер, поэтому владелец null
        }

        protected override bool PolicyDemandsResize
        {
            get
            {
                return _setSize / _table.Length > 4;  //средняя длина бакета привышает 4
            }
        }

        protected override void Acquire(T x)
        {
            bool mark = true; //метка изменения размера
            Thread me = Thread.CurrentThread; //инициализация себя
            Thread who;
            while (true) //бесконечный цикл
            {
                do
                {
                    who = _owner.Get(out mark); //получаем владельца и складываем его метку
                } while (mark && who != me); //пока изменяется размер и я не владелец
                Mutex[] oldLocks = _locks; //запоминаем старые блокировки
                Mutex oldLock = oldLocks[x.GetHashCode() % oldLocks.Length]; //запоминаем старую блокировку, которую хотели взять
                oldLock.WaitOne(); //блокируем ее
                who = _owner.Get(out mark); //получаем владельца изменения размера
                if ((!mark || who == me) && _locks == oldLocks) //если не меняется размер или я владелец и никто не менял блокировки
                {
                    return; //получаем нужную блокировку
                }
                else
                {
                    oldLock.ReleaseMutex(); //отпускаем нужную блокировку
                }
            }
        }
        protected override void Release(T x)
        {
            _locks[x.GetHashCode() % _locks.Length].ReleaseMutex(); //снять нужную блокировку
        }

        protected override void Resize()
        {
            int oldCapacity = _table.Length; //запоминаем старый размер
            int newCapacity = 2 * oldCapacity; //вычисляем новый размер

            bool mark = false; //метка изменения размера 
            Thread me = Thread.CurrentThread; //определяем текущий поток
            if (_owner.CompareAndSet(null, me, false, true)) //если получилось установить себя владельцем изменения
            {
                try
                {
                    if (_table.Length != oldCapacity) //если текущий размер таблицы не совпадает со старым
                    { 
                        return; //кто=то нас опередил
                    }

                    foreach (Mutex m in _locks) //дожидаемся пока другие отдадут блокировки, потому что менять будем
                    {
                        m.WaitOne();//по очереди берем все мьютексы
                        m.ReleaseMutex();//отпускаем все мьютексы
                    }

                    List<T>[] oldTable = _table;  //запоминаем старую таблицу
                    _table = new List<T>[newCapacity]; //инициализирует таблицу новым списком бакетов с новым размером
                    for (int i = 0; i < newCapacity; i++)
                        _table[i] = new List<T>();//инициализирует список в каждом бакете

                    _locks = new Mutex[newCapacity]; //инициализирует таблицу новым списком блокировок с новым размером
                    for (int i = 0; i < newCapacity; i++)
                    {
                        _locks[i] = new Mutex(); //для каждого бакета инициализируем свой мьютекс
                    }

                    foreach (List<T> bucket in oldTable)
                    {
                        foreach (T x in bucket)
                        {
                            _table[x.GetHashCode() % _table.Length].Add(x); //переносит каждый элемент старой таблицы в новую, с учтом нового размера
                        }
                    }
                }
                finally
                {
                    _owner.Set(null, false); //снимает с себя владение измененим размера
                }
            }
        }
    }
}
