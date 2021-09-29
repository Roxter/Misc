package com.producersconsumers;

import java.util.ArrayList;

public class Store {                                                                // Потокобезопасное хранилище загаданных чисел

    private ArrayList<Integer> calls = new ArrayList<> ();

    public synchronized void putCall(int v) {        calls.add(v);    }

    public synchronized int getCall() {
        if (calls.size() != 0)
            return calls.remove(calls.size() - 1);
        else
            return Integer.MAX_VALUE;                                                    // Число-маркер отсутствия чисел в списке
    }

    public synchronized int getSize() {        return calls.size();    }

}