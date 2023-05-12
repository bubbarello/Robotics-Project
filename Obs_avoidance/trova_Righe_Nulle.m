function indice = trova_Righe_Nulle(v)

indice = [];

for i = 1 : size(v,1)
    if abs(v(i,1))==0 & abs(v(i,2))==0
        indice = [indice; i];
    end
end
