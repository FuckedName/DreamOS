#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int GetAreaBitCodeByChineseChar(const char* s)
{
    printf("length of s: %ld\n", strlen(s));
    char b[6800][20];
	memset(b, 0, 6800 * 20);
    FILE *fp;
    if ((fp = fopen("areacode4.txt", "r")) == NULL)
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
    
   
    //for (int i = 0; i < 6800; i++)
	//	puts(b[i]);
 
    for (int k = 0; k < ChineseCharCount; k++)
        for (int i = 0; i < 6800; i++)
            if (b[ i ][ 0 ] == s[k * 3 + 0]
			&& b[ i ][ 1 ] == s[k * 3 + 1]
			&& b[ i ][ 2 ] == s[k * 3 + 2])
			{
				printf("%s", b[i]);
				break;
			}

	if (fclose(fp) == EOF)
	{
		printf("close file error\n");
		exit(0);
	}
				
}

int main()
{
	char s[] = "啊任启红";
	GetAreaBitCodeByChineseChar(s);
}
