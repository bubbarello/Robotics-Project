function traj = potenziali_Discreti(pstart,pgoal)

%% Generazione ostacoli
[X,Y,grid,~] = mappa_Ostacoli();

%% Inizializzazione

mappa_Discretizzata = zeros(50,50);
igoalx = pgoal(1);
igoaly = pgoal(2);
istartx = pstart(1);
istarty = pstart(2);
maxi = length(mappa_Discretizzata); 


%% Riempimento griglia

for i = 1 : length(mappa_Discretizzata)-1
    
    %colonna destra
    l = igoalx + i;
    for k = igoaly - i : igoaly + (i-1)
        if k < 1 || l < 1 || k > length(mappa_Discretizzata) || l > length(mappa_Discretizzata)
        else
            if grid(k,l) == 1
                mappa_Discretizzata(k,l) = maxi;
            else
                mappa_Discretizzata(k,l) = i;
            end
        end
    end
    %colonna sinistra
    l = igoalx - i;
    for k = igoaly + i : -1 : igoaly - (i-1)
        if k < 1 || l < 1 || k > length(mappa_Discretizzata) || l > length(mappa_Discretizzata)
        else
            if grid(k,l) == 1
                mappa_Discretizzata(k,l) = maxi;
            else
                mappa_Discretizzata(k,l) = i;
            end
        end
    end
    %riga sopra
    k = igoaly - i;
    for l = igoalx - i : igoalx + (i-1)
        if k < 1 || l < 1 || k > length(mappa_Discretizzata) || l > length(mappa_Discretizzata)
        else
            if grid(k,l) == 1
                mappa_Discretizzata(k,l) = maxi;
            else
                mappa_Discretizzata(k,l) = i;
            end
        end
    end
    %riga sotto
    k = igoaly + i;
    for l = igoalx + i : -1 : igoalx - (i-1)
        if k < 1 || l < 1 || k > length(mappa_Discretizzata) || l > length(mappa_Discretizzata)
        else
            if grid(k,l) == 1
                mappa_Discretizzata(k,l) = maxi;
            else
                mappa_Discretizzata(k,l) = i;
            end
        end
    end
    
end

Z = mappa_Discretizzata.*(grid+1);
figure(3); 
mesh(X,Y,Z);
%% Traiettoria

mappa_Percorsa = mappa_Discretizzata;
Arrivato = false; 
i = istartx; 
j = istarty;
traj = [X(1,j) Y(i,1)];

while ~Arrivato
    
    %Estraggo gli elementi intorno e cerco il minimo
    current = mappa_Percorsa(i,j);
    temp = mappa_Percorsa(i-1:i+1,j-1:j+1);
    [~,index] = trova_Indici_Minimo(temp);
    mappa_Percorsa(i,j) = maxi;
    
    i = i + (index(1)-2); 
    j = j + (index(2)-2);
       
    if current == 0
        Arrivato = 1;
    end
    
    %Aggiorno la traiettoria
    traj = [traj ; X(1,j) Y(i,1)];
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