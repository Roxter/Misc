using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LocksContinued.Hashing
{
    //сделать реализацию хеш-набора свободной от блокировок и сделать изменение размера инкрементным, 
    //что означает, что каждый вызов метода add () выполняет небольшую часть работы, связанной с изменением размера. 

    //. В частности, храните все элементы в одном связанном списке без блокировки, аналогично классу LockFreeList, 
    //который изучался в главе 9. Контейнер - это просто ссылка на список. По мере роста списка мы вводим дополнительные ссылки 
    //на бакеты, чтобы ни один объект не находился слишком далеко от начала бакета. 
    //Этот алгоритм гарантирует, что после того, как элемент помещен в список, он никогда не перемещается, но он требует, 
    //чтобы элементы были вставлены в соответствии с рекурсивным алгоритмом разделения порядка 

    //Когда элемент с хэш-кодом k вставляется, удаляется или ищется, в хэш-наборе используется индекс сегмента k (mod N). 
    //Если емкость таблицы равна 2i, то индекс бакета целое число, представленное младшими значащими битами ключа(LSB);
    // другими словами, каждый бакет b содержит элементы, хэш каждого из которых  k удовлетворяет k = b (mod 2i)
    //
    public class LockFreeHashSet<T>
    {
        const int THRESHOLD = 4;

        private BucketList<T>[] bucket; //список бакетов 
        private int bucketSize; //какая часть массива бакетов используется в данное время
        private int setSize; //количество элементов в таблице, чтобы решить, надо ли менять размер
        public LockFreeHashSet(int capacity)
        {
            bucket = new BucketList<T>[capacity];// пустой список бакетов размером капасити
            bucket[0] = new BucketList<T>();//первый элемент - пустой список элементов
            bucketSize = 2; //емкость бакета 2 (0 и 1 потому что 2i)
            setSize = 0; //количество элементов в таблице
        }


        public bool Add(T x)
        {
            int myBucket = x.GetHashCode() % bucketSize; // получается бакет в который надо добавить
            BucketList<T> b = GetBucketList(myBucket);// инициализируем при необходимости
            if (!b.Add(x))
                return false;
            int setSizeNow = Interlocked.Increment(ref setSize);
            int bucketSizeNow = bucketSize;
            if (setSizeNow / bucketSizeNow > THRESHOLD)
                Interlocked.CompareExchange(ref bucketSize, bucketSizeNow, 2 * bucketSizeNow);
            return true;
            }

        private BucketList<T> GetBucketList(int myBucket)
        {
            if (bucket[myBucket] == null) //если бакета нет
                InitializeBucket(myBucket); //инициализирум бакет
            return bucket[myBucket]; //возвращаем бакет
        }
        private void InitializeBucket(int myBucket)
        {
            int parent = GetParent(myBucket); //получаем родителя бакета
            if (bucket[parent] == null) //если родителя нет, то
                InitializeBucket(parent); //инициализируем его
            BucketList<T> b = bucket[parent].GetSentinel(myBucket); 
            if (b != null)
                bucket[myBucket] = b;
        }

        private int GetParent(int myBucket)
        {
            int parent = bucketSize;
            do
            {
                parent = parent >> 1;
            } while (parent > myBucket);
            parent = myBucket - parent;
            return parent;
        }
    }
}
