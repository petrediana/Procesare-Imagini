function [] = Gamma(nume,c,gamma)
%Gamma('BADSCANS.BMP',1,1.15);
%Gamma('2.tif',0.3,1.25);
%%color
%Gamma('LENNA.BMP',0.5,1.15);
% Gamma('MB.jpg',0.4,1.2);
%Gamma('MBS.jpg',0.5,1.2);


X=imread(nume);
[m,n,p]=size(X);
rez=zeros(m,n,p);
for k=1:p
    rez(:,:,k)=prel_g(double(X(:,:,k)),c,gamma);
end
figure
imshow(X);
title('Imaginea initiala');
figure
imshow(uint8(rez));
title(['Imaginea rezultata pentru c=' num2str(c) ' si gamma=' num2str(gamma)]);
nume1=['IMGamma' nume];
imwrite(uint8(rez),nume1);
end

function [rez]=prel_g(X,c,gamma)
%operatia de ridicare la putere este realizata element cu element
rez=c*X.^gamma;
end


