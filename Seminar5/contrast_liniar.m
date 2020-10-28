function [] = contrast_liniar( nume,r,s)
% doua puncte de taietura
%contrast_liniar('LENNAA.BMP',[0 84 170 255], [0 40 210 255]);
%contrast_liniar('MB.jpg',[0 84 170 255], [0 40 210 255]);
%contrast_liniar('LENNA.BMP',[0 64 170 255], [0 40 190 255]);
 % contrast_liniar('ex1s.BMP',[0 84 170 255], [0 30 220 255]);
% patru puncte de taietura
%contrast_liniar('LENNAA.BMP',[0 42 85 127 169 212 255], [0 30 65 127 189 232 255]);
%contrast_liniar('MB.jpg',[0 42 85 127 169 212 255], [0 30 65 127 189 232 255]);
%contrast_liniar('LENNA.BMP',[0 42 85 127 169 212 255], [0 30 65 127 189 232 255]);
%contrast_liniar('badscans.BMP',[0 42 85 127 169 212 255], [0 30 65 127 189 232 255]);
I=imread(nume);
f=double(I);
[m,n,p]=size(I);
g=zeros(m,n,p);
nr=length(r);
for i=1:p
    g(:,:,i)=contrastl(f(:,:,i),r,s,m,n,nr);
end
figure
imshow(I);
title('Imaginea initiala');
figure
imshow(uint8(g));
title(['Imaginea modificata liniar prin ' num2str(nr-2) ' puncte']);
nume1=['ContrastL' nume];
imwrite(uint8(g),nume1);
end

function [g]=contrastl(f,r,s,m,n,nr)
g=f;
for l=1:m
    for c=1:n
        for i=1:nr-1
            if(r(i)<=f(l,c) && f(l,c)<r(i+1))
                g(l,c)=f(l,c)*((s(i+1)-s(i))/(r(i+1)-r(i)))+(r(i+1)*s(i)-s(i+1)*r(i))/(r(i+1)-r(i));
            end
        end
    end
end
end

