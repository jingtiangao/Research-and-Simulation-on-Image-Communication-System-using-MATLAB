function IScamble=inhundun(Image)
[m,n]=size(Image);
%������������
x(1)=0.5;
for i=1:m*n-1
    x(i+1)=3.7*x(i)*(1-x(i));
end
[y,num]=sort(x);%�������Ļ������н�������
IScamble=uint8(zeros(m,n));%����һ����ԭͼ��С��ͬ��0����

for i=1:m*n

    IScamble(num(i))=Image(i);

end

figure(3);
IScamble=logical(IScamble);
subplot(2,2,1);imshow(Image);title('���ָ���ͼ��');
subplot(2,2,2); imshow(IScamble); title('���ҷ��任���ԭͼ');