package com.threadpool;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicInteger;
import static java.lang.Thread.currentThread;

public class ThreadPool implements AutoCloseable {

    private AtomicBoolean is_closed = new AtomicBoolean(false);
    private TasksQueue<Runnable> tasks_queue = new TasksQueue<Runnable>();
    private List<Thread> threads = new ArrayList<>();
    private final Object new_task_notify = new Object();
    private final Object close_notify = new Object();
    private AtomicInteger free_threads_count;
    private int thread_num;
    private long start_time;
    private long end_time;

    public ThreadPool(int thread_num) {
        if (thread_num > 0) {
            this.start_time = start_time;
            this.thread_num = thread_num;                                         // Установка общего числа потоков
            free_threads_count = new AtomicInteger(this.thread_num);              // Установка счетчика свободных потоков на максимум
            initThreads(this.thread_num);
        }
        else
            System.out.println("Thread num = " + thread_num + " must be > 0!");
    }

    public void enqueue(Runnable task) {
        if (!is_closed.get()) {
            tasks_queue.push(task);
            synchronized (new_task_notify) {
                new_task_notify.notify();                                          // По приходу задачи разблокируется первый произвольный поток из числа свободных. Если свободных нет, они автоматически захватят задачу позже без необходимости уведомления
            }
        } else
            throw new RuntimeException("Thread pool is closed.");
    }

    public void setStartTime() {
        start_time = System.nanoTime();
    }

    private void initThreads(int threadNum) {                                     // Последовательное создание, запуск и заполнение списка потоков
        System.out.println("Starting work threads . . .");
        for (int i = 0; i < threadNum; ++i) {
            TaskWorker worker = new TaskWorker();                                 // Класс потока должен реализовывать Runnable, а не наследовать Thread
            Thread current_thread = new Thread(worker);                           // Создание объекта потока
            current_thread.setName("Thread №" + (i + 1));
            threads.add(current_thread);
            current_thread.start();
        }
        System.out.println(threadNum + " work threads is started.");
    }

    @Override
    public void close() throws InterruptedException {                               // Действия по завершению исполнения главного потока
        is_closed.set(true);                                                        // Отправка последнему потоку команды завершения
        if (tasks_queue.size() != 0 || free_threads_count.get() != thread_num) {    // Тредпул не должен войти в дедлок, при котором поток ждет задач от тредпула, а тредпул ждет ответа от потока о завершении задач, которые все уже выполнены
            while (true) {
                synchronized (close_notify) {
                    close_notify.wait();                                            // Ожидание у барьера ответа от последнего потока
                    if (is_closed.get() && tasks_queue.size() == 0 && free_threads_count.get() == thread_num)     // Убедились, что очередь пуста и все потоки освободились
                        break;
                }
            }
            end_time = System.nanoTime();
            System.out.println("");
        }

        for (Thread thread : threads) {
            thread.interrupt();                                                    // Последовательно завершаем потоки
            try {
                thread.join(100);                                            // Ожидание завершения текущего потока
            } catch (InterruptedException e) {}
        }
        System.out.println("\nAll tasks completed. Time passed: " + String.format("%.3f", (end_time - start_time) / (1000_000_000.0)) + " s.");
    }


    private final class TaskWorker implements Runnable {

        @Override
        public void run() {
            while (!currentThread().isInterrupted()) {
                try {
                    Runnable next_task;

                    next_task = tasks_queue.pull();                                // Извлекли задачу из очереди тредпула
                    if (next_task != null) {
                        System.out.println(currentThread().getName() + " received the task.");
                        free_threads_count.getAndDecrement();                     // Задачу взяли - уменьшили счетчик свободных потоков
                        next_task.run();
                        free_threads_count.getAndIncrement();                     // Задачу выполнили - увеличили счетчик свободных потоков
                    } else if (is_closed.get() && free_threads_count.get() == thread_num) {
                        synchronized (close_notify) {
                            close_notify.notify();                                // Последний освободившийся поток подтверждает завершение
                        }
                    } else
                        synchronized (new_task_notify) {
                            new_task_notify.wait();                               // Если очередь пуста, поток ждёт команду о поступлении новой задачи
                        }
                } catch (InterruptedException e) {
                    e.getStackTrace();
                    currentThread().interrupt();
                }
            }
            System.out.println(currentThread().getName() + " is closed.");
        }

    }


}