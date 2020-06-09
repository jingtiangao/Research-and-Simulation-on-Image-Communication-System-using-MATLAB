function IScamble=inhundun_color(Image)
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

IScambleR=uint8(zeros(m,n));%产生一个与原图大小相同的0矩阵

for i=1:m*n

    IScambleR(num(i))=ImageR(i);

end


IScambleG=uint8(zeros(m,n));%产生一个与原图大小相同的0矩阵

for i=1:m*n

    IScambleG(num(i))=ImageG(i);

end


IScambleB=uint8(zeros(m,n));%产生一个与原图大小相同的0矩阵

for i=1:m*n

    IScambleB(num(i))=ImageB(i);

end

IScamble=[uint8(IScambleR) uint8(IScambleG) uint8(IScambleB)];
IScamble=reshape(IScamble,64,64,3);%整成RGB图


figure(3);

subplot(2,2,1);imshow(Image);title('待恢复的图像');
subplot(2,2,2); imshow(IScamble); title('置乱反变换后的原图');