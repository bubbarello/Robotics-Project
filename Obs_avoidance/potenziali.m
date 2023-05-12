function traj = potenziali(pstart,pgoal)

%% Generazione ambiente con gli ostacoli
[X,Y,grid,~] = mappa_Ostacoli();

%% Potenziale repulsivo

% Distanza minima rispetto ostacoli
d = bwdist(grid); 
%soglia di avvicinamento 
soglia = 2; 

%Potenziale repulsivo oltre la soglia tende ad inf, 0 in qualsiasi altro
%caso
frep = 1/2*((1./d - 1/soglia).^2); 
frep(d > soglia) = 0;


%% Potenziale attrattivo

%Potenziale attrattivo a forma di paraboloide, con punto di minimo in pgoal
fatt = 1/2*( (X - pgoal(1)).^2 + (Y - pgoal(2)).^2 );


%% Potenziale totale

% Converto i valori infiniti nel valore massimo della mappa
maxi = max(fatt(~isinf(fatt))); 
frep(isinf(frep)) = maxi;

%Sommo i due potenziali
ftot = fatt + frep;

%% Antigradiente e plotting

[gx1, gy1] = gradient(-frep); 

[gx2, gy2] = gradient(-fatt); 

gxtot = gx1+gx2; 
gytot = gy1+gy2;
figure(2); 
quiver(X(1,:), Y(:,1), gxtot, gytot,"b");
figure(3); 
mesh(ftot); 
hold on;

%% Generazione del percorso

% Ricerca iterativa del prossimo punto minimo

traj = pstart; 
distanza = norm(pstart-pgoal); 
i = 0; 
j = 1;
while (distanza > 0.2)
    i = i+1;
    x0 = traj(i,1); 
    y0 = traj(i,2);
%     Cerco il prossimo punto più piccolo
    spostamento = (abs(X - x0) < 0.52) & (abs(Y - y0) < 0.52);
    index = find(spostamento); 
%     Se ci sono più punti ne scelgo uno a caso
    if ~isempty(index)
            index = index(1);
    end
    fgrad = [gxtot(index) gytot(index)];
    if fgrad(1) >= 0 & fgrad(2) >= 0
        alpha = 0.01;
    elseif  fgrad(1) < 0 | fgrad(2) < 0
        alpha = 0.005; 
    end

%   Aggiorno iterazione
    x1 = x0 + alpha*fgrad(1); 
    y1 = y0 + alpha*fgrad(2); 
    distanza = norm([x1,y1]  - pgoal); 
    traj = [ traj ; x1 y1]; 
    
%     Per evitare deadlock
    j = j + 1;
    if j > 5000
        break;
    end
end

%% Ottimizzazione del percorso

for i = 2 : length(traj)
    traj(i,3) = atan2(traj(i,2)-traj(i-1,2),traj(i,1)-traj(i-1,1)); 
end

for i = length(traj) : -1 : 2
%     theta uguali
    if abs(traj(i,3)-traj(i-1,3)) < 0.1
        traj(i-1,:) = [];
    end
end

for i = length(traj) : -1 : 2
    %distanza molto piccola tra un punto e un altro
    if norm(traj(i,1:2)-traj(i-1,1:2)) < 0.1
        traj(i-1,:) = [];
    end
end
%% Plot della mappa finale

figure(2);
xstart = pstart(1); 
ystart = pstart(2); 
xgoal = pgoal(1); 
ygoal = pgoal(2);
plot(xstart,ystart,"ok","linewidth",2);
plot(xgoal,ygoal,"ok","linewidth",2);
end
