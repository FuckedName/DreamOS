
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// generate *.c for hzk16 and gcc -c *.c to compile obj file
int main()
{
    FILE *fp = NULL;
    fp = fopen("HZK16","rb"); //打开文件
    if(fp == NULL)
    {   
        printf("--: %s---%d--HZK16 open error",__FILE__,__LINE__);
    }   
    fseek(fp,0L,SEEK_END);  //定位到文件末尾
    int flen = ftell(fp); //得到文件大小
    char *chs = (char *)malloc(flen + 1); //分配空间存储文件中的数据
    if(chs == NULL)
    {   
        fclose(fp);
        return 0;
    }   
    memset(chs, 0, flen + 1); 
    fseek(fp,0L,SEEK_SET); //定位到文件开头
    fread(chs,flen,1,fp);  //一次性读取全部文件内容
    chs[flen] = '\0';  // 字符串最后一位为空

	printf("char HZK16[]={%d", (unsigned char)chs[0]);

    //for (int i = 1; i < 300; i++)
    for (int i = 0; i < flen; i++)
		printf(",%d", (unsigned char)chs[i]);
	printf("};");
}

