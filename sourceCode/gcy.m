close all;clear all;clc;
%fname=input('Please input the bmp image name:','s');%%读一幅bmp灰度图像
 %%[I,map]=imread(fname,'bmp');
I=imread('lena512.bmp');%%读bmp灰度图像
I1=imread('Peppers512.bmp');
I2=imread('Barbara512.bmp');
I3=imread('Mandrill512.bmp');

%figure,imshow(I,[]);%%title('原始图像');
Q=[9,4,2.5,2,1,0.5,0.4,0.3];%%设定量化因子
bpp=[];snr=[];bpp1=[];snr1=[];bpp2=[];snr2=[];bpp3=[];snr3=[];


for i=1:8    %得到不同Q值对应的lena编码比特率与PSNR，
[P,bpp(i),snr(i)]=func_DCTJPEG(I,Q(i));
end
for i=1:8    %得到不同Q值对应的Peppers编码比特率与PSNR
[P,bpp1(i),snr1(i)]=func_DCTJPEG(I1,Q(i));
end
for i=1:8    %得到不同Q值对应的Barbara编码比特率与PSNR，
[P,bpp2(i),snr2(i)]=func_DCTJPEG(I2,Q(i));
end
for i=1:8    %得到不同Q值对应的Mandrill编码比特率与PSNR
[P,bpp3(i),snr3(i)]=func_DCTJPEG(I3,Q(i));
end
plot(bpp,snr,bpp1,snr1,':',bpp2,snr2,'*',bpp3,snr3,'-.')
xlabel('编码比特率/bpp');
ylabel('PSNR/db');
legend('lena','Peppers','Barbara','Mandrill');
grid on;