#include <stdio.h>

/***** Begin *****/
int main()
{
	int n;
	scanf("%d", &n);
	printf("[[1]");
	int a[2][100];
	a[0][0] = 1;
	int flag = 0;
	for(int layer=2;layer<=n;layer++) {
		for(int i=0;i<layer;i++) {
			if(i==0) a[flag][i] = 1;
			else if(i==layer-1) a[flag][i] = 1;
			else{
				a[flag][i] = a[1-flag][i-1]+a[1-flag][i];
			}
		}
		printf(",[");
		for(int i=0;i<layer-1;i++){
			printf("%d,", a[flag][i]);
		}
		printf("%d]", a[flag][layer-1]);

		flag = 1 - flag;
	}
	printf("]");
	return 0;
}
/***** End *****/