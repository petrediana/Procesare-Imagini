function [ ok ] = ascunde_mesaj( poza_initiala, mesaj, poza_originala, poza_modificata, tip_fisier )

    imagine = imread(poza_initiala);
    [~,~,plane] = size(imagine);
    sir = mesaj - 'a' + 1;
    ok = 1;
    
    if plane == 1
        [imagine_modificata, ok] = gigel(imagine, sir);
    elseif plane == 3
        nr = length(sir);
        puncte = [0, sort(unidrnd(nr, 1, 2)), nr];
        imagine_modificata = imagine;
        
        i = 1;
        while (i <= 3) && (ok == 1)
            [imagine_modificata(:, :, i), ok] = gigel(imagine(:, :, i), sir(puncte(i) + 1 : puncte(i+1)));
            i = i + 1;
        end;
    else
        ok = 2;
    end;
    
    if ok == 1
        fisier_original = [poza_originala '.' tip_fisier];
        fisier_modificat = [poza_modificata '.' tip_fisier];
        
        imwrite(imagine, fisier_original, tip_fisier);
        imwrite(imagine_modificata, fisier_modificat, tip_fisier);
    end;
    
end

function [poza_modificata, ok] = gigel (poza, mesaj)
    poza_modificata = poza;
    vmax = 255-max(mesaj);
    nr = length(mesaj);
    
    pixeli_alesi = pozitii(poza, nr, vmax);
    [gasit, ~] = size(pixeli_alesi);
    
    if gasit ~= nr
        ok = 0;
    else
        ok = 1;
        for i = 1 : nr
            poza_modificata(pixeli_alesi(i, 1), pixeli_alesi(i, 2)) = poza_modificata(pixeli_alesi(i, 1), pixeli_alesi(i, 2)) + mesaj(i);
        end;
    end;
end

function [poz] = pozitii(poza,nr,vmax)
    [temp] = find(poza <= vmax);
    nrdisp = length(temp);
    
    if nrdisp < nr    
        poz = [];     
    else
        indici = zeros(1, nr);
        [lin, col] = ind2sub(size(poza), temp);
        poz = zeros(nr, 2);
        p = 0;
        
        while p < nr
            i = unidrnd(nrdisp);      
            
            if ~ismember(i, indici)  
                p = p + 1;          
                indici(p) = i;
                poz(p, 1) = lin(i);
                poz(p, 2) = col(i);
            end;
        end;
        poz = sortrows(poz);
    end;
end

