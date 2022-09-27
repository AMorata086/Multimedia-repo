#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>


#define max(x,y) (x) > (y) ? (x) : (y)
#define min(x,y) (x) > (y) ? (y) : (x)

int usage(){
	printf("Error: Not enough parameters\n"
	"Use:\n"
	"BM file1 file2 BS SR H W measure\n");
	return -1;
}


int main (int argc, char **argv)
{
	
	char *if1, *if2;
	FILE *f1, *f2,*fid;
	int H,W,bs,sr;
	int medida;
	int i,j,x,y,xmin,ymin,xmax,ymax,p,q;
	double minC,C,aux,m1,m2,d1,d2,aux2;
	unsigned char * im1,*im2;
	int *v,*u,leidos;
	
	if (argc < 8) {
  	  	usage();
  	  	return -1;
  	}
  	  	
  	if1=argv[1];
  	if2=argv[2];
  	bs=atoi(argv[3]);
  	sr=atoi(argv[4]);
  	H=atoi(argv[5]);
  	W=atoi(argv[6]);
  	medida=atoi(argv[7]);
  	
  	//Abrimos los ficheros
  	f1=fopen(if1,"r");
  	f2=fopen(if2,"r");
  	im1=malloc(H*W*sizeof(unsigned char));
  	im2=malloc(H*W*sizeof(unsigned char));
  	u=calloc(H*W,sizeof(int));
  	v=calloc(H*W,sizeof(int));
  	leidos=fread(im1,sizeof(unsigned char),H*W,f1);
  	leidos=fread(im2,sizeof(unsigned char),H*W,f2);
  	
  	fclose(f1);
  	fclose(f2);
  	//Bucle de píxeles
  	for(i=bs;i<(W-bs);i++){
		for(j=bs;j<(H-bs);j++){
			//printf("%d %d\n",i,j);
			xmin=max(i-sr,bs);
			xmax=min(i+sr,W-bs);
			ymin=max(j-sr,bs);
			ymax=min(j+sr,H-bs);
			if(xmax<=xmin)
				printf("error\n");
			if(ymax<=ymin)
				printf("error\n");
			minC=1e10;
			//Bucle de puntos de prueba
			for(x=xmin;x<xmax;x++){
				for(y=ymin;y<ymax;y++){
					C=0;
					if(medida==3){
						m1=0;
						m2=0;
						d1=0;
						d2=0;
						for(p=-bs;p<=bs;p++){
							for(q=-bs;q<=bs;q++){
								aux=(double)im1[(j+q)*W+i+p];
								m1+=aux;
								d1+=aux*aux;
								aux=(double)im2[(y+q)*W+x+p];
								m2+=aux;
								d2+=aux*aux;
							}
						}
						m1=m1/((2*bs+1)*(2*bs+1));
						m2=m2/((2*bs+1)*(2*bs+1));
						d1=sqrt(d1/((2*bs+1)*(2*bs+1))-m1*m1);
						d2=sqrt(d2/((2*bs+1)*(2*bs+1))-m2*m2);
					}
					for(p=-bs;p<=bs;p++){
						for(q=-bs;q<=bs;q++){
							if(medida==1){
								aux=(double)(im1[(j+q)*W+i+p]-im2[(y+q)*W+x+p]);
								C+=aux*aux;
							}
							else if(medida==2){
								C+=abs(im1[(j+q)*W+i+p]-im2[(y+q)*W+x+p]);
							}
							//CC
							else if(medida==3){
								aux=((double)im1[(j+q)*W+i+p]-m1)/d1;
								aux2=((double)im2[(y+q)*W+x+p]-m2)/d2;
								C+=aux*aux2;
							}
						}
					}
					C=C/((2*bs+1)*(2*bs+1));
					if(medida==1){
						C=C+10*abs(abs(x-i)+abs(y-j));
					}
					else if(medida==2){
						C=C+0.5*(abs(x-i)+abs(y-j));
					}
					else{
						C=fabs(C);
						C=1-C;
						C=C+0.05*(abs(x-i)+abs(y-j));
						//printf("%lf\n",C);
					}

					if(C<minC){
						u[j*W+i]=(int)x-i;
						v[j*W+i]=(int)y-j;
						minC=C;
					}
				}
			}
		}
	}

	fid=fopen("u.bin","wb");	
  	fwrite ( u, sizeof(int), H*W, fid );
	fclose(fid);
	fid=fopen("v.bin","wb");	
  	fwrite(v, sizeof(int), H*W, fid );
	fclose(fid);
}
