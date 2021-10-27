#include "stdafx.h"
#include <stdio.h>
#include <omp.h>
#include <iostream>
#include <cmath>

static int num_thr = 1;
static long long num_iter = 1;

// процедура ручного ввода числа потоков и итераций
void init_nums()
{
	int temp_iter;

	printf("Enter the num threads: ");
	while(true)
	{
		if ( !scanf_s("%d", &num_thr) ) {
			scanf_s("%*s");
			printf("You must entered value correctly!\n");
		} else
			break;
	}

	printf("Enter the number 10 to the power of iterations,\nthe number must be less than 19: ");
	while(true)
	{
		if ( !scanf_s("%d", &temp_iter) )
		{
			scanf_s("%*s");
			printf("You must entered value correctly!\n");
		} else if ( temp_iter >= 19 )
		{
			printf("You must entered value < 19!\n");
		} else
		{
			num_iter = (long long)pow(10.0, temp_iter);
			break;
		}
	}

	omp_set_num_threads(num_thr);									// установка числа потоков
	printf("Number of threads is set: %d\n\n", num_thr);
	printf("\nNumber of iterations is set: %lld\n", num_iter);
}

double calc_pi()
{
	long long i;
	double h, sum, x;

	h = 1.0 / num_iter;
	sum = 0.0;

# pragma omp parallel												// установка распараллеливаемого структурного блока
	{
# pragma omp for													// установка распараллеливаемого цикла for для распределения итераций между потоками
		for (i = 1; i <= num_iter; i++)
		{
			x = (4.0 / (1.0 + (h * (i - 0.5)) * (h * (i - 0.5))));
//			printf("Thread №%d is calc x:%f in %d iter\n", omp_get_thread_num() + 1, x, i);
# pragma omp critical												// критическая секция во избежание зависимости по данным
			sum += x;
		}
		printf("Thread №%d is end.\n", omp_get_thread_num() + 1);
	}
	return h * sum;													// результат вычисления числа PI
}

int _tmain(int argc, _TCHAR* argv[])
{
	double time;
	double pi;

	while (true)
	{
		init_nums();

		time = omp_get_wtime();										// начальный интервал времени для измерения длительности работы
		pi = calc_pi();
		time = omp_get_wtime() - time;								// затраченное время

		printf("\nPI is approximately equal: %.16f\n", pi);
		printf("Time of execution: %.6f sec\n", time);
		printf("------------------------------------------------------\n\n");
	}
}