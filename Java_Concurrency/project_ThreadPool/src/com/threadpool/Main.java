package com.threadpool;

import java.util.ArrayList;
import java.util.List;
import static java.lang.Thread.currentThread;

public class Main {

    public static void main(String[] args) throws Exception {
        long start_time = System.nanoTime();
        final int max_threads_num = 100;
        final int tasks_num = 50;
        List<Tasks> task_list = new ArrayList<>();                                 // Для использования интерфейса List

        for (int i = 0; i < tasks_num; ++i)
            task_list.add(new Tasks(i));                                           // Создание объектов задач

        ThreadPool threadPool = new ThreadPool(max_threads_num);
        try (threadPool) {
            threadPool.setStartTime();
            for (Tasks task: task_list) {
                threadPool.enqueue(task);                                     // Последовательная передача задач объекту threadPool для записи их в очередь
                Thread.sleep(100 + (int) (Math.random() * (400 + 1)));  // Задержка для неравномерной передачи задач
            }
        }
    }

    private static class Tasks implements Runnable    {

        private Double var;

        Tasks(Integer num) {		var = new Double(num) + 1;	}                 // Параметром тангенса будет порядковый номер задачи

        @Override
        public void run() {
            for (int i = 0; i < 15_000_000; i++) {            var = var + Math.tan(var);        }
            System.out.println(currentThread().getName() + " is counted: " + var);
        }

    }

}