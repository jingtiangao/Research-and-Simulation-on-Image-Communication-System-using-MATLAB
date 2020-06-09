function Scambled=hundun_corlor(Image)

imshow(Image);

ImageR=Image(:,:,1);
ImageG=Image(:,:,2);
ImageB=Image(:,:,3);
[m,n]=size(ImageR);
%产生混沌序列
x(1)=0.5;
for i=1:m*n-1
    x(i+1)=3.7*x(i)*(1-x(i));
end
[y,num]=sort(x);%将产生的混沌序列进行排序

ScambledR=uint8(zeros(m,n));%产生一个与原图大小相同的0矩阵
for i=1:m*n
    ScambledR(i)=ImageR(num(i));
end

ScambledG=uint8(zeros(m,n));%产生一个与原图大小相同的0矩阵
for i=1:m*n
    ScambledG(i)=ImageG(num(i));
end

ScambledB=uint8(zeros(m,n));%产生一个与原图大小相同的0矩阵
for i=1:m*n
    ScambledB(i)=ImageB(num(i));
end
Scambled=[uint8(ScambledR) uint8(ScambledG) uint8(ScambledB)];
Scambled=reshape(Scambled,64,64,3);%整成RGB图

figure(2);

imshow(Scambled);title('混沌置乱图像');