#include <stdio.h>

/***** Begin *****/
void merge(int *a, int low, int mid, int high){
	int temp[1005];
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

void merge_sort(int *a, int low, int high) {
	if(high <= low){
		return;
	}
	int mid = (high+low)>>1;
	merge_sort(a, low, mid);
	merge_sort(a, mid+1, high);
	merge(a, low, mid, high);
	return;
}
int main()
{
	int a[1005];
	int n;
	scanf("%d", &n);
	for(int i=0;i<n;i++) {
		scanf("%d", &a[i]);
	}
	merge_sort(a, 0, n-1);
	
	for(int i=0;i<n;i++){
		printf("%d ", a[i]);
	}
	return 0;
}
/***** End *****/