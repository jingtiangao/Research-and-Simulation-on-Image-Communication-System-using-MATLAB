I=imread('lena512.bmp');%%读bmp灰度图像
I1=imread('Peppers512.bmp');
I2=imread('Barbara512.bmp');
I3=imread('Mandrill512.bmp');
Q=[9,4,2.5,2,1,0.5,0.4,0.3];%%设定量化因子
IDS1=downsample(I1,2);%对每列进行下2采样256*512
IDS1=downsample(IDS1',2);%对IDS转置的每一列进行下2采样，也就是对转置前的每一行进行下2采样，下一步再转置回来
IDS1=IDS1';%转置回来得到下2采样的值 256*256

IDS2=downsample(I2,2);%对每列进行下2采样256*512
IDS2=downsample(IDS2',2);%对IDS转置的每一列进行下2采样，也就是对转置前的每一行进行下2采样，下一步再转置回来
IDS2=IDS2';%转置回来得到下2采样的值 256*256

IDS3=downsample(I3,2);%对每列进行下2采样256*512
IDS3=downsample(IDS3',2);%对IDS转置的每一列进行下2采样，也就是对转置前的每一行进行下2采样，下一步再转置回来
IDS3=IDS3';%转置回来得到下2采样的值 256*256

IDS=downsample(I,2);%对每列进行下2采样256*512
IDS=downsample(IDS',2);%对IDS转置的每一列进行下2采样，也就是对转置前的每一行进行下2采样，下一步再转置回来
IDS=IDS';%转置回来得到下2采样的值 256*256
A=dyadup(IDS,0);
A=[A A(:,2)];
A=dyadup(A',0);
A=[A A(:,2)];
A=A';%%此段程序为降采样后的IDS补零使其从256*256变成512*512
%%对此图像进行256*256 JPEG编码
[PIC,bpp,psnr]=func_DCTJPEG(IDS,1);
%内插
near=imresize(PIC,[512 512],'nearest');%使用IMRESIZE对图像进行缩放处理，最近邻插值
bili=imresize(PIC,[512 512],'bilinear');%双线性插值
cubic=imresize(PIC,[512 512],'bicubic');%立方卷积
subplot(2,2,1);
imshow(I,[]);title('原始图像');
subplot(2,2,2);
imshow(near,[]);title('最近邻插值');
subplot(2,2,3);
imshow(bili,[]);title('双线性插值');
subplot(2,2,4);
imshow(cubic,[]);title('立方卷积');
%画出同一幅图在不同压缩比下，不同插值方法比较%
cbpp=[];csnr=[];cbpp1=[];csnr1=[];cbpp2=[];csnr2=[];

for i=1:8    %得到不同Q值对应的lena编码比特率与PSNR
[R,cbpp(i),b]=func_DCTJPEG(IDS,Q(i));
near=imresize(R,[512 512],'nearest');%使用IMRESIZE对图像进行缩放处理，最近邻插值
bili=imresize(R,[512 512],'bilinear');%双线性插值
cubic=imresize(R,[512 512],'bicubic');%立方卷积
csnr1(i)=PSNR(near,I);
csnr2(i)=PSNR(bili,I);
csnr3(i)=PSNR(cubic,I);
end

plot(bpp,snr,cbpp,csnr1,':',cbpp,csnr2,'*',cbpp,csnr3,'-.')
xlabel('编码比特率/bpp');
ylabel('PSNR/db');
legend('原始图像Lena','最近邻插值','双线性插值','立方卷积');
grid on;
%不同图，在同一压缩比下，不同插值方法比较%
x=1:4;
%对4幅图搞4次得到3个向量%
[R,a,b]=func_DCTJPEG(IDS1,1);
near=imresize(R,[512 512],'nearest');%使用IMRESIZE对图像进行缩放处理，最近邻插值
bili=imresize(R,[512 512],'bilinear');%双线性插值
cubic=imresize(R,[512 512],'bicubic');%立方卷积
csnr11(1)=PSNR(near,I1);
csnr22(1)=PSNR(bili,I1);
csnr33(1)=PSNR(cubic,I1);

[R,a,b]=func_DCTJPEG(IDS2,1);
near=imresize(R,[512 512],'nearest');%使用IMRESIZE对图像进行缩放处理，最近邻插值
bili=imresize(R,[512 512],'bilinear');%双线性插值
cubic=imresize(R,[512 512],'bicubic');%立方卷积
csnr11(2)=PSNR(near,I2);
csnr22(2)=PSNR(bili,I2);
csnr33(2)=PSNR(cubic,I2);


[R,a,b]=func_DCTJPEG(IDS3,1);
near=imresize(R,[512 512],'nearest');%使用IMRESIZE对图像进行缩放处理，最近邻插值
bili=imresize(R,[512 512],'bilinear');%双线性插值
cubic=imresize(R,[512 512],'bicubic');%立方卷积
csnr11(3)=PSNR(near,I3);
csnr22(3)=PSNR(bili,I3);
csnr33(3)=PSNR(cubic,I3);

csnr11(4)=27.665;
csnr22(4)=29.352;
csnr33(4)=29.099;
figure(2);
plot(x,csnr11,':',x,csnr22,'*',x,csnr33,'-.')
xlabel('图像名称');
ylabel('PSNR/db');
set(gca,'XTick',1:4);  set(gca,'XTickLabel',{'Peppers','Barbara','Mandrill','Lena'});  
legend('最近邻插值','双线性插值','立方卷积');
grid on;





