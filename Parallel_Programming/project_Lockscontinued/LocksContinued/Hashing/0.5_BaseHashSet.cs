using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LocksContinued
{
    public abstract class BaseHashSet<T>
    {
        protected List<T>[] _table; //список бакетов (закрытая адресацияя - каждый бакет = список элементов с одинкаовым хэшом)
        protected int _setSize; //количество элементов в таблице

        public BaseHashSet(int capacity)
        {
            _setSize = 0; //начальное количество 0
            _table = new List<T>[capacity]; //создаем список бакетов в количестве начальной вместимости 
            for (int i = 0; i < capacity; i++) 
            {
                _table[i] = new List<T>(); //для каждого бакета инициализируем свой список (где будут лежать все с одинаковым хэш)
            }
        }

        protected abstract bool PolicyDemandsResize { get; } //политика изменения размера

        protected abstract void Resize(); //изменить размер - увеличить в два раза 
        //чтобы размеры списков в бакете были +- постоянные
        protected abstract void Acquire(T x); //получает блокировки, необходимые для управления элементом + 
        //должна быть reentrant - то есть если поток вызвал этот метод, то при повторном вызове, он будет продолжен без
        //взаимной блокировки с собой
        protected abstract void Release(T x); //освобождает полученные блокировки

        //проверяет наличие элемента в таблице
        public bool Contains(T x)
        {
            Acquire(x); //необходимая синхронизация
            try
            {
                int myBucket = x.GetHashCode() % _table.Length; //вычисляется бакет в котором лежит
                return _table[myBucket].Contains(x); //проверяется есть ли в списке, который в бакете этот элемент
            }
            finally
            {
                //снимает блокировки
                Release(x);
            }
        }

        //добавляет элемент в таблицу
        public bool Add(T x)
        {
            bool result = false;  //предварительно предполагает, что добавить не получилось
            Acquire(x); //берет необходимые блокировки
            try
            {
                int myBucket = Math.Abs(x.GetHashCode() % _table.Length); //вычисляет в какой бакет положить
                if (!_table[myBucket].Contains(x)) //если там его еще нет
                {
                    _table[myBucket].Add(x); //добавляет в список нужного бакета элемент
                    result = true; //результать делает тру
                    _setSize++; //увеличивает количество элементов в таблице
                }
            }
            finally
            {
                //снимает необходимые блокировки
                Release(x);
            }
            if (PolicyDemandsResize) //если выполнилась политика, когда надо изменить размер
                Resize(); //удваивает таблицу, перераспределяет все, что в ней есть
            return result; //возвращает результат
        }
    }
}
