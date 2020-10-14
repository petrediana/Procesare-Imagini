function [] = diagonalizare(poza, procent)
  % Diagonalizarea unei imagini, cu compresie 
  % I: poza - numele fisierului cu imaginea de prelucrat
  %    procent - procent (% valori proprii semnificative luate in considerare)
  % E: -
    
  % Exemple de apel: (folositi procente: 50, 45, 40, ... 10, 5)
  % diagonalizare('EX1.BMP',40);
  % diagonalizare('LENNAA.BMP',30);
  % diagonalizare('BADSCAN1.BMP',50);
  % diagonalizare('2.tif',50);
  % diagonalizare('vulpea si marmota.png',35);
  % diagonalizare('vulpea si marmota-gs.png',10);
  % diagonalizare('luna_gs.jpg',25);

  I=imread(poza);
  [m,n,p]=size(I);
  I_diag=zeros(m,n,p);
  if(p==1)
    I_diag=d_plan(I,procent);
  else
    for k=1:p
        I_diag(:,:,k)=d_plan(I(:,:,k),procent);
    end;
  end;
      
  figure
    imshow(I);
    title('Imaginea initiala');
  figure
    imshow(uint8(I_diag));
    title(['Imaginea in reprezentarea diagonalizata cu "compresie" de ' num2str(100-procent) '%']);
  % salvare fisier cu imaginea reconstruita    
  fo=[poza '-' num2str(procent) '.png'];
  imwrite(uint8(I_diag),fo,'png');
  
  % doar cu scop didactic:  
  % studiu empiric al diferentei intre imaginea initiala si cea reconstr.
  if p==1
    dif=I-uint8(I_diag);
    figure
      imshow(dif);
      title('Diferente');
    figure
      imshow(255-dif);
      title('Negativ diferente');
    c=length(find(dif));
    mx=max(max(dif));
    disp(['Total puncte in imagine: ' int2str(m*n)]);
    disp(['Total puncte diferite: ' int2str(c)]);
    disp(['Diferenta maxima: ' int2str(mx)]);
    dd=zeros(1,mx);
    for i=1:mx
        dd(i)=length(find(dif==i));
    end;
    disp(['Puncte cu diferenta 1 - > ' int2str(mx) ':']);
    tz=[uint16(1:mx);dd];
    disp(tz);  
  end;
  % final scop didactic
end

function [I_diag]=d_plan(I,procent)
  % diagonalizarea unui plan al imaginii
      
  f=double(I);
  A=f*(f');
  [m,~]=size(A);
  % matrice valori proprii sigma1, matrice vectori proprii ortogonali U1
  % A e simetrica => valori proprii pozitive, pe diagonala sigma1
  [U1,sigma1]=eig(A);
  % inversare ordine valori proprii si vectori proprii (eig: min->max)
  sigma=sigma1;
  for j=1:m
     sigma(j,j)=sigma1(m-j+1,m-j+1);
  end;
  % VARIANTA (mai lenta): sigma(1:m,1:m)=sigma1(m:-1:1,m:-1,1)
  U(:,1:m)=U1(:,m:-1:1);
    
  % determinare numar valori proprii strict pozitive (pozitive)
  pozitive=length(find(sigma)); 

  % determinare numar de valori proprii pastrate (k)
  k=fix(pozitive * procent/100);
  % pastrarea a k valori si vectori proprii
  S=U';
  lambdar=sigma(1:k,1:k);
  S1=S(1:k,:);
  
  % calcul reprezentare diagonalizata (codificare)
  g=lambdar^-0.5*S1*f;
   
  % matricea g NU este o imagine! afisare doar cu scop didactic
  figure
    imshow(uint8(g));
    title('Matricea g. Se intelege ceva? NU este o imagine!');
    
  % calcul imagine reconstruita (decodificare)
  I_diag=S1'*(lambdar^0.5)*g;
end

