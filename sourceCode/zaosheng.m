%����ȥ��
I=imread('lena512.bmp');%%��bmp�Ҷ�ͼ��
figure,imshow(I,[]);%%title('ԭʼͼ��');
J=imnoise(I,'gaussian',0, 0.005);%�����ֵΪ0������Ϊ0.005�ĸ�˹���� 
Q=[9,4,2.5,2,1,0.5,0.4,0.3];%%�趨��������
%%%%%%%%%
%%��������
%%%%%%%%%

%J=imnoise(I,'salt & pepper',0.02); 

%h=ones(3,3)/9;%����3*3��ȫ1���� 

%B=conv2(J,h);%������� 

K9=filter2(fspecial('average',3),J); %��ֵ�˲�ģ��ߴ�Ϊ3 
K9=uint8(K9);
K10= medfilt2(J);%���ö�ά��ֵ�˲�����medfilt2���ܽ����������ŵ�ͼ���˲� 

K11=wiener2(J,[3 3]); %�Լ���ͼ����ж�ά����Ӧά���˲�     
figure(2);
%subplot(2,3,1);
imshow(I); 

title('ԭʼͼ��'); 

subplot(2,3,2);imshow(J); 

title('����ͼ��'); 

subplot(2,3,3);imshow(K9); 

title('��ֵ�˲����ͼ��'); 

subplot(2,3,4);imshow(K10); 

title('��ֵ�˲����ͼ��'); 

subplot(2,3,5);imshow(K11); 

title('ά���˲����ͼ��'); 

noibpp=[];noisnr=[];noibpp1=[];noisnr1=[];noibpp2=[];noisnr2=[];
%�Ծ�ֵ�˲���ͼ�����JPEGѹ�������ҵõ�BPP ��PSNR
for i=1:8    %�õ���ͬQֵ��Ӧ��lena�����������PSNR��
[P,noibpp(i),noisnr(i)]=func_DCTJPEG(K9,Q(i));
end
%����ֵ�˲���ͼ�����JPEGѹ�������ҵõ�BPP ��PSNR
for i=1:8    %�õ���ͬQֵ��Ӧ�ı����������PSNR
[P,noibpp1(i),noisnr1(i)]=func_DCTJPEG(K10,Q(i));
end
%��ά���˲���ͼ�����JPEGѹ�������ҵõ�BPP ��PSNR
for i=1:8    %�õ���ͬQֵ��Ӧ�ı����������PSNR��
[P,noibpp2(i),noisnr2(i)]=func_DCTJPEG(K11,Q(i));
end
figure(3);
plot(bpp,snr,noibpp,noisnr,':',noibpp1,noisnr1,'*',noibpp2,noisnr2,'-.')
xlabel('���������/bpp');
ylabel('PSNR/db');
legend('lenaԭʼͼ','�����ֵ�˲���ͼ','������ֵ�˲���ͼ','����ά���˲���ͼ');
grid on;





