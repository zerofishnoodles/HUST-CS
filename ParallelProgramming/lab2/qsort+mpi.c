#include"mpi.h"
#include <stdlib.h>
#include <stdio.h>

int n;
int a[100];
int partition(int* data, int low, int high)   //划分数据
{
    int temp = data[low];   //以第一个元素为基准
    while (low < high) {
        while (low < high && data[high] >= temp)high--;   //找到第一个比基准小的数
        data[low] = data[high];
        while (low < high && data[low] <= temp)low++;    //找到第一个比基准大的数
        data[high] = data[low];
    }
    data[low] = temp;   //以基准作为分界线
    return low;
}

void quicks(int* data, int low, int high)  //串行快排
{
    if (low < high) {    //未划分完
        int r = partition(data, low, high);   //继续划分，进行递归排序
        quicks(data, low, r - 1);
        quicks(data, r + 1, high);
    }
}

//求2的n次方
int exp_2(int n)
{
    int re=1;
    for(int i=1;i<=n;i++){
        re*=2;
    }
    return re;
}

//求以2为底n的对数，向下取整
int log_2(int n)
{
    int i = 1, j = 2;
    while (j < n) {
        j *= 2;
        i++;
        if(j>=n){
            return i;
        }
    }
    return i;
}

void parellelQS(int* data, int low, int high, int m, int id, int nowID, int N)
{
    int i, j, r = high, max_l = -1;  //r表示划分后数据前部分的末元素下标，max_l表示后部分数据的长度
    int* t;
    MPI_Status status;
    if (m == 0) {   //无进程可以调用
        if (nowID == id) quicks(data, low, high);
        return;
    }
    if (nowID == id) {    //当前进程是负责分发的
        while (id + exp_2(m - 1) > N && m > 0) m--;   //寻找未分配数据的可用进程
        if (id + exp_2(m - 1) < N) {  //还有未接收数据的进程，则划分数据
            r = partition(data, low, high);
            max_l = high - r;
            MPI_Send(&max_l, 1, MPI_INT, id + exp_2(m - 1), nowID, MPI_COMM_WORLD);
            if (max_l > 0)   //id进程将后部分数据发送给id+2^(m-1)进程
                MPI_Send(data + r + 1, max_l, MPI_INT, id + exp_2(m - 1), nowID, MPI_COMM_WORLD);
        }
    }
    if (nowID == id + exp_2(m - 1)) {    //当前进程是负责接收的
        MPI_Recv(&max_l, 1, MPI_INT, id, id, MPI_COMM_WORLD, &status);
        if (max_l > 0) {   //id+2^(m-1)进程从id进程接收后部分数据
            t = (int*)malloc(max_l * sizeof(int));
            if (t == 0) printf("Malloc memory error!");
            MPI_Recv(t, max_l, MPI_INT, id, id, MPI_COMM_WORLD, &status);
        }
    }
    j = r - 1 - low;
    MPI_Bcast(&j, 1, MPI_INT, id, MPI_COMM_WORLD);
    if (j > 0)     //负责分发的进程的数据不为空
        parellelQS(data, low, r - 1, m - 1, id, nowID, N);   //递归调用快排函数，对前部分数据进行排序
    j = max_l;
    MPI_Bcast(&j, 1, MPI_INT, id, MPI_COMM_WORLD);
    if (j > 0)     //负责接收的进程的数据不为空
        parellelQS(t, 0, max_l - 1, m - 1, id + exp_2(m - 1), nowID, N);   //递归调用快排函数，对前部分数据进行排序
    if ((nowID == id + exp_2(m - 1)) && (max_l > 0))     //id+2^(m-1)进程发送结果给id进程
        MPI_Send(t, max_l, MPI_INT, id, id + exp_2(m - 1), MPI_COMM_WORLD);
    if ((nowID == id) && id + exp_2(m - 1) < N && (max_l > 0))     //id进程接收id+2^(m-1)进程发送的结果
        MPI_Recv(data + r + 1, max_l, MPI_INT, id + exp_2(m - 1), id + exp_2(m - 1), MPI_COMM_WORLD, &status);
}

int main(int argc, char* argv[])
{

    int myid, nprocs;
    int m;
    MPI_Status status;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &myid);  //当前进程的进程号
    MPI_Comm_size(MPI_COMM_WORLD, &nprocs);  //总进程数
    
    m = log_2(nprocs);  //第一次分发需要给第2^(m-1)个进程
    if(myid == 0) {
        scanf("%d",&n);
    for(int i = 0 ; i < n ; i ++) 
        scanf("%d",&a[i]);
    }
    MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);  //广播n
    MPI_Bcast(a, n, MPI_INT, 0, MPI_COMM_WORLD);  //广播数组a

    parellelQS(a, 0, n - 1, m, 0, myid, nprocs);  //执行快排

    if (myid == 0)    //根进程输出并行时间
        for (int i = 0; i < n; i++) {  
            printf("%d", a[i]);
            if( i != n - 1)
                printf(" ");   
        }
    MPI_Finalize();
}