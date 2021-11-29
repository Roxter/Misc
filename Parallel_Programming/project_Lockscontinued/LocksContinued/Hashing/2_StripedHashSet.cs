using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LocksContinued
{
    //Вместо того, чтобы использовать одну блокировку для синхронизации всего набора, 
    //мы разбиваем набор на независимо синхронизированные части. 
    public class StripedHashSet<T> : BaseHashSet<T>
    {
        Mutex[] _locks; //массив мьютексов
        public StripedHashSet(int capacity) : base(capacity) //вызываем конструктор базового класса
        {
            _locks = new Mutex[capacity]; //инициализируем список блокировок в размере вместимости
            for (int i = 0; i < _locks.Length; i++)
            {
                _locks[i] = new Mutex(); //для каждого бакета инициализируем свой мьютекс (на начальном этапе)
            }
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
            _locks[x.GetHashCode() % _locks.Length].WaitOne(); //блокируем ассоциированный с нужным бакетом мьютекс
        }

        protected override void Release(T x)
        {
            _locks[x.GetHashCode() % _locks.Length].ReleaseMutex(); //снимаем с асоциированного с нужным бакетом мьютекса блокировку
        }

        //при изменении размера массив мьютексов не меняется, поэтому если будет сильно жирная, то с одним
        // будет связано много бакетов
        protected override void Resize()
        {
            int oldCapacity = _table.Length;// запоминает количество бакетов 

            foreach (Mutex m in _locks)//последовательно блокирует все мьютексы
            {
                m.WaitOne();
            }

            try
            {
                if (oldCapacity != _table.Length) //если старый размер таблицы не совпадает с текущим
                {
                    return; // кто-то нас опередил
                }
                int newCapacity = 2 * oldCapacity; //удваивает размер таблицы
                List<T>[] oldTable = _table; //запоминаем старую таблицу
                _table = new List<T>[newCapacity];  //инициализирует таблицу новым списком бакетов с новым размером
                for (int i = 0; i < newCapacity; i++)
                    _table[i] = new List<T>(); //инициализирует список в каждом бакете
                foreach (List<T> bucket in oldTable) 
                {
                    foreach (T x in bucket)
                    {
                        _table[x.GetHashCode() % _table.Length].Add(x);  //переносит каждый элемент старой таблицы в новую, с учтом нового размера
                    }
                }
            }
            finally
            {
                foreach (Mutex m in _locks) //последовательно разблокирует все мьютексы
                {
                    m.ReleaseMutex();
                }
            }
        }
    }
}
