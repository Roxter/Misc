using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LocksContinued.Locks
{
    // В очереди каждый поток может узнать, наступил ли его ход, проверив, завершил ли его предшественник. 
    //Трафик когерентности кэша уменьшается за счет вращения каждого потока в разных местах. 
    //Очередь также позволяет лучше использовать критическую секцию, поскольку нет необходимости угадывать, 
    //когда пытаться получить к ней доступ: каждый поток уведомляется непосредственно своим предшественником в очереди. 
    public class ALock : ILock
    {
        ThreadLocal<int> mySlotIndex = new ThreadLocal<int>(() => 0); //индекс слота для потока

        volatile int tail; //раздлеяемое поле хвоста
        volatile bool[] flag; //массив флагов - возможен falsesharing
        int size; //количество слотов - фиксировано

        public ALock(int capacity)
        {
            size = capacity;
            tail = 0;
            flag = new bool[capacity]; 
            flag[0] = true; //первый равен true
        }

        public void Lock()
        {
            //чтобы получить блокировку поток увеличивает хвост на 1 и получает слот 
            int slot = (Interlocked.Increment(ref tail)-1) % size; 
            mySlotIndex.Value = slot; //запоминаем в тредлокал переменную наш слот
            while (!flag[slot]) { };// если флаг[слот] = true, то получаем блокировку 
        }

        public void Unlock()
        {
            int slot = mySlotIndex.Value; //чтобы разблокироваться мы берем слот из тред локал переменной
            flag[slot] = false; //устанавливаем текущий слот в фолз
            flag[(slot + 1) % size] = true; //устанавливает флаг в следующем слоте в тру
        }
    }
}
