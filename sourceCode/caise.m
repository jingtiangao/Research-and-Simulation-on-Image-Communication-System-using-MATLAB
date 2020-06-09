I1=imread('lena512_24bits.bmp');%%读bmp灰度图像
%figure,imshow(I1,[]);%%title('原始图像');
R=I1(:,:,1);
G=I1(:,:,2);
B=I1(:,:,3);
%figure,imshow(B,[]);
%利用RGB得到亮度Y与色度CR,CB
Y=0.299*R+0.587*G+0.114*B;
CR=(R-Y)./1.402;
CB=(B-Y)./1.772;
%%进行jpeg编码，以下为解码后的Y CR CB
RECY=func_DCTJPEG(Y,1);
RECCR=func_DCTJPEG_corlor(CR,1);
RECCB=func_DCTJPEG_corlor(CB,1);
%%恢复为原图
R1=RECY+1.402*RECCR;
G1=RECY-0.344*RECCB-0.714*RECCR;
B1=RECY+1.772*RECCB;
I2=[uint8(R1) uint8(G1) uint8(B1)];
I2=reshape(I2,512,512,3);%把解码后的亮度和色度整成RGB图
figure,imshow(I2,[]);
%%%%%
%给彩色图像加噪声
%%%%%


%%%%%%%%%
%%椒盐噪声
%%%%%%%%%



J=imnoise(I1,'salt & pepper',0.02); 

%h=ones(3,3)/9;%产生3*3的全1数组 

%B=conv2(J,h);%卷积运算 

K9r=filter2(fspecial('average',3),J(:,:,1))/255; %均值滤波模板尺寸为3 
K9g=filter2(fspecial('average',3),J(:,:,2))/255; %均值滤波模板尺寸为3 
K9b=filter2(fspecial('average',3),J(:,:,3))/255; %均值滤波模板尺寸为3 

K9=[K9r K9g K9b];
K9=reshape(K9,512,512,3);%把三个二维的搞成一个三维的矩阵

K10r= medfilt2(J(:,:,1));%采用二维中值滤波函数medfilt2对受椒盐噪声干扰的图像滤波 
K10g= medfilt2(J(:,:,2));%采用二维中值滤波函数medfilt2对受椒盐噪声干扰的图像滤波 
K10b= medfilt2(J(:,:,3));%采用二维中值滤波函数medfilt2对受椒盐噪声干扰的图像滤波 
K10=[K10r K10g K10b];
K10=reshape(K10,512,512,3);%把三个二维的搞成一个三维的矩阵

K11r=wiener2(J(:,:,1),[3 3]); %对加噪图像进行二维自适应维纳滤波
K11g=wiener2(J(:,:,2),[3 3]); %对加噪图像进行二维自适应维纳滤波   
K11b=wiener2(J(:,:,3),[3 3]); %对加噪图像进行二维自适应维纳滤波   
K11=[K11r K11g K11b];
K11=reshape(K11,512,512,3);%把三个二维的搞成一个三维的矩阵
figure(2);
subplot(2,3,1);imshow(I1); 

title('原始图像'); 

subplot(2,3,2);imshow(J); 

title('加椒盐噪声图像'); 

subplot(2,3,3);imshow(K9); 

title('均值滤波后的图像'); 

subplot(2,3,4);imshow(K10); 

title('中值滤波后的图像'); 

subplot(2,3,5);imshow(K11); 

title('维纳滤波后的图像'); 








