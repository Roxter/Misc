using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LocksContinued
{
    //Вызовы методов действуют поочередно, даже если для них нет логической причины.
    public class CoarseHashSet<T> : BaseHashSet<T>
    {
        public Mutex _lock = new Mutex(); //примитив синхронизации
        public CoarseHashSet(int capacity) : base(capacity) //в конструкторе вызывается конструктор базового класса
        {
        }

        protected override bool PolicyDemandsResize
        {
            get
            {
                return _setSize / _table.Length > 4; //средняя длина бакета привышает 4
            }
        }
        protected override void Acquire(T x)
        {
            _lock.WaitOne(); //получает единственную блокировку мьютекса
        }

        protected override void Release(T x)
        {
            _lock.ReleaseMutex(); //отпускает блокировку единственного мьютекса
        }

        protected override void Resize() //удваивание хэш таблицы
        {
            int oldCapacity = _table.Length; //берет количество бакетов
            _lock.WaitOne();//берет блокировку мьютекса
            try
            {
                if (oldCapacity != _table.Length) //если старое количество бакетов не равно размеру таблицы
                {
                    return; // кто-то нас опередил
                }
                int newCapacity = 2 * oldCapacity; //удваиваем размер таблицы
                List<T>[] oldTable = _table; //запоминаем старую таблицу
                _table = new List<T>[newCapacity]; //инициализирует таблицу новым списком бакетов с новым размером
                for (int i = 0; i < newCapacity; i++)
                    _table[i] = new List<T>(); //инициализирует список в каждом бакете
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
                //снимает блокировку с мьютекса
                _lock.ReleaseMutex();
            }
        }
    }
}
