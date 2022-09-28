#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>

int a[1005];
/***** Begin *****/
//合并两个区间
void merge(int low, int mid, int high, int* data, int* temp) {
    int top = low, p = low, q = mid;
    while (p < mid || q < high) {
        if (q >= high || (p < mid && data[p] <= data[q])) {
            temp[top++] = data[p++];
        }
        else {
            temp[top++] = data[q++];
        }
    }
    for (top = low; top < high; top++) {
        data[top] = temp[top];
    }
}
void merge_sort(int* data, int low, int high) {
    int i, j, t, *temp;
	int N = high - low;
    temp = (int*)malloc(N * sizeof(int));
    //这里做了一些优化，预处理合并了单个的区间，略微提高的速度
    #pragma omp parallel for private(i, t) shared(N, data)
    for (i = 0; i < N/2; i++)
        if (data[i*2] > data[i*2+1]) {
            t = data[i*2];
            data[i*2] = data[i*2+1];
            data[i*2+1] = t;
    }

    //i代表每次归并的区间长度，j代表需要归并的两个区间中最小的下标
    for (i = 2; i < high; i *= 2) {
        #pragma omp parallel for private(j) shared(high, i)
        for (j = 0; j < high-i; j += i*2) {
            merge(j, j+i, (j+i*2 <= high ? j+i*2 : high), data, temp);
        }
    }
}
int main()
{
	int n;
	scanf("%d", &n);
	for(int i=0;i<n;i++) {
		scanf("%d", &a[i]);
	}
	merge_sort(a, 0, n);
	
	for(int i=0;i<n;i++){
		printf("%d ", a[i]);
	}
	return 0;
}
/***** End *****/
