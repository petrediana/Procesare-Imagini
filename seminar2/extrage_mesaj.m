function [ mesaj ] = extrage_mesaj( poza_originala, poza_modificata )
    
    poza_originala = imread(poza_originala);
    imagine_modificata = imread(poza_modificata);
    
    mesaj = '';
    [m, n, p] = size(poza_originala);
    
    dif = imagine_modificata - poza_originala;
    for k = 1 : p
        for i = 1 : m
            for j = 1 : n
                if dif(i, j, k)
                    mesaj = [mesaj dif(i, j, k) + 'a' - 1];
                end;
            end;
        end;
    end;
end

