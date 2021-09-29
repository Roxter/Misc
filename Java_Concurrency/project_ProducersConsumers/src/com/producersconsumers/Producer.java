package com.producersconsumers;

import static java.lang.Thread.currentThread;
import static java.lang.Thread.sleep;

public class Producer implements Runnable {                                      // Класс производителей

    private Store store;
    private Thread thread = new Thread();
    private int length_buff = Main.length_buff;
    private int rand_max = Main.rand_max;
    private int rand_var;

    Producer(Store store) {        this.store = store;    }

    @Override
    public void run() {                                                       // Запуск задачи "загадать число - положить в список"
        do {
            try {
                //if (length_buff != 0) {
                rand_var = (int)(Math.random()*rand_max);                // Загадывание числа от 0 до rand_max
                store.putCall(rand_var);                                 // Запись в список

                sleep(500);                                        // Ждем 0.5 сек

                rand_var = (int)(Math.random()*rand_max);
                store.putCall(rand_var);                                // Второе последовательное добавление
                System.out.println("Setter_id:" + thread.getId() + " Value is:" + rand_var + " Store filled on:" + store.getSize());
                //length_buff--;
                //}
            } catch(InterruptedException e) {                currentThread().interrupt();            }
        } while (!currentThread().isInterrupted());
        System.out.println("Producer_id=" + thread.getId() + " is closed.");
    }

}