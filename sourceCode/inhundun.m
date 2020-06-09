function IScamble=inhundun(Image)
[m,n]=size(Image);
%产生混沌序列
x(1)=0.5;
for i=1:m*n-1
    x(i+1)=3.7*x(i)*(1-x(i));
end
[y,num]=sort(x);%将产生的混沌序列进行排序
IScamble=uint8(zeros(m,n));%产生一个与原图大小相同的0矩阵

for i=1:m*n

    IScamble(num(i))=Image(i);

end

figure(3);
IScamble=logical(IScamble);
subplot(2,2,1);imshow(Image);title('待恢复的图像');
subplot(2,2,2); imshow(IScamble); title('置乱反变换后的原图');