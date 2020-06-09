%% ************* ����DWT�任��ͼ��ˮӡ�㷨ʵ�֣�ˮӡǶ�� **************
%function watermarked_DWT(s)
clc
clear all;
close all;
Img=imread('Lena512.bmp'); %����ԭʼ����ͼ�� 
[row column]=size(Img);             
Img_source=reshape(Img',[],1);%��512*512���ܳ�262144*1һ��������һ��
L=length(Img_source); %ͼ����������

%picture=imread('SOX.bmp');%picture=Arnold('SOX.bmp',2);%arnold����
picture_ori=imread('SOX.bmp'); %����ˮӡͼ��
picture=hundun(picture_ori);%��������
[row_W,column_W]=size(picture); %��ȡˮӡͼƬ������ֵ
picture_line=reshape(picture,[1,row_W*column_W]); %��picture����һ��
[CA,CH,CV,CD]=dwt2(Img,'db1');%DWT����ˮƽ ��ֱ �Խ�ϸ�ڷ���
C=[CH CV CD];
[length,width]=size(CA);
[M,N]=size(C);
T1=0;
s=20;%Ӱ��ӡ�£�ǿתΪ��Ƶ
%����ˮӡ
WaterC=C;
for j=N/2-column_W/2+1:1:N/2+column_W/2%�Ѳ����ӵ���������м�
    for i=M/2-row_W/2+1:1:M/2+row_W/2
        if(picture(i-M/2+row_W/2,j-N/2+column_W/2)>0)
           WaterC(i,j)=WaterC(i,j)-mod(WaterC(i,j),s)+3*s/4;%����Ϣ������DWT���ˮƽ ��ֱ �Խ�ϸ�ڷ����ϲ��ɵľ����У�Ϊ�˴ﵽ����ת��Ч���Ѳ����ӵ�ͼ������м�
        else 
           WaterC(i,j)=WaterC(i,j)-mod(WaterC(i,j),s)+s/4;
        end     
    end
end
%�ع�ͼ��
WaterCH=WaterC(1:length,1:width);
WaterCV=WaterC(1:length,width+1:2*width);
WaterCD=WaterC(1:length,2*width+1:3*width);
IW=uint8(idwt2(CA,WaterCH,WaterCV,WaterCD,'db1'));


%�Ժ�ˮӡͼ����й��� 
%1.�Ժ�ˮӡͼ�����JPEGѹ��
%imwrite(IW,'JPEG_attack.bmp','jpeg','Quality',50); %�����������Ϊѹ��ǿ�ȣ���ֵԽ��ѹ���̶�ԽС����ȡ����ˮӡЧ��Խ��
%IW=imread('JPEG_attack.bmp'); %����ʵ�����ǿ�ȵ��ڷ�ΧΪ30:5:60ֵ������ǿ��Ϊ49��50��51�ĵط��л���

%2.�Ժ�ˮӡͼ����м�����
%IW=imnoise(IW,'gaussian',0.1,0); %�Ժ�ˮӡͼ����м���������������'salt & pepper'

%3.�Ժ�ˮӡͼ�������ת
IW=imrotate(IW,3,'nearest','crop'); %�ڶ�������Ϊ��תǿ�ȣ����Ե��ڣ�������ʾ��ʱ����ת��������˳ʱ����ת
%��ʾԭʼͼ��
figure;
subplot(2,2,1);
imshow(Img);
title('ԭʼͼ��');
%��ʾǶ��ˮӡ���ͼ��
subplot(2,2,2);
imshow(IW);
title('add watermark');

%%%%%������һ��Ϊ����ת����
for i=1:row %��IWһ���е�һ���������˭
    if(IW(1,i)~=0)
    aa=i-1;
    break;
    end
end

for i=1:column%��IWһ���е�һ���������˭
    if(IW(i,1)~=0)
    bb=i;
    break;
    end
end
if(aa>bb)%��������жϵ�ԭ����ԭͼ������˳ʱ����תҲ��������ʱ����ת������Ӧ�÷��������
angle=round(atan(bb/aa)*180/pi);%ͨ�������Ǻ����õ���ת�Ķ���
IW=imrotate(IW,-angle,'nearest','crop'); %��ת��ȥ
else
angle=round(atan(aa/bb)*180/pi);
IW=imrotate(IW,angle,'nearest','crop'); %��ת��ȥ  
end
%
%��ȡˮӡ
[WCA,WCH,WCV,WCD]=dwt2(IW,'db1');%��IW����DWT�任
WAC=[WCH WCV WCD];
for j=N/2-column_W/2+1:1:N/2+column_W/2%�Ӿ������м���ȡ����
    for i=M/2-row_W/2+1:1:M/2+row_W/2
        R=mod(WAC(i,j),s); %
      if ((s/2)<=R && R<s)
            WaterCX(i-M/2+row_W/2,j-N/2+column_W/2)=1; %��� s/2<=����<s,��Ƕ���ˮӡ����Ϊ1;
      else
             WaterCX(i-M/2+row_W/2,j-N/2+column_W/2)=0; %��� 0<=����<s/2,��Ƕ���ˮӡ����Ϊ0;
      end              
        
    end
end

WaterCX_line=reshape(WaterCX,[1,row_W*column_W]);
%WaterCXΪ��ȡ����ˮӡ

%InvArnold(WaterCX,2);%������
oo=inhundun(WaterCX);%���練����
%�����������

BER=sum(abs(WaterCX_line-picture_line))/(64*64) %����������ʣ�����ʾ��ֵ
sum1=0;sum2=0;
for i=1:row_W
    for j=1:column_W
        sum1=sum1+double(WaterCX(i,j))*double(picture(i,j));
        sum2=sum2+double(picture(i,j))*double(picture(i,j));
    end
end

%�������ƶ�
NC=sum1/sum2 

PSNR=PSNR(WaterCX,picture)
