﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LocksContinued.Hashing
{
    public abstract class PhasedCuckooHashSet<T>
    {
        volatile protected int capacity;
        volatile protected List<T>[,] table;
        public PhasedCuckooHashSet(int size)
        {
            capacity = size;
            table = new List<T>[2, capacity];


        }

        protected int Hash0(T i)
        {
            return i.GetHashCode();
        }

        protected int Hash1(T i)
        {
            return i.GetHashCode();
        }

        public bool Present(T x)
        {
            return true;
        }

        protected abstract void Acquire(T x);
        protected abstract void Release(T x);
        protected abstract void Resize();

        public bool Remove(T x)
        {
            Acquire(x);
            try
            {
                List<T> set0 = table[0, Hash0(x) % capacity];
                if (set0.Contains(x))
                {
                    set0.Remove(x);
                    return true;
                }
                else
                {
                    List<T> set1 = table[1, Hash1(x) % capacity];
                    if (set1.Contains(x))
                    {
                        set1.Remove(x);
                        return true;
                    }
                }
                return false;
            }
            finally
            {
                Release(x);
            }
        }

        public bool Add(T x)
        {
            T y =default(T);
            Acquire(x);
            int h0 = Hash0(x) % capacity, h1 = Hash1(x) % capacity;
            int i = -1, h = -1;
            bool mustResize = false;
            try
            {
                if (Present(x)) return false;
                List<T> set0 = table[0, h0];
                List<T> set1 = table[1, h1];
                if (set0.Count < THRESHOLD)
                {
                    set0.Add(x); return true;
                }
                else if (set1.Count < THRESHOLD)
                {
                    set1.Add(x); return true;
                }
                else if (set0.Count < PROBE_SIZE)
                {
                    set0.Add(x); i = 0; h = h0;
                }
                else if (set1.Count < PROBE_SIZE)
                {
                    set1.Add(x); i = 1; h = h1;
                }
                else
                {
                    mustResize = true;
                }
            }
            finally
            {
                Release(x);
            }
            if (mustResize)
            {
                Resize(); Add(x);
            }
            else if (!Relocate(i, h))
            {
                Resize();
            }
            return true; // x must have been present
        }

        protected bool Relocate(int i, int hi)
        {
            int hj = 0;
            int j = 1 - i;
            for (int round = 0; round < LIMIT; round++)
            {
                List<T> iSet = table[i, hi];
                T y = iSet[0];
                switch (i)
                {
                    case 0: hj = Hash1(y) % capacity; break;
                    case 1: hj = Hash0(y) % capacity; break;
                }
                Acquire(y);
                List<T> jSet = table[j, hj];
                try
                {
                    if (iSet.Remove(y))
                    {
                        if (jSet.Count < THRESHOLD)
                        {
                            jSet.Add(y);
                            return true;
                        }
                        else if (jSet.Count < PROBE_SIZE)
                        {
                            jSet.Add(y);
                            i = 1 - i;
                            hi = hj;
                            j = 1 - j;
                        }
                        else
                        {
                            iSet.Add(y);
                            return false;
                        }
                    }
                    else if (iSet.Count >= THRESHOLD)
                    {
                        continue;
                    }
                    else
                    {
                        return true;
                    }
                }
                finally
                {
                    Release(y);
                }
            }
            return false;
        }
    }
}