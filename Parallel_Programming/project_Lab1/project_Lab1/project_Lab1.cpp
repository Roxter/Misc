// Simple minded matrix multiply 
//

#include "stdafx.h"
#include <stdio.h>
#include <omp.h>
#include <iostream>

#define DIM 1300										// ����������� ��������

static int init_thr = 1;									// ��������� �������� ����� �������
static int final_thr = 0;									// �������� �������� ����� �������
static double a[DIM][DIM], b[DIM][DIM], c[DIM][DIM];

// ���� ����� �������
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

// ��������� ������������� ������� ��������� �������
void init_arr(double row, double col, double off, double array[DIM][DIM])
{
	int i, j;

	for (i = 0; i < DIM; i++) {
		for (j = 0; j < DIM; j++) {
			array[i][j] = row * i + col * j + off;
		}
	}
}

// ��������� ������ ������ �� �������
void print_arr(char * name, double array[DIM][DIM])
{
	int i,j;

	printf("\n%s\n", name);								// ����� �������� �������
	for (i = 0; i < DIM; i++) {
		for (j = 0; j < DIM; j++) {
			printf("%g\t",array[i][j]);					// ���������������� ����� ������
		}
		printf("\n");
	}
}

// �������������� ���������
void multiply_d(double a[DIM][DIM], double  b[DIM][DIM], double  c[DIM][DIM])
{
	int i, j, k;
#pragma omp parallel for schedule (dynamic)				// ������������� ������������� ������� �� ����� �������
//#pragma omp parallel for schedule (static, 1)			// ������������� ������������� ������� �������� �� �������
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

	// ������������� �������� a � b ���������� ����������
	printf("Array size: %d\n", DIM);
	init_arr(3, -2, 1, a);
	init_arr(-2, 1, 3, b);

	// ���� ���������������� ��������� ����� � ������ ������ �������
	while (init_thr <= final_thr)
	{
		double tim = omp_get_wtime();
		omp_set_num_threads(init_thr);

		// ���������� �������� ��������� ����� � ������ ����������������� �������� ������ ����������� �������� (DIM)
		multiply_d(a, b, c);

		// ����� ������ ��� �������� �������� ��������, ���� ����������� �������� ������ 5
		if (DIM < 5) {
			print_arr("a", a);
			print_arr("b", b);
			print_arr("c", c);
		}

		// ����� ����������� �������
		printf("Elapsed time = %lf seconds\n", tim = omp_get_wtime() - tim);
		init_thr++;
	}
	system("pause");
}