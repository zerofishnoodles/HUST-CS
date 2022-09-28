/* 
 * trans.c - 矩阵转置B=A^T
 *每个转置函数都必须具有以下形式的原型：
 *void trans（int M，int N，int a[N][M]，int B[M][N]）；
 *通过计算，块大小为32字节的1KB直接映射缓存上的未命中数来计算转置函数。
 */ 
#include <stdio.h>
#include "cachelab.h"
int is_transpose(int M, int N, int A[N][M], int B[M][N]);
char transpose_submit_desc[] = "Transpose submission";  //请不要修改“Transpose_submission”


void transpose_submit(int M, int N, int A[N][M], int B[M][N])
{

//                          请在此处添加代码
//*************************************Begin********************************************************


if(N == 32) {
int i, j, k, s;
int temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7;
for (i = 0; i < N; i += 8) {
    for (j = 0; j < N; j += 8) {
        // copy
        for (k = i, s = j; k < i + 8; k++, s++) {
            temp0 = A[k][j];
            temp1 = A[k][j + 1];
            temp2 = A[k][j + 2];
            temp3 = A[k][j + 3];
            temp4 = A[k][j + 4];
            temp5 = A[k][j + 5];
            temp6 = A[k][j + 6];
            temp7 = A[k][j + 7];
            B[s][i] = temp0;
            B[s][i + 1] = temp1;
            B[s][i + 2] = temp2;
            B[s][i + 3] = temp3;
            B[s][i + 4] = temp4;
            B[s][i + 5] = temp5;
            B[s][i + 6] = temp6;
            B[s][i + 7] = temp7;
        }
        // transpose
        for (k = 0; k < 8; k++) {
            for (s = k + 1; s < 8; s++) {
                temp0 = B[k + j][s + i];
                B[k + j][s + i] = B[s + j][k + i];
                B[s + j][k + i] = temp0;
            }
        }
    }
}
}

if(N == 64) {
int i, j, k;
int temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7; 
int temp;
    for (i = 0; i < N; i += 8) {
    for (j = 0; j < M; j += 8) {
        for (k = 0; k < 4; k++) {
            temp0 = A[k + i][j];
            temp1 = A[k + i][j + 1];
            temp2 = A[k + i][j + 2];
            temp3 = A[k + i][j + 3];
            temp4 = A[k + i][j + 4];
            temp5 = A[k + i][j + 5];
            temp6 = A[k + i][j + 6];
            temp7 = A[k + i][j + 7];

            B[j][k + i] = temp0;
            B[j + 1][k + i] = temp1;
            B[j + 2][k + i] = temp2;
            B[j + 3][k + i] = temp3;
            B[j][k + 4 + i] = temp4;
            B[j + 1][k + 4 + i] = temp5;
            B[j + 2][k + 4 + i] = temp6;
            B[j + 3][k + 4 + i] = temp7;
        }
        for (k = 0; k < 4; k++) {
            temp0 = A[i + 4][j + k], temp4 = A[i + 4][j + k + 4];
            temp1 = A[i + 5][j + k], temp5 = A[i + 5][j + k + 4];
            temp2 = A[i + 6][j + k], temp6 = A[i + 6][j + k + 4];
            temp3 = A[i + 7][j + k], temp7 = A[i + 7][j + k + 4];

            temp = B[j + k][i + 4], B[j + k][i + 4] = temp0, temp0 = temp;
            temp = B[j + k][i + 5], B[j + k][i + 5] = temp1, temp1 = temp;
            temp = B[j + k][i + 6], B[j + k][i + 6] = temp2, temp2 = temp;
            temp = B[j + k][i + 7], B[j + k][i + 7] = temp3, temp3 = temp;

            B[j + k + 4][i + 0] = temp0, B[j + k + 4][i + 4 + 0] = temp4;
            B[j + k + 4][i + 1] = temp1, B[j + k + 4][i + 4 + 1] = temp5;
            B[j + k + 4][i + 2] = temp2, B[j + k + 4][i + 4 + 2] = temp6;
            B[j + k + 4][i + 3] = temp3, B[j + k + 4][i + 4 + 3] = temp7;
        }
    }
}
}

if(N == 67)
{
    int i, j;
    int temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7;
    int n = N / 8 * 8;
    int m = M / 8 * 8;
    for (j = 0; j < m; j += 8)
        for (i = 0; i < n; ++i)
        {
            temp0 = A[i][j];
            temp1 = A[i][j+1];
            temp2 = A[i][j+2];
            temp3 = A[i][j+3];
            temp4 = A[i][j+4];
            temp5 = A[i][j+5];
            temp6 = A[i][j+6];
            temp7 = A[i][j+7];
            
            B[j][i] = temp0;
            B[j+1][i] = temp1;
            B[j+2][i] = temp2;
            B[j+3][i] = temp3;
            B[j+4][i] = temp4;
            B[j+5][i] = temp5;
            B[j+6][i] = temp6;
            B[j+7][i] = temp7;
        }
    for (i = n; i < N; ++i)
        for (j = m; j < M; ++j)
        {
            temp0 = A[i][j];
            B[j][i] = temp0;
        }
    for (i = 0; i < N; ++i)
        for (j = m; j < M; ++j)
        {
            temp0 = A[i][j];
            B[j][i] = temp0;
        }
    for (i = n; i < N; ++i)
        for (j = 0; j < M; ++j)
        {
            temp0 = A[i][j];
            B[j][i] = temp0;
        }
}



//**************************************End**********************************************************
}

/* 
 * 我们在下面定义了一个简单的方法来帮助您开始，您可以根据下面的例子把上面值置补充完整。
 */ 

/* 
 * 简单的基线转置功能，未针对缓存进行优化。
 */
char trans_desc[] = "Simple row-wise scan transpose";
void trans(int M, int N, int A[N][M], int B[M][N])
{
    int i, j, tmp;

    for (i = 0; i < N; i++) {
        for (j = 0; j < M; j++) {
            tmp = A[i][j];
            B[j][i] = tmp;
        }
    }    

}

/*
 * registerFunctions-此函数向驱动程序注册转置函数。
 *在运行时，驱动程序将评估每个注册的函数并总结它们的性能。这是一种试验不同转置策略的简便方法。
 */
void registerFunctions()
{
    /* 注册解决方案函数  */
    registerTransFunction(transpose_submit, transpose_submit_desc); 

    /* 注册任何附加转置函数 */
    registerTransFunction(trans, trans_desc); 

}

/* 
 * is_transpose - 函数检查B是否是A的转置。在从转置函数返回之前，可以通过调用它来检查转置的正确性。
 */
int is_transpose(int M, int N, int A[N][M], int B[M][N])
{
    int i, j;

    for (i = 0; i < N; i++) {
        for (j = 0; j < M; ++j) {
            if (A[i][j] != B[j][i]) {
                return 0;
            }
        }
    }
    return 1;
}

