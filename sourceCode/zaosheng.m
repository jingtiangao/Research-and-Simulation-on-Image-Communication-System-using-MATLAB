%加噪去噪
I=imread('lena512.bmp');%%读bmp灰度图像
figure,imshow(I,[]);%%title('原始图像');
J=imnoise(I,'gaussian',0, 0.005);%加入均值为0，方差为0.005的高斯噪声 
Q=[9,4,2.5,2,1,0.5,0.4,0.3];%%设定量化因子
%%%%%%%%%
%%椒盐噪声
%%%%%%%%%

%J=imnoise(I,'salt & pepper',0.02); 

%h=ones(3,3)/9;%产生3*3的全1数组 

%B=conv2(J,h);%卷积运算 

K9=filter2(fspecial('average',3),J); %均值滤波模板尺寸为3 
K9=uint8(K9);
K10= medfilt2(J);%采用二维中值滤波函数medfilt2对受椒盐噪声干扰的图像滤波 

K11=wiener2(J,[3 3]); %对加噪图像进行二维自适应维纳滤波     
figure(2);
%subplot(2,3,1);
imshow(I); 

title('原始图像'); 

subplot(2,3,2);imshow(J); 

title('加噪图像'); 

subplot(2,3,3);imshow(K9); 

title('均值滤波后的图像'); 

subplot(2,3,4);imshow(K10); 

title('中值滤波后的图像'); 

subplot(2,3,5);imshow(K11); 

title('维纳滤波后的图像'); 

noibpp=[];noisnr=[];noibpp1=[];noisnr1=[];noibpp2=[];noisnr2=[];
%对均值滤波后图像进行JPEG压缩，并且得到BPP 与PSNR
for i=1:8    %得到不同Q值对应的lena编码比特率与PSNR，
[P,noibpp(i),noisnr(i)]=func_DCTJPEG(K9,Q(i));
end
%对中值滤波后图像进行JPEG压缩，并且得到BPP 与PSNR
for i=1:8    %得到不同Q值对应的编码比特率与PSNR
[P,noibpp1(i),noisnr1(i)]=func_DCTJPEG(K10,Q(i));
end
%对维纳滤波后图像进行JPEG压缩，并且得到BPP 与PSNR
for i=1:8    %得到不同Q值对应的编码比特率与PSNR，
[P,noibpp2(i),noisnr2(i)]=func_DCTJPEG(K11,Q(i));
end
figure(3);
plot(bpp,snr,noibpp,noisnr,':',noibpp1,noisnr1,'*',noibpp2,noisnr2,'-.')
xlabel('编码比特率/bpp');
ylabel('PSNR/db');
legend('lena原始图','加噪均值滤波后图','加噪中值滤波后图','加噪维纳滤波后图');
grid on;





