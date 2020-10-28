function [] = egalizare(nume)
%egalizare('EX1S.BMP');
% egalizare('EX3S.BMP');
% egalizare('LENNAS.BMP');
%egalizare('LENNASS.BMP');
%egalizare('MBS.jpg');

I=imread(nume);
[m,n,p]=size(I);
imt=zeros(m,n,p);
for i=1:p
    imt(:,:,i)=contrast_eg(I(:,:,i),m,n);
end

%sau apelul functiei MATLAB histeq
%imt=histeq(I);

figure
imshow(I);
title('Imaginea initiala');
figure
imshow(uint8(imt));
title('Imaginea cu histograma egalizata');
nume1=['ContrastEq' nume];
imwrite(uint8(imt),nume1);
end

function rez=contrast_eg(f,m,n)
p=zeros(1,256);
for i=1:m
    for j=1:n
        p(f(i,j)+1)=p(f(i,j)+1)+1;
    end
end
p=p/(m*n);
pn=p;
pn(1)=p(1);
for i=2:256
    pn(i)=pn(i-1)+p(i);
end
rez=zeros(m,n);
for i=1:m
    for j=1:n
        rez(i,j)=255*pn(f(i,j)+1);
    end
end
end
