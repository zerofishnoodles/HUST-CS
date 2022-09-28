/*
 *csim.c-使用C编写一个Cache模拟器，它可以处理来自Valgrind的跟踪和输出统计
 *息，如命中、未命中和逐出的次数。更换政策是LRU。
 * 设计和假设:
 *  1. 每个加载/存储最多可导致一个缓存未命中。（最大请求是8个字节。）
 *  2. 忽略指令负载（I），因为我们有兴趣评估trace.c内容中数据存储性能。
 *  3. 数据修改（M）被视为加载，然后存储到同一地址。因此，M操作可能导致两次缓存命中，或者一次未命中和一次命中，外加一次可能的逐出。
 * 使用函数printSummary() 打印输出，输出hits, misses and evictions 的数，这对结果评估很重要
*/
#include "cachelab.h"
//                    请在此处添加代码  
//****************************Begin*********************
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include <getopt.h>
#include <string.h>
#include <assert.h>

#define ADDRBITS 32

int hit_count, miss_count, eviction_count;
int s, E, b;
char file_path[1000];

typedef struct cacheline_t {
    int valid;
    int tag;
    int taotai_count;
    // no need to actually record the data
}cacheline;

cacheline ** cache;

void init_cache(int s, int E, int b) {
    int group_num = 1U<<s;
    int member_num = E;
    // alloc the space for the whole cache
    cache = (cacheline **)malloc(sizeof(cacheline*) * group_num);

    for(int i=0;i<group_num;i++) {
        // alloc the space for one group
        cache[i] = (cacheline *)malloc(sizeof(cacheline) * member_num);

        // init
        for(int j=0; j< member_num; j++) {
            cache[i][j].valid = 0;
            cache[i][j].tag = -1;
            cache[i][j].taotai_count = 0;
        }
    }
}

void find_cache(unsigned address, int size) {
    int tag = address >> (b+s);
    tag = tag & (~((~0)<<(ADDRBITS-b-s)));
    int group_index = address<<(ADDRBITS-s-b);
    group_index = group_index >> (ADDRBITS-s);

    // find the cache line
    for(int i=0;i<E;i++) {
        if(cache[group_index][i].valid == 1 && cache[group_index][i].tag == tag) {
            hit_count++;
            cache[group_index][i].taotai_count = 0;
            return;
        }
    }

    // if not find, check if have empty line
    miss_count++;
    for(int i=0;i<E;i++) {
        if(cache[group_index][i].valid == 0) {
            cache[group_index][i].valid = 1;
            cache[group_index][i].tag = tag;
            cache[group_index][i].taotai_count = 0;
            return;
        }
    }

    // if not find empty line, find the one to replace
    eviction_count++;
    int max_taotai = -1;
    int max_index = -1;
    for(int i=0;i<E;i++) {
        if(cache[group_index][i].taotai_count > max_taotai) {
            max_taotai = cache[group_index][i].taotai_count;
            max_index = i;
        }
    }

    // cache[group_index][max_index].valid = 1;
    cache[group_index][max_index].tag = tag;
    cache[group_index][max_index].taotai_count = 0;

    return;
}

void add_taotai() {
    int group_num = 1U<<s;
    for(int i=0;i<group_num;i++) {
        for(int j=0;j<E;j++) {
            if(cache[i][j].valid == 1) cache[i][j].taotai_count++;
        }
    }
}

void parse_file(char *file_path) {
    FILE * pFile; //文件对象  
    pFile = fopen (file_path,"r"); //打开读取的文件  
    char identifier;  
    unsigned address;  
    int size;  
    // 例如读取行 " M 20,1" or "L 19,3"  
    while(fscanf(pFile," %c %x,%d", &identifier, &address, &size)>0)  
    {  
        if(identifier == 'I') continue;
        switch(identifier) {
            case 'L':
                find_cache(address, size);
                break;
            case 'M':
                find_cache(address, size);
                find_cache(address, size);
                break;
            case 'S':
                find_cache(address, size);
                break;
            default:
                printf("unknown identifier\n");
                break;
        }
        add_taotai();
    }  
    fclose(pFile); //记得完成后close文件 
    int group_num = 1U<<s;
	for(int i = 0; i < group_num; i++)
		free(cache[i]);
	free(cache);
}





int main(int argc, char** argv)
{   
    hit_count = miss_count = eviction_count = 0;

    int opt;
    /* 循环参数 */  
    while(-1 != (opt = getopt(argc, argv, "hvs:E:b:t:"))){  
      /* 确定正在处理的参数 */  
        switch(opt) {  
            case 'h':  
                printf("no need to do this man.");
                break;  
            case 'v':  
                printf("no need to do this man.");
                break;
            case 's':  
                s = atoi(optarg);  
                break;  
            case 'E':  
                E = atoi(optarg);  
                break;
            case 'b':  
                b = atoi(optarg);  
                break;  
            case 't':  
                strcpy(file_path, optarg); 
                break;      
            default:  
                printf("wrong argument\n");  
                break;  
        }   
    }

    assert((s+b) < ADDRBITS); 
    init_cache(s, E, b);

    parse_file(file_path);

    printSummary(hit_count, miss_count, eviction_count); //输出hit、miss和evictions数量统计 
    return 0;
}
//****************************End**********************#