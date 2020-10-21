function [ vp, R, medie, er, rez ] = KL( nrp, baza_nume, tip, nrc )
    
    k = 0;
    rez = 0;
    
    while k < nrp && ~rez
        k = k + 1;
        
        fi = [baza_nume num2str(k) '.' tip];
        poza = imread(fi);
        [m, n, p] = size(poza);
        
        if p > 1
            rez = 2;
        else
            if ~exist('imagini', 'var');
                imagini = uint8(zeros(m, n, nrp));
                m1 = m;
                n1 = n;
            end;
            
            if m1 ~= m || n1 ~= n
                rez = 1;
            else
                imagini(:, :, k) = poza;
                %figure
                    %imshow(imagini(:, :, k));
                    %title(['Imaginea initiala ' num2str(k)]);
            end;
        end;
    end;
    
    if rez
        disp(['Imaginea ' num2str(k) 'nu corespunde: ']);
        
        if rez == 1 
            disp('Are dimensiuni diferite');
        else
            disp('Are mai mult de un plan');
        end;
    else
        p = m *n;
        im_lin = zeros(p, nrp);
        
        for k = 1 : nrp
            im_lin(:, k) = reshape(imagini(:, :, k)', [1 m * n]);
        end;
        
        medie = mean(im_lin, 2);
        
        for k = 1 : nrp
            im_lin(:, k) = im_lin(:, k) - medie;
        end;
        
        ss = cov(im_lin');
        [V, L] = eig(ss);
        
        vp = V(:, p : -1, p - nrc + 1);
        valp = diag(L);
        
        er = sum(valp(1 : p - nrc));
        
        R = zeros(nrc, nrp);
        for k = 1 : nrp
            R(:, k) = vp' * im_lin(:, k);
        end;
        
        disp(['Spatiu initial: ' int2str(m * n *nrp)]);
        disp(['Spatiu redus  : ' int2str(nrc * nrp + m * n + nrc * m * n)]);
        disp(['Eroarea       : ' num2str(er)]);
        
        im_lin_noi = zeros(p, nrp);
        for k = 1 : nrp
            im_lin_noi(:, k) = vp * R(:, k);
        end;
        
        im_noi=uint8(zeros(m,n,nrp));
        for k = 1 : nrp
            matrice = reshape(im_lin_noi(:, k) + medie, [m n] );
            im_noi(:, :, k) = uint8(matrice');
            
            figure
                imshow( im_noi(:, :, k) );
                title(['Imaginea ' num2str(k) ' reconstruita']);
			fo = [baza_nume num2str(k) '_r.' tip];
            imwrite(im_noi(:, :, k), fo, tip);
        end;
        
    end;
end

