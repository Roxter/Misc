using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;

namespace LocksContinued.Locks
{
    class TASLock : ILock
    {
        volatile int state = 0; // 0 - свободно, 1 -занято

        public void Lock()
        {
            //пока предыдущее состояние = занято, пытаемся вместо 0 поставить 1
            while (Interlocked.CompareExchange(ref state, 1, 0) == 1) { }
        }

        public void Unlock()
        {
            state = 0; //скидываем состояние в 0
        }
    }
}

