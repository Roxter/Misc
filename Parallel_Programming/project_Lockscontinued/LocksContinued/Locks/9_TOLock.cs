using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LocksContinued.Locks
{
    // блокировка представляет собой виртуальную очередь узлов, 
    //и каждый поток вращается на узле своего предшественника, ожидая снятия блокировки.
    //Вместо этого мы используем ленивый подход: когда время ожидания потоком истекает, он отмечает свой узел как покинутый. 
    //Его преемник в очереди, если он есть, замечает, что узел, на котором он вращается, был остановлен, и начинает вращаться на предшественнике брошенного узла. 
    //Этот подход имеет дополнительное преимущество, заключающееся в том, что преемник может перезапустить оставленный узел.
    public class TOLock:IMaybeLock
    {
        
        static QNode AVAILABLE = new QNode();

        volatile QNode tail = null;// хвост
        ThreadLocal<QNode> myNode = new ThreadLocal<QNode>(() => new QNode()); //наша нода

        public bool TryLock(long patienceInMs)
        {
            DateTime startTime = DateTime.Now;

            QNode qnode = new QNode(); //создаем новую ноду
            myNode.Value = qnode; //кладем ее к нам
            qnode.pred = null; //указатель на предыдущий делаем пустым
            QNode myPred = Interlocked.Exchange(ref tail, qnode); //добавляем его в список вместо хвоста
            if (myPred == null || myPred.pred == AVAILABLE) //если блокировка была свободная
            {
                return true; //входим в критическую секцию
            }
            while (DateTime.Now.Subtract(startTime).TotalMilliseconds < patienceInMs) //идем ждать изменения поля pred пока не истек таймаут
            {
                QNode predPred = myPred.pred; //берем предыдущий у нашей ноды
                
                if (predPred == AVAILABLE) //доступен
                {
                    return true; //входим в секцию
                }
                // it's abandoned
                else if (predPred != null) 
                {
                    myPred = predPred; //перекидываем наш предыдущий на предыдущий преддущего
                }
            }
            //если время у нас истекло
            if (Interlocked.CompareExchange(ref tail, myPred, qnode) != qnode) //пытаемся удалить свою ноду из списка, если мы хвост 
                // если у нас есть приемник, предыдущее у себя перекидываем на ноду                                          
                qnode.pred = myPred;
            return false;
        }

        public void Unlock()
        {
            QNode qnode = myNode.Value; //получаем нашу ноду
            if (Interlocked.CompareExchange(ref tail, null, qnode) != qnode) //проверяем если приемник,если есть то устанавливает AVAILABLE
                qnode.pred = AVAILABLE;
        }

        class QNode
        {
            //когда поле pred ссылается на AVAILABLE, связанный поток снял блокировку
            //если pred ссылается на любую другую ноду, то связанный поток отказался от запроса на блокировку, 
            //поэтому поток, которому принадлежит узел-преемник, должен ожидать предшественника покинутого узла. 
            public volatile QNode pred = null; //ссылка на предыдущий
        }
    }
}
