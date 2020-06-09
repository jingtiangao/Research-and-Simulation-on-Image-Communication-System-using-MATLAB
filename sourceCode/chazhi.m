I=imread('lena512.bmp');%%��bmp�Ҷ�ͼ��
I1=imread('Peppers512.bmp');
I2=imread('Barbara512.bmp');
I3=imread('Mandrill512.bmp');
Q=[9,4,2.5,2,1,0.5,0.4,0.3];%%�趨��������
IDS1=downsample(I1,2);%��ÿ�н�����2����256*512
IDS1=downsample(IDS1',2);%��IDSת�õ�ÿһ�н�����2������Ҳ���Ƕ�ת��ǰ��ÿһ�н�����2��������һ����ת�û���
IDS1=IDS1';%ת�û����õ���2������ֵ 256*256

IDS2=downsample(I2,2);%��ÿ�н�����2����256*512
IDS2=downsample(IDS2',2);%��IDSת�õ�ÿһ�н�����2������Ҳ���Ƕ�ת��ǰ��ÿһ�н�����2��������һ����ת�û���
IDS2=IDS2';%ת�û����õ���2������ֵ 256*256

IDS3=downsample(I3,2);%��ÿ�н�����2����256*512
IDS3=downsample(IDS3',2);%��IDSת�õ�ÿһ�н�����2������Ҳ���Ƕ�ת��ǰ��ÿһ�н�����2��������һ����ת�û���
IDS3=IDS3';%ת�û����õ���2������ֵ 256*256

IDS=downsample(I,2);%��ÿ�н�����2����256*512
IDS=downsample(IDS',2);%��IDSת�õ�ÿһ�н�����2������Ҳ���Ƕ�ת��ǰ��ÿһ�н�����2��������һ����ת�û���
IDS=IDS';%ת�û����õ���2������ֵ 256*256
A=dyadup(IDS,0);
A=[A A(:,2)];
A=dyadup(A',0);
A=[A A(:,2)];
A=A';%%�˶γ���Ϊ���������IDS����ʹ���256*256���512*512
%%�Դ�ͼ�����256*256 JPEG����
[PIC,bpp,psnr]=func_DCTJPEG(IDS,1);
%�ڲ�
near=imresize(PIC,[512 512],'nearest');%ʹ��IMRESIZE��ͼ��������Ŵ�������ڲ�ֵ
bili=imresize(PIC,[512 512],'bilinear');%˫���Բ�ֵ
cubic=imresize(PIC,[512 512],'bicubic');%�������
subplot(2,2,1);
imshow(I,[]);title('ԭʼͼ��');
subplot(2,2,2);
imshow(near,[]);title('����ڲ�ֵ');
subplot(2,2,3);
imshow(bili,[]);title('˫���Բ�ֵ');
subplot(2,2,4);
imshow(cubic,[]);title('�������');
%����ͬһ��ͼ�ڲ�ͬѹ�����£���ͬ��ֵ�����Ƚ�%
cbpp=[];csnr=[];cbpp1=[];csnr1=[];cbpp2=[];csnr2=[];

for i=1:8    %�õ���ͬQֵ��Ӧ��lena�����������PSNR
[R,cbpp(i),b]=func_DCTJPEG(IDS,Q(i));
near=imresize(R,[512 512],'nearest');%ʹ��IMRESIZE��ͼ��������Ŵ�������ڲ�ֵ
bili=imresize(R,[512 512],'bilinear');%˫���Բ�ֵ
cubic=imresize(R,[512 512],'bicubic');%�������
csnr1(i)=PSNR(near,I);
csnr2(i)=PSNR(bili,I);
csnr3(i)=PSNR(cubic,I);
end

plot(bpp,snr,cbpp,csnr1,':',cbpp,csnr2,'*',cbpp,csnr3,'-.')
xlabel('���������/bpp');
ylabel('PSNR/db');
legend('ԭʼͼ��Lena','����ڲ�ֵ','˫���Բ�ֵ','�������');
grid on;
%��ͬͼ����ͬһѹ�����£���ͬ��ֵ�����Ƚ�%
x=1:4;
%��4��ͼ��4�εõ�3������%
[R,a,b]=func_DCTJPEG(IDS1,1);
near=imresize(R,[512 512],'nearest');%ʹ��IMRESIZE��ͼ��������Ŵ�������ڲ�ֵ
bili=imresize(R,[512 512],'bilinear');%˫���Բ�ֵ
cubic=imresize(R,[512 512],'bicubic');%�������
csnr11(1)=PSNR(near,I1);
csnr22(1)=PSNR(bili,I1);
csnr33(1)=PSNR(cubic,I1);

[R,a,b]=func_DCTJPEG(IDS2,1);
near=imresize(R,[512 512],'nearest');%ʹ��IMRESIZE��ͼ��������Ŵ�������ڲ�ֵ
bili=imresize(R,[512 512],'bilinear');%˫���Բ�ֵ
cubic=imresize(R,[512 512],'bicubic');%�������
csnr11(2)=PSNR(near,I2);
csnr22(2)=PSNR(bili,I2);
csnr33(2)=PSNR(cubic,I2);


[R,a,b]=func_DCTJPEG(IDS3,1);
near=imresize(R,[512 512],'nearest');%ʹ��IMRESIZE��ͼ��������Ŵ�������ڲ�ֵ
bili=imresize(R,[512 512],'bilinear');%˫���Բ�ֵ
cubic=imresize(R,[512 512],'bicubic');%�������
csnr11(3)=PSNR(near,I3);
csnr22(3)=PSNR(bili,I3);
csnr33(3)=PSNR(cubic,I3);

csnr11(4)=27.665;
csnr22(4)=29.352;
csnr33(4)=29.099;
figure(2);
plot(x,csnr11,':',x,csnr22,'*',x,csnr33,'-.')
xlabel('ͼ������');
ylabel('PSNR/db');
set(gca,'XTick',1:4);  set(gca,'XTickLabel',{'Peppers','Barbara','Mandrill','Lena'});  
legend('����ڲ�ֵ','˫���Բ�ֵ','�������');
grid on;





