// Simple minded matrix multiply 
//

#include "stdafx.h"
#include <stdio.h>
#include <omp.h>
#include <iostream>

#define DIM 1300										// размерность массивов

static int init_thr = 1;									// начальное значение числа потоков
static int final_thr = 0;									// конечное значение числа потоков
static double a[DIM][DIM], b[DIM][DIM], c[DIM][DIM];

// ввод числа потоков
void init_num_threads() {
	printf("Enter the initial num threads: ");
	while( !scanf_s("%d", &init_thr) ) {
		scanf_s("%*s");
		printf("You must entered value correctly!\n");
	}
	printf("Enter the final num threads: ");
	while(true) {
		if ( !scanf_s("%d", &final_thr) ) {
				scanf_s("%*s");
				printf("You must entered value correctly!\n");
		}
		else if ( final_thr < init_thr ) {
			printf("The final num threads must be below initial num threads!\n");
		}
		else
			break;
	}
}

// процедура инициализации массива тестовыми данными
void init_arr(double row, double col, double off, double array[DIM][DIM])
{
	int i, j;

	for (i = 0; i < DIM; i++) {
		for (j = 0; j < DIM; j++) {
			array[i][j] = row * i + col * j + off;
		}
	}
}

// процедура вывода данных из массива
void print_arr(char * name, double array[DIM][DIM])
{
	int i,j;

	printf("\n%s\n", name);								// вывод названия массива
	for (i = 0; i < DIM; i++) {
		for (j = 0; j < DIM; j++) {
			printf("%g\t",array[i][j]);					// последовательный вывод данных
		}
		printf("\n");
	}
}

// вычислительная процедура
void multiply_d(double a[DIM][DIM], double  b[DIM][DIM], double  c[DIM][DIM])
{
	int i, j, k;
#pragma omp parallel for schedule (dynamic)				// распределение загруженности потоков во время запуска
//#pragma omp parallel for schedule (static, 1)			// распределение загруженности потоков порциями до запуска
	for (i = 0; i < DIM; i++) {
		for (j = 0; j < DIM; j++) {
//#pragma omp parallel for schedule (dynamic)
//#pragma omp parallel for schedule (static, 1)
			for (k = 0; k < DIM; k++) {
				c[i][j] = c[i][j] + a[i][k] * b[k][j];
			}
		}
	}
}


int main()
{
	init_num_threads();

	// инициализация массивов a и b начальными значениями
	printf("Array size: %d\n", DIM);
	init_arr(3, -2, 1, a);
	init_arr(-2, 1, 3, b);

	// цикл последовательной генерации задач с разным числом потоков
	while (init_thr <= final_thr)
	{
		double tim = omp_get_wtime();
		omp_set_num_threads(init_thr);

		// выполнение операции умножения чисел в режиме распараллеливания итераций равных размерности массивов (DIM)
		multiply_d(a, b, c);

		// вывод данных для проверки операции сложения, если размерность массивов меньше 5
		if (DIM < 5) {
			print_arr("a", a);
			print_arr("b", b);
			print_arr("c", c);
		}

		// вывод пройденного времени
		printf("Elapsed time = %lf seconds\n", tim = omp_get_wtime() - tim);
		init_thr++;
	}
	system("pause");
}