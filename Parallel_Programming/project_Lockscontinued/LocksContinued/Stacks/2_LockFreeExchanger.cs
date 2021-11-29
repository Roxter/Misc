using LocksContinued.WorkStealing;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LocksContinued.Stacks
{
    //Объект LockFreeExchanger <T> позволяет двум потокам обмениваться значениями типа T.
    //если поток A вызывает метод объекта exchange() с аргументом а, 
    //а B вызывает метод exchange() того же объекта с аргументов b
    //тогда вызов у A вернет b и наоборот

    //На высоком уровне обменник работает так, что первый поток прибывает, чтобы записать его значение, 
    //и вращается, пока не прибудет второй. Затем второй обнаруживает, что первый ожидает, 
    //считывает его значение и сигнализирует об обмене. 
    //Каждый из них теперь прочитал значение другого и может выйти из метода.

    //Вызов первого потока может прерваться, если второй не появляется, 
    //что позволяет ему продолжить работу и покинуть обменник, если он не может обменять значение 
    //в течение разумного периода времени. 

    public class LockFreeExchanger<T>
    {
        //состояния
        const int Empty = 0;
        const int Waiting = 1;
        const int Busy = 2;
        
        AtomicStampedReference<T> slot = new AtomicStampedReference<T>(default(T), 0); //1 слот с отметкой о состоянии
        public T Exchange(T myItem, TimeSpan timeout)
        {
            DateTime timeBound = DateTime.Now.Add(timeout); //разумное время
            int stamp = Empty; //штамп, отвечающий за состояние обменника сначала пуст
            while (true) //бесконечный цикл
            {
                if (DateTime.Now > timeBound)
                    throw new TimeoutException(); //если разумное время вышло кидаем исключение, что не дождались
                T yrItem = slot.Get(out stamp); //сохраняем значение слота и узаем его штамп

                switch (stamp)
                {
                    case Empty: //если штамп пустой
                        //пытаемся поместить свой элемент в слот и поменять штамп с пустого на ожидающий
                        if (slot.CompareAndSet(yrItem, myItem, Empty, Waiting))
                        {
                            //его элемент в слоте состояние ожидания
                            //ждем пока другой поток совершит обмен
                            while (DateTime.Now < timeBound) //пока не истекло разумное время
                            {
                                //если он пришел, он положил свой элемент в слот и установил занят

                                yrItem = slot.Get(out stamp); //берем элемент из слота и его штамп
                                if (stamp == Busy) //если он занят, значит обмен завершен
                                {
                                    slot.Set(default(T), Empty); //устанивливаем дефолтное значение слота и пустой обменник
                                    return yrItem; //возвращаем значение, которое забрали
                                }
                            }
                            //если не пришел и кто-то пытается с waiting на busy поменять значение
                            if (slot.CompareAndSet(myItem, default(T), Waiting, Empty))
                                //если получилось поменять наше значение на дефолт и ожидание на пустой
                            {
                                throw new TimeoutException(); //время вышло
                            }
                            else
                            {
                                yrItem = slot.Get(out stamp);//берем значение из слота
                                slot.Set(default(T), Empty); //устанивливаем его пустым
                                return yrItem; //возвращаем, что добыли
                            }
                        }
                        //если нет, то нас опередили, пробуем снова
                        break;
                    case Waiting:
                        //поток ожидает нас
                        if (slot.CompareAndSet(yrItem, myItem, Waiting, Busy)) 
                            //взятый элемент пытается заменить собственным и установить окончание обмена
                            return yrItem;
                        break;
                    case Busy:
                        //обмен завершен, ничего делать не нужно
                        break;
                    default: // impossible
                        throw new InvalidOperationException();
                }
            }
        }
    }
}
