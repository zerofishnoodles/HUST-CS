#include <stdio.h>
#include <pthread.h>
#include <math.h>
#include <stdlib.h>

/***** Begin *****/
int a[1005];
typedef struct Params{
	int *a;
	int low,high;
}Params;

void merge(int *a, int low, int mid, int high){
	int *temp;
	temp = (int *)malloc(sizeof(int) * (high-low+1));
	int i=low,j=mid+1,k;
	for(k = 0; k < (high-low+1); k++) {
		if(i >= mid+1) break;
		if(j >= high+1) break;
		if(a[i] < a[j]){
			temp[k] = a[i];
			i++;
		}else{
			temp[k] = a[j];
			j++;
		}
	}

	while(i<=mid) {
		temp[k] = a[i];
		k++;
		i++;
	}

	while(j <= high){
		temp[k] = a[j];
		k++;
		j++;
	}
	for(int k=0;k<(high-low+1);k++) {
		a[low+k] = temp[k];
	}
	return;
}

void merge_sort(void *arg) {
	Params *argst = (Params*)arg;
	int high = argst->high;
	int low = argst->low;
	if(high <= low){
		return;
	}
	int mid = (high+low)>>1;
	pthread_t th1, th2;
	Params pm1,pm2;
	pm1.a = argst->a;
	pm2.a = argst->a;
	pm1.low = low;
	pm1.high = mid;
	pm2.low = mid+1;
	pm2.high =high;
	pthread_create(&th1, NULL, merge_sort, &pm1);
	pthread_create(&th2, NULL, merge_sort, &pm2);
	pthread_join(th1, NULL);
	pthread_join(th2, NULL);
	merge(a, low, mid, high);
	return;
}
int main()
{
	int n;
	scanf("%d", &n);
	for(int i=0;i<n;i++) {
		scanf("%d", &a[i]);
	}
	Params pm;
	pm.a = a;
	pm.low = 0;
	pm.high = n-1;
	pthread_t tid;
    pthread_create(&tid, NULL, merge_sort, &pm);
	  
	pthread_join(tid, NULL);
	for(int i=0;i<n;i++){
		printf("%d ", a[i]);
	}
	return 0;
}
/***** End *****/
