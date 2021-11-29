using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LocksContinued.Locks
{
    // Мы используем термин «виртуальный», потому что список неявный: 
    //каждый поток ссылается на своего предшественника через локальную переменную pred
    public class CLHLock : ILock
    {
        class QNode
        {
            public volatile bool Locked = false; //если поле тру, то поток или получил блокировку или ожидает ее
        }

        volatile QNode tail = new QNode(); //состояние хвоста
        ThreadLocal<QNode> myPred = new ThreadLocal<QNode>(() => new QNode()); //состояние предыдущего
        ThreadLocal<QNode> myNode = new ThreadLocal<QNode>(() => new QNode()); //мое состояние

        public void Lock()
        {
            QNode qnode = myNode.Value;  //для получения блокировки берем наше состояние
            qnode.Locked = true; //устанавливаем его в тру, поток не готов снять блокировку
            QNode pred = Interlocked.Exchange(ref tail, qnode); // делается хвостом и получает ссылку на своего предыдущего 
            myPred.Value = pred; //сохраняет в совй тредлокал
            while (pred.Locked) { } //вращается пока предыдущий не снимет блокировку
        }

        public void Unlock()
        {
            QNode qnode = myNode.Value; //получаем наше состояние
            qnode.Locked = false; //скидываем флаг занятости
            myNode.Value = myPred.Value; //повторно использует ноду предшественника в качестве нового узла для блокировки
        }
    }
}
