using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LocksContinued.Locks
{
    public class TTASLock : ILock
    {
        volatile int state = 0;

        public void Lock()
        {
            while (true)
            {
                while (state == 1) { };  //ждем пока занято
                //если предыдущее вернулось свободен и вместо 0 удалось поставить 1, тогда взяли блокировку
                if (Interlocked.CompareExchange(ref state, 1, 0) == 0)
                    return;
            }
        }

        public void Unlock()
        {
            state = 0; //сбросить состояние
        }
    }
}