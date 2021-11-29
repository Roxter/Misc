using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace LocksContinued.Stacks
{
    //если сразу за push () следует pop (), две операции отменяются, и состояние стека не изменяется
    //то потоки, вызывающие push (), могут обмениваться значениями с потоками, вызывающими pop (), 
    //без изменения самого стека.
    //наследует неблокирующий стек
    public class EliminationBackoffStack<T> : LockFreeStack<T> {
        const int Capacity = ...; //вместимость
        const int Timeout = ...; //таймаут
        EliminationArray<T> eliminationArray = new EliminationArray<T>(Capacity);//новый массив обменников

        public override void Push(T value)
        {
            Node node = new Node(value); //создаем новую ноду
            while (true) //бесконечный цикл
            {
                if (TryPush(node)) //если трай пуш прошел успешно
                {
                    return; //выходим из метода добавления в стек
                }
                //если неуспешно
                else
                    try
                    {
                        T otherValue = eliminationArray.Visit(value, Timeout); //вызвать метод массива обменников 
                        //со своим значением, ждем поп
                        if (otherValue.Equals(default(T))) //если значение дефолтное
                        {
                            // таймаут
                            return; // значит все хорошо, мы обменялись
                        }
                    }
                    catch (TimeoutException ex)
                    {
                        // таймаут
                    }
            }
        }


        public override T Pop()
        {
            while (true)
            {
                Node returnNode = TryPop(); //пытаемся добыть значение из стека
                if (returnNode != null) //если пришло не пустое
                {
                    return returnNode.Value; //отдаем его
                }
                else try
                    {
                        //посещаем обменник с дефолтным значением
                        T otherValue = eliminationArray.Visit(default(T), Timeout);
                        if (otherValue != null) //если мы получили не нулевое значние
                        {
                            // some timeout policy actions
                            return otherValue; //отдаем его, потому что совершили обмен
                        }
                    }
                    catch (TimeoutException ex)
                    {
                        // some timeout policy actions
                    }
            }
        }
    }
}
