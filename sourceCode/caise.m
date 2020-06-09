I1=imread('lena512_24bits.bmp');%%��bmp�Ҷ�ͼ��
%figure,imshow(I1,[]);%%title('ԭʼͼ��');
R=I1(:,:,1);
G=I1(:,:,2);
B=I1(:,:,3);
%figure,imshow(B,[]);
%����RGB�õ�����Y��ɫ��CR,CB
Y=0.299*R+0.587*G+0.114*B;
CR=(R-Y)./1.402;
CB=(B-Y)./1.772;
%%����jpeg���룬����Ϊ������Y CR CB
RECY=func_DCTJPEG(Y,1);
RECCR=func_DCTJPEG_corlor(CR,1);
RECCB=func_DCTJPEG_corlor(CB,1);
%%�ָ�Ϊԭͼ
R1=RECY+1.402*RECCR;
G1=RECY-0.344*RECCB-0.714*RECCR;
B1=RECY+1.772*RECCB;
I2=[uint8(R1) uint8(G1) uint8(B1)];
I2=reshape(I2,512,512,3);%�ѽ��������Ⱥ�ɫ������RGBͼ
figure,imshow(I2,[]);
%%%%%
%����ɫͼ�������
%%%%%


%%%%%%%%%
%%��������
%%%%%%%%%



J=imnoise(I1,'salt & pepper',0.02); 

%h=ones(3,3)/9;%����3*3��ȫ1���� 

%B=conv2(J,h);%������� 

K9r=filter2(fspecial('average',3),J(:,:,1))/255; %��ֵ�˲�ģ��ߴ�Ϊ3 
K9g=filter2(fspecial('average',3),J(:,:,2))/255; %��ֵ�˲�ģ��ߴ�Ϊ3 
K9b=filter2(fspecial('average',3),J(:,:,3))/255; %��ֵ�˲�ģ��ߴ�Ϊ3 

K9=[K9r K9g K9b];
K9=reshape(K9,512,512,3);%��������ά�ĸ��һ����ά�ľ���

K10r= medfilt2(J(:,:,1));%���ö�ά��ֵ�˲�����medfilt2���ܽ����������ŵ�ͼ���˲� 
K10g= medfilt2(J(:,:,2));%���ö�ά��ֵ�˲�����medfilt2���ܽ����������ŵ�ͼ���˲� 
K10b= medfilt2(J(:,:,3));%���ö�ά��ֵ�˲�����medfilt2���ܽ����������ŵ�ͼ���˲� 
K10=[K10r K10g K10b];
K10=reshape(K10,512,512,3);%��������ά�ĸ��һ����ά�ľ���

K11r=wiener2(J(:,:,1),[3 3]); %�Լ���ͼ����ж�ά����Ӧά���˲�
K11g=wiener2(J(:,:,2),[3 3]); %�Լ���ͼ����ж�ά����Ӧά���˲�   
K11b=wiener2(J(:,:,3),[3 3]); %�Լ���ͼ����ж�ά����Ӧά���˲�   
K11=[K11r K11g K11b];
K11=reshape(K11,512,512,3);%��������ά�ĸ��һ����ά�ľ���
figure(2);
subplot(2,3,1);imshow(I1); 

title('ԭʼͼ��'); 

subplot(2,3,2);imshow(J); 

title('�ӽ�������ͼ��'); 

subplot(2,3,3);imshow(K9); 

title('��ֵ�˲����ͼ��'); 

subplot(2,3,4);imshow(K10); 

title('��ֵ�˲����ͼ��'); 

subplot(2,3,5);imshow(K11); 

title('ά���˲����ͼ��'); 








