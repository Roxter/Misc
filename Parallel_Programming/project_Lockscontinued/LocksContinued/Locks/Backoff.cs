using System;
using System.Threading;

namespace LocksContinued.Locks
{
    public class Backoff
    {
        readonly int minDelay, maxDelay; //минимальное и максимальное время отступления потока
        int limit; // текущий предел задержки
        readonly Random random; //генератор случайных чисел

        public Backoff(int min, int max)
        {
            minDelay = min;
            maxDelay = max;
            limit = minDelay; //начинаем с минимальной задержки
            random = new Random(); 
        }

        public void DoBackoff()
        {
            int delay = random.Next(limit); //выбираем случайное число по лимиту
            limit = Math.Min(maxDelay, 2 * limit); //лимит устанавливаем либо максимальный, либо удвоенный текущий
            Thread.Sleep(delay); //спим задержку
        }
    }
}
