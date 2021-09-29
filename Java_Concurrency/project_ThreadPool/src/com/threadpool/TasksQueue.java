package com.threadpool;

public class TasksQueue<T>                                                               // Потокобезопасная очередь
{

    private TasksBox<T> head = null;
    private TasksBox<T> tail = null;
    private int size = 0;

    public synchronized void push(T obj) {
        TasksBox<T> ob = new TasksBox<>();
        ob.setObject(obj);
        if (head == null) {            head = ob;        }
        else {            tail.setNext(ob);        }
        tail = ob;
        size++;
    }

    public synchronized T pull() {
        if (size == 0) {			return null;		}
        T obj = head.getObject();
        head = head.getNext();
        if (head == null) {			tail = null;		}
        size--;
        return obj;
    }

    public synchronized T get(int index) {
        if(size == 0 || index >= size || index < 0) {			return null;		}
        TasksBox<T> current = head;
        int pos = 0;
        while(pos < index) {
            current = current.getNext();
            pos++;
        }
        T obj = current.getObject();
        return obj;
    }

    public synchronized int size() {		return size;	}

    private class TasksBox<T>
    {
        private T object;
        private TasksBox<T> next;

        protected T getObject() {			return object;		}
        protected void setObject(T object) {			this.object = object;		}
        protected TasksBox getNext() {			return next;		}
        protected void setNext(TasksBox<T> next) {			this.next = next;		}
    }

}
