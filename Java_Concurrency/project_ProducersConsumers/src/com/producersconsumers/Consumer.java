package com.producersconsumers;

import static java.lang.Thread.currentThread;
import static java.lang.Thread.sleep;

public class Consumer implements Runnable {                                 // Класс потребителей

    private Store store;
    private Thread thread = new Thread();
    private int get_val;

    Consumer(Store store) {        this.store = store;    }

    @Override
    public void run() {                                             // Запуск задачи "изъять число"
        while (!currentThread().isInterrupted()) {
            try {
                get_val = store.getCall();                          // Изъятие числа из списка
                sleep(500);                                   // Ждем 0.5 сек
                get_val = store.getCall();                         // Второе последовательное извлечение
                if (get_val != Integer.MAX_VALUE) {
                    System.out.println("Getter_id:" + thread.getId() + " Value is:" + get_val + " Store filled on:" + store.getSize());
                } else {
                    System.out.println("Getter_id:" + thread.getId() + " attempt to access empty list");
                }
            } catch(InterruptedException e) {                currentThread().interrupt();            }
        }
        System.out.println("Consumer_id=" + thread.getId() + " is closed.");
    }

}