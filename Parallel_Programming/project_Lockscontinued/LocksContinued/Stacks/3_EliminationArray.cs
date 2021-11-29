using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LocksContinued.Stacks
{
    public class EliminationArray<T>
    {
        private const int duration = ...;
        LockFreeExchanger<T>[] exchanger; //масив объектов обменников
        Random random;
        public EliminationArray(int capacity)
        {
            exchanger = new LockFreeExchanger<T>[capacity]; //колчисетво обменников
            for (int i = 0; i < capacity; i++)
            {
                exchanger[i] = new LockFreeExchanger<T>(); //инициализирует новый обменник
            }
            random = new Random(); //инициализирует генератор случайных чисел
        }
        public T Visit(T value, int range)
        {
            //поток, пытающийся выполнить обмен случайно выбирает обменник из массива в заданом диапазоне 
            int slot = random.Next(range);
            //обменивается или получает исключение
            return (exchanger[slot].Exchange(value, new TimeSpan(0, 0, 0, 0, duration))); 

        }
    }
}
