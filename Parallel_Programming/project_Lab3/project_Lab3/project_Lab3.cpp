//#include <cstdlib>
#include "stdafx.h"
#include <mpi.h>
//#include <stdio.h>
#include <iostream>
#include <fstream>
#include <omp.h>
#include <ctime>
#include <sstream>


//#include <emmintrin.h>

int main( int argc, char* argv[] )
{

	double x[10002], newx[10002], z[10002];
	double dx2;
	int n, noiters, i, k;
	int p, me, ln, lm, tag;


	n = 1000;
	noiters = 200000;

	MPI_Status status;

	dx2 = (1.f / n);
	dx2 *= dx2;

	// time start


	MPI_Init(&argc, &argv);

	MPI_Comm_rank(MPI_COMM_WORLD, &me);
	MPI_Comm_size(MPI_COMM_WORLD, &p);

	std::ofstream file_out("1.txt");

	for (noiters; noiters<=1000000; noiters=noiters+200000) {

	tag = 0;
	ln = n / p;

	for (i = 1; i < ln; ++i) {
		x[i] = 1.0;
	}

	if (me == 0) {
		x[0] = 0.0;
		lm = 0;
	}
	else {
		lm = ln * me;
	}

	if (me == p - 1) {
		x[ln+1] = 0.0;
	}

	for (k = 1; k < noiters; ++k) {
		// Пересылки граничных значений
		if (me - 1 >= 0) {
			MPI_Send(newx + 1, 1, MPI_REAL, me - 1, tag, MPI_COMM_WORLD);
		}
		if (me + 1 < p) {
			MPI_Recv(x + ln + 1, 1, MPI_REAL, me + 1, tag, MPI_COMM_WORLD, &status);
		}
		++tag;
		if (me + 1 < p) {
			MPI_Send(newx + ln, 1, MPI_REAL, me + 1, tag, MPI_COMM_WORLD);
		}
		if (me - 1 >= 0) {
			MPI_Recv(x, 1, MPI_REAL, me - 1, tag, MPI_COMM_WORLD, &status);
		}
		++tag;
		// Итерация якоби
		for (i = 1; i < ln; ++i) {
			newx[i] = 0.5 * (x[i - 1] + x[i + 1] - dx2 * x[i]);
		}
		for (i = 1; i < ln; ++i) {
			x[i] = newx[i];
		}
	}

	//Собираем решение
	if (me == 0) {
		for (i = 1; i < ln; ++i) {
			z[i] = x[i];
		}
		for (k = 1; k < p - 1; ++k) {
			lm = ln * k;
			MPI_Recv(z + lm, ln, MPI_REAL, k, k, MPI_COMM_WORLD, &status);
		}
	}
	else {
		MPI_Send(x + 1, ln, MPI_REAL, 0, me, MPI_COMM_WORLD);
	}

	// time end

	//Запись результата в файл
	if (me == 0) {
		
		file_out << noiters << " " << clock()/1000.0 << std::endl; 
		
	}
	}
	file_out.close();
	MPI_Finalize();

	//system( "pause" );
	return 0;
}