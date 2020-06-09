clc
clear all;
close all;
Img=imread('lena512_24bits.bmp'); %读入原始载体图像 
[row column]=size(Img);             
%Img_source=reshape(Img',[],1);%将512*512重塑成262144*1一行行拉成一条
%L=length(Img_source); %图像数据总数
figure,imshow(Img,[]);%%title('原始图像');
ImgR=Img(:,:,1);
ImgG=Img(:,:,2);
ImgB=Img(:,:,3);
%figure,imshow(B,[]);
picture_ori=imread('SOX_24bits.bmp'); %读入水印图像
picture=hundun_corlor(picture_ori);
%figure,imshow(picture_ori,[]);
pictureR=picture(:,:,1);%得到水印的RGB
pictureG=picture(:,:,2);
pictureB=picture(:,:,3);
%picture=hundun(picture_ori);%混沌置乱
[row_W,column_W]=size(pictureR); %获取水印图片的行列值
%picture_line=reshape(picture,[1,row_W*column_W]); %将picture拉成一条
[CAR,CHR,CVR,CDR]=dwt2(ImgR,'db1');%DWT后获得水平 垂直 对角细节分量 R
[CAG,CHG,CVG,CDG]=dwt2(ImgG,'db1');%DWT后获得水平 垂直 对角细节分量 G
[CAB,CHB,CVB,CDB]=dwt2(ImgB,'db1');%DWT后获得水平 垂直 对角细节分量 B

CR=[CHR CVR CDR];
CG=[CHG CVG CDG];
CB=[CHB CVB CDB];

[length,width]=size(CAR);
[M,N]=size(CR);
T1=0;
s=10;%影响印章，强转为低频

%加入水印R 
WaterCR=CR;
for j=N/2-column_W/2+1:1:N/2+column_W/2%把参数加到矩阵的正中间
    for i=M/2-row_W/2+1:1:M/2+row_W/2
        if(pictureR(i-M/2+row_W/2,j-N/2+column_W/2)>0)
           WaterCR(i,j)=WaterCR(i,j)-mod(WaterCR(i,j),s)+3*s/4;%把信息隐藏在DWT后的水平 垂直 对角细节分量合并成的矩阵中，为了达到抗旋转的效果把参数加到图像的正中间
        else 
           WaterCR(i,j)=WaterCR(i,j)-mod(WaterCR(i,j),s)+s/4;
        end     
    end
end

%加入水印G 
WaterCG=CG;
for j=N/2-column_W/2+1:1:N/2+column_W/2%把参数加到矩阵的正中间
    for i=M/2-row_W/2+1:1:M/2+row_W/2
        if(pictureG(i-M/2+row_W/2,j-N/2+column_W/2)>0)
           WaterCG(i,j)=WaterCG(i,j)-mod(WaterCG(i,j),s)+3*s/4;%把信息隐藏在DWT后的水平 垂直 对角细节分量合并成的矩阵中，为了达到抗旋转的效果把参数加到图像的正中间
        else 
           WaterCG(i,j)=WaterCG(i,j)-mod(WaterCG(i,j),s)+s/4;
        end     
    end
end

%加入水印  B
WaterCB=CB;
for j=N/2-column_W/2+1:1:N/2+column_W/2%把参数加到矩阵的正中间
    for i=M/2-row_W/2+1:1:M/2+row_W/2
        if(pictureB(i-M/2+row_W/2,j-N/2+column_W/2)>0)
           WaterCB(i,j)=WaterCB(i,j)-mod(WaterCB(i,j),s)+3*s/4;%把信息隐藏在DWT后的水平 垂直 对角细节分量合并成的矩阵中，为了达到抗旋转的效果把参数加到图像的正中间
        else 
           WaterCB(i,j)=WaterCB(i,j)-mod(WaterCB(i,j),s)+s/4;
        end     
    end
end

%重构图像R
WaterCHR=WaterCR(1:length,1:width);
WaterCVR=WaterCR(1:length,width+1:2*width);
WaterCDR=WaterCR(1:length,2*width+1:3*width);
IWR=uint8(idwt2(CAR,WaterCHR,WaterCVR,WaterCDR,'db1'));


%重构图像R
WaterCHG=WaterCG(1:length,1:width);
WaterCVG=WaterCG(1:length,width+1:2*width);
WaterCDG=WaterCG(1:length,2*width+1:3*width);
IWG=uint8(idwt2(CAG,WaterCHG,WaterCVG,WaterCDG,'db1'));


%重构图像B
WaterCHB=WaterCB(1:length,1:width);
WaterCVB=WaterCB(1:length,width+1:2*width);
WaterCDB=WaterCB(1:length,2*width+1:3*width);
IWB=uint8(idwt2(CAB,WaterCHB,WaterCVB,WaterCDB,'db1'));

%整成RGB图
IW=[uint8(IWR) uint8(IWG) uint8(IWB)];
IW=reshape(IW,512,512,3);%整成RGB图
figure,imshow(IW,[]);title('加水印后图像');


%对含水印图像进行攻击 
%1.对含水印图像进行JPEG压缩
%imwrite(IW,'JPEG_attack.bmp','jpeg','Quality',50); %最后的这个参数为压缩强度，其值越大压缩程度越小，提取出的水印效果越好
%IW=imread('JPEG_attack.bmp'); %本次实验加噪强度调节范围为30:5:60值，其中强度为49、50、51的地方有畸变

%2.对含水印图像进行加噪声
%IW=imnoise(IW,'gaussian',16/255, 5/(255*255)); %对含水印图像进行加噪声。椒盐噪声'salt & pepper'

%3.对含水印图像进行旋转
%IW=imrotate(IW,20,'nearest','crop'); %第二个参数为旋转强度，可以调节，正数表示逆时针旋转，负数是顺时针旋转

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



IWR=IW(:,:,1);
IWG=IW(:,:,2);
IWB=IW(:,:,3);



%提取水印 R
[WCAR,WCHR,WCVR,WCDR]=dwt2(IWR,'db1');%对IW进行DWT变换
WACR=[WCHR WCVR WCDR];
for j=N/2-column_W/2+1:1:N/2+column_W/2%从矩阵正中间提取参数
    for i=M/2-row_W/2+1:1:M/2+row_W/2
        R=mod(WACR(i,j),s); %
      if ((s/2)<=R && R<s)
            WaterCXR(i-M/2+row_W/2,j-N/2+column_W/2)=255; %如果 s/2<=余数<s,则嵌入的水印序列为1;
      else
             WaterCXR(i-M/2+row_W/2,j-N/2+column_W/2)=0; %如果 0<=余数<s/2,则嵌入的水印序列为0;
      end              
        
    end
end

%WaterCX_line=reshape(WaterCX,[1,row_W*column_W]);


%提取水印 G
[WCAG,WCHG,WCVG,WCDG]=dwt2(IWG,'db1');%对IW进行DWT变换
WACG=[WCHG WCVG WCDG];
for j=N/2-column_W/2+1:1:N/2+column_W/2%从矩阵正中间提取参数
    for i=M/2-row_W/2+1:1:M/2+row_W/2
        G=mod(WACG(i,j),s); %
      if ((s/2)<=G && G<s)
            WaterCXG(i-M/2+row_W/2,j-N/2+column_W/2)=255; %如果 s/2<=余数<s,则嵌入的水印序列为1;
      else
             WaterCXG(i-M/2+row_W/2,j-N/2+column_W/2)=0; %如果 0<=余数<s/2,则嵌入的水印序列为0;
      end              
        
    end
end

%WaterCX_line=reshape(WaterCX,[1,row_W*column_W]);


%提取水印  B
[WCAB,WCHB,WCVB,WCDB]=dwt2(IWB,'db1');%对IW进行DWT变换
WACB=[WCHB WCVB WCDB];
for j=N/2-column_W/2+1:1:N/2+column_W/2%从矩阵正中间提取参数
    for i=M/2-row_W/2+1:1:M/2+row_W/2
        B=mod(WACB(i,j),s); %
      if ((s/2)<=B && B<s)
            WaterCXB(i-M/2+row_W/2,j-N/2+column_W/2)=255; %如果 s/2<=余数<s,则嵌入的水印序列为1;
      else
             WaterCXB(i-M/2+row_W/2,j-N/2+column_W/2)=0; %如果 0<=余数<s/2,则嵌入的水印序列为0;
      end              
        
    end
end


WaterCX=[uint8(WaterCXR) uint8(WaterCXG) uint8(WaterCXB)];
WaterCX=reshape(WaterCX,64,64,3);%整成RGB图

OO=inhundun_color(WaterCX);%混沌反置乱
%figure,imshow(WaterCX,[]);title('解出的水印');
%WaterCX_line=reshape(WaterCX,[1,row_W*column_W]);


