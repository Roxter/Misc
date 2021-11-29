using LocksContinued.Locks;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LocksContinued.Stacks
{
    //Стек без блокировки - это связанный список, 
    //в котором верхнее поле указывает на первый узел (или налл, если стек пуст). 
    public class LockFreeStack<T>
    {
        volatile Node top = null;
        const int MIN_DELAY = ...;
        const int MAX_DELAY = ...;
        Backoff backoff = new Backoff(MIN_DELAY, MAX_DELAY); //для ожидания перед следующей попыткой


        protected class Node
        {
            public T Value; //значение
            public volatile Node Next; //указатель на следующую ноду
            public Node(T value)
            {
                this.Value = value;
                Next = null;
            }
        }

        public virtual void Push(T value)
        {
            Node node = new Node(value); //создаем новую ноду
            while (true)
            {
                if (TryPush(node)) //если попытка положить прошла удачно
                {
                    return; //пуш завершается
                }
                else
                {
                    backoff.DoBackoff(); //иначе пытаемся положить через некоторое время
                }
            }
        }

        protected bool TryPush(Node node)
        {
            Node oldTop = top; //запоминаем голову
            node.Next = oldTop; //у ноды указатель на следующий ставим старую голову
            return (Interlocked.CompareExchange(ref top, node, oldTop) == oldTop); 
            //если никто не изменил голову, заменяем ее на добавляемую ноду (должно вернуть предыдущее значение как старая голова)
        }

        public virtual T Pop()
        {
            while (true) //бесконечный цикл
            {
                Node returnNode = TryPop(); //возвращаемую ноду получаем попыткой удалить элемент сверху
                if (returnNode != null) //если не пустая нода
                {
                    return returnNode.Value; //возвращаем ее значение
                }
                else
                {
                    backoff.DoBackoff(); //ждем повторной попытки
                }
            }
        }

        protected Node TryPop()
        {
            Node oldTop = top; //запоминаем голову
            if (oldTop == null) { //попытка удалить элемент из пустого стека
                throw new InvalidOperationException(); //кидаем исключение
            }
            Node newTop = oldTop.Next; // новая голова - это указатель у старой головы на следующий
            if (Interlocked.CompareExchange(ref top, newTop, oldTop) == oldTop) {
                //если удалось заменить старую голову на новую
                return oldTop; //возвращаем старую
            }
            else
            { // иначе, говорим, что не добыли
                return null;
            }
        }
    }
}

