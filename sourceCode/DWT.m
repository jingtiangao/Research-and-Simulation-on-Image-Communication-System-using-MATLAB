%% ************* 基于DWT变换的图像水印算法实现－水印嵌入 **************
%function watermarked_DWT(s)
clc
clear all;
close all;
Img=imread('Lena512.bmp'); %读入原始载体图像 
[row column]=size(Img);             
Img_source=reshape(Img',[],1);%将512*512重塑成262144*1一行行拉成一条
L=length(Img_source); %图像数据总数

%picture=imread('SOX.bmp');%picture=Arnold('SOX.bmp',2);%arnold置乱
picture_ori=imread('SOX.bmp'); %读入水印图像
picture=hundun(picture_ori);%混沌置乱
[row_W,column_W]=size(picture); %获取水印图片的行列值
picture_line=reshape(picture,[1,row_W*column_W]); %将picture拉成一条
[CA,CH,CV,CD]=dwt2(Img,'db1');%DWT后获得水平 垂直 对角细节分量
C=[CH CV CD];
[length,width]=size(CA);
[M,N]=size(C);
T1=0;
s=20;%影响印章，强转为低频
%加入水印
WaterC=C;
for j=N/2-column_W/2+1:1:N/2+column_W/2%把参数加到矩阵的正中间
    for i=M/2-row_W/2+1:1:M/2+row_W/2
        if(picture(i-M/2+row_W/2,j-N/2+column_W/2)>0)
           WaterC(i,j)=WaterC(i,j)-mod(WaterC(i,j),s)+3*s/4;%把信息隐藏在DWT后的水平 垂直 对角细节分量合并成的矩阵中，为了达到抗旋转的效果把参数加到图像的正中间
        else 
           WaterC(i,j)=WaterC(i,j)-mod(WaterC(i,j),s)+s/4;
        end     
    end
end
%重构图像
WaterCH=WaterC(1:length,1:width);
WaterCV=WaterC(1:length,width+1:2*width);
WaterCD=WaterC(1:length,2*width+1:3*width);
IW=uint8(idwt2(CA,WaterCH,WaterCV,WaterCD,'db1'));


%对含水印图像进行攻击 
%1.对含水印图像进行JPEG压缩
%imwrite(IW,'JPEG_attack.bmp','jpeg','Quality',50); %最后的这个参数为压缩强度，其值越大压缩程度越小，提取出的水印效果越好
%IW=imread('JPEG_attack.bmp'); %本次实验加噪强度调节范围为30:5:60值，其中强度为49、50、51的地方有畸变

%2.对含水印图像进行加噪声
%IW=imnoise(IW,'gaussian',0.1,0); %对含水印图像进行加噪声。椒盐噪声'salt & pepper'

%3.对含水印图像进行旋转
IW=imrotate(IW,3,'nearest','crop'); %第二个参数为旋转强度，可以调节，正数表示逆时针旋转，负数是顺时针旋转
%显示原始图像
figure;
subplot(2,2,1);
imshow(Img);
title('原始图像');
%显示嵌入水印后的图像
subplot(2,2,2);
imshow(IW);
title('add watermark');

%%%%%下面这一段为抗旋转处理
for i=1:row %看IW一行中第一个非零点是谁
    if(IW(1,i)~=0)
    aa=i-1;
    break;
    end
end

for i=1:column%看IW一列中第一个非零点是谁
    if(IW(i,1)~=0)
    bb=i;
    break;
    end
end
if(aa>bb)%这里加入判断的原因是原图可能是顺时针旋转也可能是逆时针旋转，所以应该分情况处理
angle=round(atan(bb/aa)*180/pi);%通过反三角函数得到旋转的度数
IW=imrotate(IW,-angle,'nearest','crop'); %再转回去
else
angle=round(atan(aa/bb)*180/pi);
IW=imrotate(IW,angle,'nearest','crop'); %再转回去  
end
%
%提取水印
[WCA,WCH,WCV,WCD]=dwt2(IW,'db1');%对IW进行DWT变换
WAC=[WCH WCV WCD];
for j=N/2-column_W/2+1:1:N/2+column_W/2%从矩阵正中间提取参数
    for i=M/2-row_W/2+1:1:M/2+row_W/2
        R=mod(WAC(i,j),s); %
      if ((s/2)<=R && R<s)
            WaterCX(i-M/2+row_W/2,j-N/2+column_W/2)=1; %如果 s/2<=余数<s,则嵌入的水印序列为1;
      else
             WaterCX(i-M/2+row_W/2,j-N/2+column_W/2)=0; %如果 0<=余数<s/2,则嵌入的水印序列为0;
      end              
        
    end
end

WaterCX_line=reshape(WaterCX,[1,row_W*column_W]);
%WaterCX为提取出的水印

%InvArnold(WaterCX,2);%反置乱
oo=inhundun(WaterCX);%混沌反置乱
%计算误比特率

BER=sum(abs(WaterCX_line-picture_line))/(64*64) %计算误比特率，并显示其值
sum1=0;sum2=0;
for i=1:row_W
    for j=1:column_W
        sum1=sum1+double(WaterCX(i,j))*double(picture(i,j));
        sum2=sum2+double(picture(i,j))*double(picture(i,j));
    end
end

%计算相似度
NC=sum1/sum2 

PSNR=PSNR(WaterCX,picture)
