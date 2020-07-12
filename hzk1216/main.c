#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int PrintChineseCharByAreaCodeBitCode(unsigned char uc_AreaCode, unsigned char uc_BitCode)
{
    //char chs[32];
    int offset;

    //根据内码找出汉字在HZK16中的偏移位置
    offset=((uc_AreaCode - 1) * 94 + (uc_BitCode - 1)) * 32;


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

    /*if ((fp = fopen("HZK16", "r")) == NULL)
    #    return 1;

    #fseek(fp, offset, SEEK_SET);
    #fread(chs, 32, 1, fp);
	*/

    for (int i = 0; i < 32; i++)
    {
        if (  i > 1 && i % 2 == 0)
            printf("\n");   //每行两字节,16X16点阵
        for (int j = 7; j >= 0; j--)
        {
            if (chs[i + offset] & (0x01 << j))

                //由高到低,为1则输出'字',反之输出' ';
                printf("*");
            else
                printf(" ");
        }
    }

    putchar('\n');
    //fclose(fp);
}

int GetAreaBitCodeByChineseChar(const char* s)
{
    printf("length of s: %ld\n", strlen(s));
    char b[6800][20];
	memset(b, 0, 6800 * 20);
    FILE *fp;
    if ((fp = fopen("areacode.txt", "r")) == NULL)
	{
		printf("open file error!\n");
        exit(0);
	}
    
    int line_count = 0;
    do
	{
		fgets(b[line_count], sizeof(b[line_count]), fp);
        line_count++;
	}while(!feof(fp));
    
    int ChineseCharCount = strlen(s) / 3;

    for (int k = 0; k < ChineseCharCount; k++)
        for (int i = 0; i < 6800; i++)
            if (b[ i ][ 0 ] == s[k * 3 + 0]
			&& b[ i ][ 1 ] == s[k * 3 + 1]
			&& b[ i ][ 2 ] == s[k * 3 + 2])
			{
                unsigned char uc_AreaCode = (b[i][4] - '0' ) * 10 + b[i][5] - '0';
                unsigned char uc_BitCode = (b[i][6] - '0' ) * 10 + b[i][7] - '0';
                //printf("area code: %d, bit code: %d", uc_AreaCode, uc_BitCode);
                PrintChineseCharByAreaCodeBitCode(uc_AreaCode, uc_BitCode);
				break;
			}

	if (fclose(fp) == EOF)
	{
		printf("close file error\n");
		exit(0);
	}
				
}


int main(void)
{
    char s[] = "啊任启红";
    GetAreaBitCodeByChineseChar(s);
    return 0;
}
