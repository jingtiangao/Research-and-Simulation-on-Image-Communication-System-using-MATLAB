function Scambled=hundun(Image)

imshow(Image);
[m,n]=size(Image);

%������������
x(1)=0.5;
for i=1:m*n-1
    x(i+1)=3.7*x(i)*(1-x(i));
end
[y,num]=sort(x);%�������Ļ������н�������

Scambled=uint8(zeros(m,n));%����һ����ԭͼ��С��ͬ��0����
for i=1:m*n
    Scambled(i)=Image(num(i));
end
figure(2);
Scambled=logical(Scambled);
imshow(Scambled);title('��������ͼ��');



