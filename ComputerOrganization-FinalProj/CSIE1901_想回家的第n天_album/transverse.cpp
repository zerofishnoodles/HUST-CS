#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>
#include<iostream>
#include <fstream>
using namespace std;


//unsigned char 转 十六进制字符串
void byte_to_hexstr( const unsigned char* source, char* dest, int sourceLen )
{
	short i;
	unsigned char highByte, lowByte;
 
	for (i = 0; i < sourceLen; i++)
	{
		highByte = source[i] >> 4;
		lowByte = source[i] & 0x0f ;
 
		highByte += 0x30;
 
		if (highByte > 0x39)
			dest[(sourceLen-i-1) * 2] = highByte + 0x07;
		else
			dest[(sourceLen-i-1) * 2] = highByte;
 
		lowByte += 0x30;
		if (lowByte > 0x39)
			dest[(sourceLen-i-1) * 2 + 1] = lowByte + 0x07;
		else
			dest[(sourceLen-i-1) * 2 + 1] = lowByte;
	}
	dest[sourceLen * 2] ='\0';
	return ;
}

BYTE *Read24BitBmpFile2Img(const char * filename,int *width,int *height)
{   
	FILE * BinFile;
    BITMAPFILEHEADER FileHeader;
    BITMAPINFOHEADER BmpHeader;
	BYTE *img;
	unsigned int size;
	int Suc=1,w,h;
 
	// Open File
	*width=*height=0;
	if((BinFile=fopen(filename,"rb"))==NULL) return NULL;
	// Read Struct Info
	if (fread((void *)&FileHeader,1,sizeof(FileHeader),BinFile)!=sizeof(FileHeader)) Suc=-1;
	if (fread((void *)&BmpHeader,1,sizeof(BmpHeader),BinFile)!=sizeof(BmpHeader)) Suc=-1;
	if ( (Suc==-1) || (FileHeader.bfOffBits<sizeof(FileHeader)+sizeof(BmpHeader) )) 
	{ 
			   fclose(BinFile); 
			   return NULL; 
	}
	cout << 1<< endl;
	// Read Image Data
	*width=w=BmpHeader.biWidth;
	cout << *width;
	*height=h=BmpHeader.biHeight;
	cout << *height;
	size=(*width)*(*height)*3;
	fseek(BinFile,FileHeader.bfOffBits,SEEK_SET);
	if ( (img=new BYTE[size])!=NULL)
	{   
		for(int i=0;i<h;i++)
		{
			if(fread(img+(h-1-i)*w*3,sizeof(BYTE),w*3,BinFile)!=w*3)
			{ 
				fclose(BinFile);
				delete img;
				img=NULL;
				return NULL;
			}
			fseek(BinFile,(3*w+3)/4*4-3*w,SEEK_CUR);
		}
    }
    fclose(BinFile);
    return img;
}
 
void BGR8882BGR555(unsigned char *img888, unsigned char * img555,int width,int height)
{
	unsigned char *p = img888;
	unsigned char *q = img555;
	
	unsigned char r,g,b;
	unsigned char r1,g1,b1;
	ofstream file;
	file.open("D:\\WangYue University\\codefield\\CODE_C\\C_Single\\trans\\555.txt");
	// FILE *fname = fopen("D:\\WangYue University\\codefield\\CODE_C\\C_Single\\trans\\111.txt","w");
	int i ,j;
	for(i = 0;i< height;i++)
	{
		for(j = 0; j< width;j++)
		{
			char dest[5];
			unsigned char u[2];
			b = *p;
			g = *(p+1);
			r = *(p+2);
			g1 = g>>6;
			r = (r>>3)<<2;
			*(q+1) = r | g1;
			*(u+1) = r | g1;
			g1 = ((g<<2)>>5)<<5;
			b1 = (b>>3);
			*(q) = g1 | b1;
			*(u) = g1 | b1;
			byte_to_hexstr(u,dest,2);
			file << dest << endl;
			p+=3;
			q+=2;
		}
	}
	// byte_to_hexstr(q,dest,4096);
	// fwrite(dest,sizeof(char),strlen(dest),fname);
	// fclose(fname);
	file.close();
}
bool Write555BitImg2BmpFile(BYTE *pImg,int width,int height,const char * filename)
// 当宽度不是4的倍数时自动添加成4的倍数
{   
	FILE *BinFile;
    BITMAPFILEHEADER FileHeader;
    BITMAPINFOHEADER BmpHeader;
    bool Suc=true;
    int i,extend;
	BYTE p[4],*pCur;
 
    // Open File
    if((BinFile=fopen(filename,"w+b"))==NULL) {  return false; }
	// Fill the FileHeader  
	FileHeader.bfType= ((WORD) ('M' << 8) | 'B');
	FileHeader.bfOffBits=sizeof(BITMAPFILEHEADER)+sizeof(BITMAPINFOHEADER);
	FileHeader.bfSize=FileHeader.bfOffBits+width*height*3L ;
	FileHeader.bfReserved1=0;
	FileHeader.bfReserved2=0;
	if(fwrite((void*)&FileHeader,1,sizeof(BITMAPFILEHEADER),BinFile)!=sizeof(BITMAPFILEHEADER)) 
	Suc=false;
	// Fill the ImgHeader
	BmpHeader.biSize = 40;
    BmpHeader.biWidth = width;
	BmpHeader.biHeight = height;
	BmpHeader.biPlanes = 1 ;
	BmpHeader.biBitCount = 16 ;
	BmpHeader.biCompression = 0 ;
	BmpHeader.biSizeImage = 0 ;
	BmpHeader.biXPelsPerMeter = 0;
	BmpHeader.biYPelsPerMeter = 0;
	BmpHeader.biClrUsed = 0;
	BmpHeader.biClrImportant = 0;
	if(fwrite((void*)&BmpHeader,1,sizeof(BITMAPINFOHEADER),BinFile)!=sizeof(BITMAPINFOHEADER))
	Suc=false;
 
 
	// write image data
	extend=(2*width+2)/4*4-2*width;
	if (extend==0)
	{   
		  for(pCur=pImg+(height-1)*2*width;pCur>=pImg;pCur-=2*width)
		  {   
		    if (fwrite((void *)pCur,1,width*2,BinFile)!=(unsigned int)(2*width)) Suc=false; // 真实的数据
		  }
	}
	else
	{   
	   for(pCur=pImg+(height-1)*2*width;pCur>=pImg;pCur-=2*width)
	   {   
		 if (fwrite((void *)pCur,1,width*2,BinFile)!=(unsigned int)(2*width)) Suc=false; // 真实的数据
		 if (fwrite((void *)(pCur+2*(width-1)+0),1,extend,BinFile)!=1) Suc=false; // 扩充的数据
	   }
	}
	// return;
	fclose(BinFile);
	return Suc;
}
 
int main()
{
	int width,height;
 
	BYTE *pGryImg=Read24BitBmpFile2Img("5.bmp",&width,&height);
	printf("%d,%d",width,height);
	unsigned char *pImg555 = new unsigned char[width*height*2];
 
	BGR8882BGR555(pGryImg, pImg555,width,height);
	Write555BitImg2BmpFile(pImg555,width,height,"result5.bmp");
 
	delete pGryImg;
	delete pImg555;
	return 0; 
}