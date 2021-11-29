namespace LocksContinued
{
    public class AtomicNode<T>
    {
        public T Value; //значение
        public int Key; //ключ
        //ссылка на объект + битовый флаг = пометка на удаление 
        //обновл€ютс€ атомарно вместе или по отдельности
        public IAtomicMarkableReference<AtomicNode<T>> Next = new AtomicMarkableReference<AtomicNode<T>>(null); 
    }
}