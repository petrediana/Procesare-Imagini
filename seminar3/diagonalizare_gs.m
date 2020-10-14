function [] = diagonalizare_gs(poza,procent)
  % Demonstratie diagonalizarea unei imagini in nuante de gri, cu compresie
  % Se respinge prelucrarea imaginilor RGB
  % I: poza - numele fisierului cu imaginea de prelucrat
  %    procent - procent (% valori proprii semnificative luate in considerare)
  % E: -
    
  % Exemple de apel: (folositi procente: 50, 45, 40, ... 10, 5)
  % diagonalizare_gs('EX1.BMP',40);
  % diagonalizare_gs('LENNAA.BMP',30);
  % diagonalizare_gs('BADSCAN1.BMP',50);
  % diagonalizare_gs('2.tif',50);

  % diagonalizare imagine
  I=imread(poza);
  [m,n,p1]=size(I);
  %disp(m);disp(n);
  if(p1>1)
    disp('Imaginea nu este gray-scale (mai mult de 1 plan)');
  else
    figure
      imshow(I);
      title('Imaginea initiala');
      
    f=double(I);
    A=f*(f');
    % matrice valori proprii sigma1, matrice vectori proprii ortogonali U1
    % A e simetrica => valori proprii pozitive, pe diagonala sigma1
    [U1,sigma1]=eig(A);
    % inversare ordine valori proprii si vectori proprii (eig: min->max)
    sigma=sigma1;
    for j=1:m
       sigma(j,j)=sigma1(m-j+1,m-j+1);
    end;
    % VARIANTA: sigma(1:m,1:m)=sigma1(m:-1:1,m:-1,1)
    U(:,1:m)=U1(:,m:-1:1);
    
    % determinare numar valori proprii strict pozitive (i)
    % VARIANTA: i=length(find(sigma)) 
    i=0;
    j=1;
    while (j<=m) && (sigma(j,j)>0) 
        i=i+1;
        j=j+1;
    end;
    % determinare numar de valori proprii pastrate (k)
    k=fix(i* procent/100);
    % pastrarea a k valori si vectori proprii
    S=U';
    lambdar=sigma(1:k,1:k);
    S1=S(1:k,:);
    % calcul reprezentare diagonalizata
    g=lambdar^-0.5*S1*f;
      
    figure
        imshow(uint8(g));
        title('Matricea g. Se intelege ceva? NU este o imagine!');
    
    % salvare si vizualizare imagine reconstruita
    I_diag=S1'*(lambdar^0.5)*g;
    fo=[poza '-' num2str(procent) '.png'];
    imwrite(uint8(I_diag),fo,'png');
            
    figure
      imshow(uint8(I_diag));
      title(['Figura in reprezentarea diagonalizata cu compresie de ' num2str(100-procent) '%']);
      
    % studiu empiric al diferentei intre imaginea initiala si cea comprimata
    % ar trebui calculat indicatorul SNR pentru caracterizarea diferentei
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
    disp(['diferenta maxima: ' int2str(mx)]);
    dd=zeros(1,mx);
    for i=1:mx
        dd(i)=length(find(dif==i));
    end;
    disp(['Puncte cu diferenta 1 - > ' int2str(mx) ':']);
    tz=[uint16(1:mx);dd];
    disp(tz);
    %final studiu empiric  
  end;
end

