using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LocksContinued.Locks
{
    class LamportBakeryLock : ILock
    {
        volatile bool[] flags;
        volatile Label[] labels;

        public LamportBakeryLock(int n)
        {
            flags = new bool[n];
            labels = new Label[n];
            for (int i = 0; i < n; i++)
            {
                flags[i] = false;
                labels[i].Value = 0;
            }
        }

        public void Lock()
        {
            int i = ThreadID.Get();
            flags[i] = true;
            labels[i].Value = labels.Max(x => x.Value) + 1;

            while (labels.Select((label, index) =>

                (index != i) &&
                flags[index] &&
                ((labels[index].Value < labels[i].Value) 
                || (labels[index].Value == labels[i].Value) 
                && index < i))

            .Aggregate(false, (x, y) => x || y)) { };
        }

        public void Unlock()
        {
            flags[ThreadID.Get()] = false;
        }
    }

    public struct Label
    {
        public int Value;
    }
}
