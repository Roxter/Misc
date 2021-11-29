namespace LocksContinued
{
    internal class Window<T>
    {
        public AtomicNode<T> Pred, Curr; //поля предыдущий и текущий

        public Window(AtomicNode<T> myPred, AtomicNode<T> myCurr)
        {
            Pred = myPred;
            Curr = myCurr;
        }
    }
}