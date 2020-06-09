function Scambled=hundun(Image)

imshow(Image);
[m,n]=size(Image);

%产生混沌序列
x(1)=0.5;
for i=1:m*n-1
    x(i+1)=3.7*x(i)*(1-x(i));
end
[y,num]=sort(x);%将产生的混沌序列进行排序

Scambled=uint8(zeros(m,n));%产生一个与原图大小相同的0矩阵
for i=1:m*n
    Scambled(i)=Image(num(i));
end
figure(2);
Scambled=logical(Scambled);
imshow(Scambled);title('混沌置乱图像');



