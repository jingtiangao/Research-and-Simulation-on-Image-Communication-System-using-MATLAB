close all;clear all;clc;
%fname=input('Please input the bmp image name:','s');%%��һ��bmp�Ҷ�ͼ��
 %%[I,map]=imread(fname,'bmp');
I=imread('lena512.bmp');%%��bmp�Ҷ�ͼ��
I1=imread('Peppers512.bmp');
I2=imread('Barbara512.bmp');
I3=imread('Mandrill512.bmp');

%figure,imshow(I,[]);%%title('ԭʼͼ��');
Q=[9,4,2.5,2,1,0.5,0.4,0.3];%%�趨��������
bpp=[];snr=[];bpp1=[];snr1=[];bpp2=[];snr2=[];bpp3=[];snr3=[];


for i=1:8    %�õ���ͬQֵ��Ӧ��lena�����������PSNR��
[P,bpp(i),snr(i)]=func_DCTJPEG(I,Q(i));
end
for i=1:8    %�õ���ͬQֵ��Ӧ��Peppers�����������PSNR
[P,bpp1(i),snr1(i)]=func_DCTJPEG(I1,Q(i));
end
for i=1:8    %�õ���ͬQֵ��Ӧ��Barbara�����������PSNR��
[P,bpp2(i),snr2(i)]=func_DCTJPEG(I2,Q(i));
end
for i=1:8    %�õ���ͬQֵ��Ӧ��Mandrill�����������PSNR
[P,bpp3(i),snr3(i)]=func_DCTJPEG(I3,Q(i));
end
plot(bpp,snr,bpp1,snr1,':',bpp2,snr2,'*',bpp3,snr3,'-.')
xlabel('���������/bpp');
ylabel('PSNR/db');
legend('lena','Peppers','Barbara','Mandrill');
grid on;