#include <stdlib.h>
#include <stdio.h>
#include <mpi.h>
#include <math.h>
#include <string.h>
/***** Begin *****/

void  main(int argc, char* argv[])  
{  
    int numprocs, myid;  
    MPI_Status status;  
    int i,j;
    int a[100] = {0};
    int n;
    int k = 1;
    int m = 1 ;
    int tmp;
    MPI_Init(&argc, &argv);  
    MPI_Comm_rank(MPI_COMM_WORLD, &myid);  
    MPI_Comm_size(MPI_COMM_WORLD, &numprocs); 

    if(myid == 0) {   
        scanf("%d",&n);
        MPI_Bcast(&n,1,MPI_INT,0,MPI_COMM_WORLD);
        printf("[");
        for (int layer = 1; layer<=n; layer++) {  
            printf("[");
            tmp = layer % 3;
            if(tmp == 0) tmp = 3;
            MPI_Recv(a, 10, MPI_INT, tmp , 99,  
                MPI_COMM_WORLD, &status);  
            for(int j = 1 ; j <= layer ; j++) {
                printf("%d",a[j]);
                if( j != layer)
                    printf(",");  
            }
            printf("]");
            if(layer != n)
                printf(",");
        }  
        printf("]");
    }  
    
    if(myid) {
        MPI_Bcast(&n,1,MPI_INT,0,MPI_COMM_WORLD);
        for(i = myid ; i <= n ; i += numprocs - 1 ) {
            for(j = 1 ; j <= i ; j ++) {
                a[j] = k / m;
                k *= i - j;
                m *= j ;
            }
        m = 1;
        k = 1;
        MPI_Send(a, 10, MPI_INT, 0, 99,  
            MPI_COMM_WORLD);  
        }
    }
    MPI_Finalize(); 

} 
 


/***** End *****/
