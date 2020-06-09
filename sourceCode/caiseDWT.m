clc
clear all;
close all;
Img=imread('lena512_24bits.bmp'); %����ԭʼ����ͼ�� 
[row column]=size(Img);             
%Img_source=reshape(Img',[],1);%��512*512���ܳ�262144*1һ��������һ��
%L=length(Img_source); %ͼ����������
figure,imshow(Img,[]);%%title('ԭʼͼ��');
ImgR=Img(:,:,1);
ImgG=Img(:,:,2);
ImgB=Img(:,:,3);
%figure,imshow(B,[]);
picture_ori=imread('SOX_24bits.bmp'); %����ˮӡͼ��
picture=hundun_corlor(picture_ori);
%figure,imshow(picture_ori,[]);
pictureR=picture(:,:,1);%�õ�ˮӡ��RGB
pictureG=picture(:,:,2);
pictureB=picture(:,:,3);
%picture=hundun(picture_ori);%��������
[row_W,column_W]=size(pictureR); %��ȡˮӡͼƬ������ֵ
%picture_line=reshape(picture,[1,row_W*column_W]); %��picture����һ��
[CAR,CHR,CVR,CDR]=dwt2(ImgR,'db1');%DWT����ˮƽ ��ֱ �Խ�ϸ�ڷ��� R
[CAG,CHG,CVG,CDG]=dwt2(ImgG,'db1');%DWT����ˮƽ ��ֱ �Խ�ϸ�ڷ��� G
[CAB,CHB,CVB,CDB]=dwt2(ImgB,'db1');%DWT����ˮƽ ��ֱ �Խ�ϸ�ڷ��� B

CR=[CHR CVR CDR];
CG=[CHG CVG CDG];
CB=[CHB CVB CDB];

[length,width]=size(CAR);
[M,N]=size(CR);
T1=0;
s=10;%Ӱ��ӡ�£�ǿתΪ��Ƶ

%����ˮӡR 
WaterCR=CR;
for j=N/2-column_W/2+1:1:N/2+column_W/2%�Ѳ����ӵ���������м�
    for i=M/2-row_W/2+1:1:M/2+row_W/2
        if(pictureR(i-M/2+row_W/2,j-N/2+column_W/2)>0)
           WaterCR(i,j)=WaterCR(i,j)-mod(WaterCR(i,j),s)+3*s/4;%����Ϣ������DWT���ˮƽ ��ֱ �Խ�ϸ�ڷ����ϲ��ɵľ����У�Ϊ�˴ﵽ����ת��Ч���Ѳ����ӵ�ͼ������м�
        else 
           WaterCR(i,j)=WaterCR(i,j)-mod(WaterCR(i,j),s)+s/4;
        end     
    end
end

%����ˮӡG 
WaterCG=CG;
for j=N/2-column_W/2+1:1:N/2+column_W/2%�Ѳ����ӵ���������м�
    for i=M/2-row_W/2+1:1:M/2+row_W/2
        if(pictureG(i-M/2+row_W/2,j-N/2+column_W/2)>0)
           WaterCG(i,j)=WaterCG(i,j)-mod(WaterCG(i,j),s)+3*s/4;%����Ϣ������DWT���ˮƽ ��ֱ �Խ�ϸ�ڷ����ϲ��ɵľ����У�Ϊ�˴ﵽ����ת��Ч���Ѳ����ӵ�ͼ������м�
        else 
           WaterCG(i,j)=WaterCG(i,j)-mod(WaterCG(i,j),s)+s/4;
        end     
    end
end

%����ˮӡ  B
WaterCB=CB;
for j=N/2-column_W/2+1:1:N/2+column_W/2%�Ѳ����ӵ���������м�
    for i=M/2-row_W/2+1:1:M/2+row_W/2
        if(pictureB(i-M/2+row_W/2,j-N/2+column_W/2)>0)
           WaterCB(i,j)=WaterCB(i,j)-mod(WaterCB(i,j),s)+3*s/4;%����Ϣ������DWT���ˮƽ ��ֱ �Խ�ϸ�ڷ����ϲ��ɵľ����У�Ϊ�˴ﵽ����ת��Ч���Ѳ����ӵ�ͼ������м�
        else 
           WaterCB(i,j)=WaterCB(i,j)-mod(WaterCB(i,j),s)+s/4;
        end     
    end
end

%�ع�ͼ��R
WaterCHR=WaterCR(1:length,1:width);
WaterCVR=WaterCR(1:length,width+1:2*width);
WaterCDR=WaterCR(1:length,2*width+1:3*width);
IWR=uint8(idwt2(CAR,WaterCHR,WaterCVR,WaterCDR,'db1'));


%�ع�ͼ��R
WaterCHG=WaterCG(1:length,1:width);
WaterCVG=WaterCG(1:length,width+1:2*width);
WaterCDG=WaterCG(1:length,2*width+1:3*width);
IWG=uint8(idwt2(CAG,WaterCHG,WaterCVG,WaterCDG,'db1'));


%�ع�ͼ��B
WaterCHB=WaterCB(1:length,1:width);
WaterCVB=WaterCB(1:length,width+1:2*width);
WaterCDB=WaterCB(1:length,2*width+1:3*width);
IWB=uint8(idwt2(CAB,WaterCHB,WaterCVB,WaterCDB,'db1'));

%����RGBͼ
IW=[uint8(IWR) uint8(IWG) uint8(IWB)];
IW=reshape(IW,512,512,3);%����RGBͼ
figure,imshow(IW,[]);title('��ˮӡ��ͼ��');


%�Ժ�ˮӡͼ����й��� 
%1.�Ժ�ˮӡͼ�����JPEGѹ��
%imwrite(IW,'JPEG_attack.bmp','jpeg','Quality',50); %�����������Ϊѹ��ǿ�ȣ���ֵԽ��ѹ���̶�ԽС����ȡ����ˮӡЧ��Խ��
%IW=imread('JPEG_attack.bmp'); %����ʵ�����ǿ�ȵ��ڷ�ΧΪ30:5:60ֵ������ǿ��Ϊ49��50��51�ĵط��л���

%2.�Ժ�ˮӡͼ����м�����
%IW=imnoise(IW,'gaussian',16/255, 5/(255*255)); %�Ժ�ˮӡͼ����м���������������'salt & pepper'

%3.�Ժ�ˮӡͼ�������ת
%IW=imrotate(IW,20,'nearest','crop'); %�ڶ�������Ϊ��תǿ�ȣ����Ե��ڣ�������ʾ��ʱ����ת��������˳ʱ����ת

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



IWR=IW(:,:,1);
IWG=IW(:,:,2);
IWB=IW(:,:,3);



%��ȡˮӡ R
[WCAR,WCHR,WCVR,WCDR]=dwt2(IWR,'db1');%��IW����DWT�任
WACR=[WCHR WCVR WCDR];
for j=N/2-column_W/2+1:1:N/2+column_W/2%�Ӿ������м���ȡ����
    for i=M/2-row_W/2+1:1:M/2+row_W/2
        R=mod(WACR(i,j),s); %
      if ((s/2)<=R && R<s)
            WaterCXR(i-M/2+row_W/2,j-N/2+column_W/2)=255; %��� s/2<=����<s,��Ƕ���ˮӡ����Ϊ1;
      else
             WaterCXR(i-M/2+row_W/2,j-N/2+column_W/2)=0; %��� 0<=����<s/2,��Ƕ���ˮӡ����Ϊ0;
      end              
        
    end
end

%WaterCX_line=reshape(WaterCX,[1,row_W*column_W]);


%��ȡˮӡ G
[WCAG,WCHG,WCVG,WCDG]=dwt2(IWG,'db1');%��IW����DWT�任
WACG=[WCHG WCVG WCDG];
for j=N/2-column_W/2+1:1:N/2+column_W/2%�Ӿ������м���ȡ����
    for i=M/2-row_W/2+1:1:M/2+row_W/2
        G=mod(WACG(i,j),s); %
      if ((s/2)<=G && G<s)
            WaterCXG(i-M/2+row_W/2,j-N/2+column_W/2)=255; %��� s/2<=����<s,��Ƕ���ˮӡ����Ϊ1;
      else
             WaterCXG(i-M/2+row_W/2,j-N/2+column_W/2)=0; %��� 0<=����<s/2,��Ƕ���ˮӡ����Ϊ0;
      end              
        
    end
end

%WaterCX_line=reshape(WaterCX,[1,row_W*column_W]);


%��ȡˮӡ  B
[WCAB,WCHB,WCVB,WCDB]=dwt2(IWB,'db1');%��IW����DWT�任
WACB=[WCHB WCVB WCDB];
for j=N/2-column_W/2+1:1:N/2+column_W/2%�Ӿ������м���ȡ����
    for i=M/2-row_W/2+1:1:M/2+row_W/2
        B=mod(WACB(i,j),s); %
      if ((s/2)<=B && B<s)
            WaterCXB(i-M/2+row_W/2,j-N/2+column_W/2)=255; %��� s/2<=����<s,��Ƕ���ˮӡ����Ϊ1;
      else
             WaterCXB(i-M/2+row_W/2,j-N/2+column_W/2)=0; %��� 0<=����<s/2,��Ƕ���ˮӡ����Ϊ0;
      end              
        
    end
end


WaterCX=[uint8(WaterCXR) uint8(WaterCXG) uint8(WaterCXB)];
WaterCX=reshape(WaterCX,64,64,3);%����RGBͼ

OO=inhundun_color(WaterCX);%���練����
%figure,imshow(WaterCX,[]);title('�����ˮӡ');
%WaterCX_line=reshape(WaterCX,[1,row_W*column_W]);


