//  Simple minded matrix multiply
#include "stdafx.h"
#include <stdio.h>
#include <omp.h>
#include <iostream>

double sum_counter = 0;								// сумма всех значений при инициализации
const int num_thr = 4;								// значение числа потоков
const int num_iter = 1000000;						// число итераций
int i = 0;
const int dim = 1000; 								// размерность массивов
double a[dim], b[dim];
double local_sum = 0;								// сумма результатов вычислений от каждого потока

// процедура инициализации массива
void init_arr(double k, double arr1[dim], double arr2[dim])
{
	sum_counter = 0;
	for (i = 0; i < dim; i++)
	{
		arr1[i] = 1;
		arr2[i] = 1;
		sum_counter += arr1[i] * arr2[i];		// накопление суммы при инициализации
	}
}

void mult()
{
	int j = 0;

	local_sum = 0;
	for (j = 0; j < num_iter; j++)
	{
#pragma omp parallel default (none) private (i) shared (a, b, dim) reduction (+:local_sum)
	{
		int id = omp_get_thread_num();
		int thr_num = omp_get_num_threads();
		int chunk = dim / thr_num;									// переменная для равномерного распределения порций по потокам
		
		//for (i = id; i < dim; i += thr_num)							// False sharing
		for (i = id * chunk; i < (id + 1) * chunk; i++)			// True sharing
		{
			a[i] = a[i] * b[i];
			local_sum += a[i];										// суммирование результатов умножения
		}
	}
	}
}

int _tmain(int argc, _TCHAR* argv[])
{
	double time;

	for (int i = 0; i < 4; i++) {
		printf("Array size is set: %d\nNumber of iterations is set: %d\n", dim, num_iter);
		omp_set_num_threads(num_thr);

		init_arr(10, a, b);
		time = omp_get_wtime();				// засекаем время
		mult();
		time = omp_get_wtime() - time;		// фиксация затраченного времени на выполнение

		printf("sum_counter is %.16f\n", sum_counter);
		printf("local_sum is %.16f\n", local_sum);
		printf("time is %.6f\n\n", time);
	}

	system("pause");

	return 0;
}