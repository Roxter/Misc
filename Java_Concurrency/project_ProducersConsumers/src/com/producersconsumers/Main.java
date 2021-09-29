package com.producersconsumers;

import java.io.IOException;

public class Main
{

    static final int length_buff = 20;                                         // Задается при необходимости ограничения размера хранилища
    static final int rand_max = 100;                                           // Максимальное загадываемое число

    public static void main(String[] args) {
        int prod_num = 10, cons_num = 20, prod_cons_max, prod_cons_num, current_threadnum;

        System.out.println("Store length:" + length_buff + ", Number of producers:" + prod_num + ", Number of consumers:" + cons_num + "\n");

        if(prod_num > cons_num) {                                               // Потребители должны создаваться сразу после производителей
            prod_cons_max = prod_num;
        } else {
            prod_cons_max = cons_num;
        }
        prod_cons_num = prod_num + cons_num;                                      // Переменная индексации массива ссылок на потоки
        System.out.println("Starting threads . . .");

        Store store = new Store();                                               // Хранилище загаданных чисел, ссылка будет передаваться потокам
        Thread[] threads_num = new Thread[prod_cons_num];

        current_threadnum = prod_cons_num - (prod_num + cons_num);
        for (int id = 0; id < prod_cons_max; id++) {                              // Создание, заполнение списка потоков и запуск потоков
            if (prod_num != 0) {
                Runnable producer = new Producer(store);
                threads_num[current_threadnum] = new Thread(producer);
                threads_num[current_threadnum].start();
                prod_num--;
                current_threadnum = prod_cons_num - (prod_num + cons_num);       // Счетчик созданных потоков, увеличивается по мере создания
            }
            if (cons_num != 0) {
                Runnable consumer = new Consumer(store);
                threads_num[current_threadnum] = new Thread(consumer);
                threads_num[current_threadnum].start();
                cons_num--;
                current_threadnum = prod_cons_num - (prod_num + cons_num);
            }
        }
        current_threadnum--;                                                   // Сохранить сдвиг для корректной индексации массива потоков при завершении
        System.out.println(current_threadnum + 1 + " threads is started. Press Enter to stop running . . .");

        try {
            System.in.read();                                                  // Ожидание нажатия клавиши для инициации завершения
        } catch (IOException e) {                e.printStackTrace();            }
        System.out.println("Closing all threads . . .");

        for(; current_threadnum >= 0 ; current_threadnum--) {                 // Завершение потоков
            threads_num[current_threadnum].interrupt();
            try {
                threads_num[current_threadnum].join();                       // Каждый поток должен до конца завершить свою работу
            }
            catch (InterruptedException e) { e.printStackTrace(); }
        }
        System.out.println("All threads is closed.");
    }

}