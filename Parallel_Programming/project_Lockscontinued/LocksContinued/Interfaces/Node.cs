namespace LocksContinued
{
    public class Node<T>
    {
        public T Value; //значение
        public int Key; //ключ
        public Node<T> Next; //указатель на следующий
        public ILock Lock = new SimpleLock(); //блокировка на узел
        public bool Marked = false; //отметка на удаление

        public Node(int key)
        {
            Key = key;
        }

        public Node(T value)
        {
            Value = value;
            Key = Value.GetHashCode();
        }

        public override int GetHashCode()
        {
            return Key;
        }
    }
}