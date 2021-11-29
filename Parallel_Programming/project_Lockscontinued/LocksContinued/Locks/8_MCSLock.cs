using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LocksContinued.Locks
{
    public class MCSLock : ILock
    {
        QNode tail = null; //хвост 
        ThreadLocal<QNode> myNode = new ThreadLocal<QNode>(() => new QNode()); //наша нода
        public void Lock()
        {
            QNode qnode = myNode.Value; //берем нашу ноду
            QNode pred = Interlocked.Exchange(ref tail, qnode); //устанавливаем ее в хвост, получая предыдущий
            if (pred != null) //если предыдущий есть
            {
                qnode.Locked = true; //у нашей ноды выставляем интерес на блокировку
                pred.Next = qnode; //у предыдущего выставляем ссылку на следующий на нашу ноду
                // wait until predecessor gives up the lock
                while (qnode.Locked) { } //ждем пока предшественник не установит в поле фолз
            }
        }
        public void Unlock()
        {
            QNode qnode = myNode.Value; //берем свою ноду
            if (qnode.Next == null) //провреяем следущее пустое или нет
            {
                if (Interlocked.CompareExchange(ref tail, null, qnode) == qnode) //хвост в налл
                    return; //никакой другой поток не пытается получить блокировку

                while (qnode.Next == null) { } //ждем пока медленный поток не заявит о желании получить блокировку
            }
            qnode.Next.Locked = false; //у следующего выставляем состояние в фолз
            qnode.Next = null; //у нашей ноды ставим следующего в налл
        }
        class QNode
        {
            public volatile bool Locked = false; //состояние
            public volatile QNode Next = null; //указатель на следующий элемент списка
        }
    }
}
