using System.Threading;

namespace LocksContinued.Monitors
{
    //Если читатели встречаются гораздо чаще, чем писатели, как это обычно бывает, 
    //то писатели могут быть надолго заблокированы постоянным потоком читателей.
    //показывает один из способов дать приоритет писателям. 
    //Этот класс гарантирует, что как только писатель вызовет метод lock () блокировки записи, 
    //больше никто из читателей не сможет получить блокировку чтения, пока писатель не установит 
    //и не снимет блокировку записи.
    public class FifoReadWriteLock
    {
        //когда они равны, ни один поток не удерживает блокировку на чтение
        volatile int readAcquires; //общее количество приобретений блокировки чтения 
        volatile int readReleases; //общее количество отпусканий блокировки чтения 
       
        volatile bool writer;
        object sync = new object(); //объект синхронизации
        ILock readLock, writeLock; //блокировка для читателей, блокировка для писателей

        public FifoReadWriteLock()
        {
            readAcquires = readReleases = 0;
            writer = false; //флаг читателя
            readLock = new ReadLock(this);
            writeLock = new WriteLock(this);
        }
        public ILock ReaderLock
        {
            get
            {
                return readLock; //отдать блокировку на запись
            }
        }

        public ILock WriterLock
        {
            get
            {
                return writeLock; //отдать блокировку на чтение
            }
        }

        class ReadLock : ILock
        {
            private FifoReadWriteLock parent; //родитель 

            public ReadLock(FifoReadWriteLock parent)
            {
                this.parent = parent;
            }

            public void Lock()
            {
                Monitor.Enter(parent.sync); //захватываем монитор 
                try
                {
                    while (parent.writer) //пока родитель писатель
                    { 
                        Monitor.Wait(parent.sync); //ждем нотификацию
                    }
                    parent.readAcquires++; //добавляем у родителя количество читателей
                }
                finally
                {
                    Monitor.Exit(parent.sync); //освобождаем монитор
                }
            }
            public void Unlock()
            {
                Monitor.Enter(parent.sync); //берем монитор
                try
                {
                    parent.readReleases++; //добавляем количество отпущенных читателей
                    // когда они равны, ни один поток не удерживает блокировку на чтение
                    if (parent.readAcquires == parent.readReleases) 
                        Monitor.PulseAll(parent.sync); //оповещаем ожидающих
                }
                finally
                {
                    Monitor.Exit(parent.sync); //освобождаем монитор
                }
            }
        }

        class WriteLock : ILock
        {
            private FifoReadWriteLock parent; //родитель 

            public WriteLock(FifoReadWriteLock parent)
            {
                this.parent = parent;
            }
            public void Lock()
            {
                Monitor.Enter(parent.sync); //берем маонитор
                try
                {
                    while (parent.writer)  //пока родитель писатель
                    {
                        Monitor.Wait(parent.sync); //ждем 
                    }
                    parent.writer = true; //устанавливаем родителя писатель в тру
                    while (parent.readAcquires != parent.readReleases)
                    {
                        //пока количество читалетей отпущеных не сровняется с кол-влм приобретенных
                        Monitor.Wait(parent.sync); //ждем
                    }
                }
                finally
                {
                    Monitor.Exit(parent.sync); //отпускаем монитор
                }
            }

            public void Unlock()
            {
                Monitor.Enter(parent.sync); //захватываем монитор
                try
                {
                    parent.writer = false; //устанавливаем писателя в фолз
                    Monitor.PulseAll(parent.sync); //оповещаем всех остальных
                }
                finally
                {
                    Monitor.Exit(parent.sync); //отпускаем монитор
                }
            }
        }
    }
}
