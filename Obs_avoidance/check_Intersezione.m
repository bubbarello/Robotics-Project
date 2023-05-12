% Funzione che calcola se esiste un'interesezione tra un segmento la cui x varia da
% xline(1) a xline(2), come anche la y, e un ostacolo di forma rettangolare

function [intersezione] = check_Intersezione(xline,yline,xobst,yobst)

xobsti = xobst(1); 
yobsti = yobst(1); 
xobstf = xobst(2);
yobstf = yobst(2);

xline = linspace(xline(1),xline(2),50)';
yline = linspace(yline(1),yline(2),50)';

if length(xline) == 1
    xline = ones(length(yline),1)*xline;
elseif length(yline) == 1
    yline = ones(length(xline),1)*yline;
end

punti = xline > xobsti & xline < xobstf & yline > yobsti & yline < yobstf;
if(~isempty(find(punti,1)))
    intersezione = true;
else
    intersezione = false;
end

end
