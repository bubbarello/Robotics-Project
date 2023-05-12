function traj = grafi_Visibilita(pstart,pgoal)

%% Costruzione ambiente con gli ostacoli
[~,~,~,obstacles] = mappa_Ostacoli();
xstart = pstart(1); 
ystart = pstart(2); 
xgoal = pgoal(1);
ygoal = pgoal(2);


%% Collegamenti tra vertici visibili

for i = 5 : size(obstacles,1)
    v(1,:,i-4) = [obstacles(i,1) obstacles(i,3)];
    v(2,:,i-4) = [obstacles(i,1) obstacles(i,4)];
    v(3,:,i-4) = [obstacles(i,2) obstacles(i,3)];
    v(4,:,i-4) = [obstacles(i,2) obstacles(i,4)];
end

% Connetto quindi tutti i vertici tra di loro
lineax = []; lineay = [];
for i = 1 : size(v,3)
    for j = 1 : 4
        for l = i : size(v,3)
            for k = 1 : 4
                temp = [v(j,1,i) v(k,1,l)];
                lineax = [lineax ; [temp(1) temp(2)]];
                temp = [v(j,2,i) v(k,2,l)];
                lineay = [lineay ; [temp(1) temp(2)]];
            end
        end
    end
end

% Controllo intersezioni
for i = length(lineax) : -1 : 1
    for j = 1 : size(obstacles,1)
        c = check_Intersezione(lineax(i,:),lineay(i,:),obstacles(j,1:2),obstacles(j,3:4));
        if c | ~(lineax(i,:) < 50) | ~(lineay(i,:) < 50) | ~(lineax(i,:) > 0)
            lineax(i,:) = []; 
            lineay(i,:) = []; 
            break;
        end
    end
end


% Plot finale dei collegamenti
v = [];
for i = 1 : length(lineax)
    plot(lineax(i,:),lineay(i,:),"g","linewidth",2);
    v = [v ; lineax(i,1) lineay(i,1) ; lineax(i,2) lineay(i,2)];
end

% Aggiunta dei punti di start e goal alla mappa dei collegamenti
vnormstart = v-[xstart ystart];
vnormgoal = v-[xgoal ygoal];
for i = 1 : size(v,1)
    vnormstart(i,:) = norm(vnormstart(i,:));
    vnormgoal(i,:) = norm(vnormgoal(i,:));
end
[~,istart] = min(vnormstart);
[~,igoal] = min(vnormgoal);
vstart = v(istart(1),:); 
vgoal = v(igoal(1),:);
v = [v ; [xstart ystart] ; [vstart(1) vstart(2)] ; [xgoal ygoal] ; [vgoal(1) vgoal(2)]];

%% Creazione grafo di visibilita'

% Sfrutto qui la stessa identica tecnica come in voronoimap
A = zeros(length(v));
vtemp = v;
for i = length(vtemp) : -1 : 1
    temp = (vtemp-vtemp(i,:));
    coin = trova_Righe_Nulle(temp);
    for j = 1 : length(coin)
        index = coin(j);
        if mod(index,2) == 0
            A(i,index-1) = 1;
        elseif index < length(vtemp)
            A(i,index+1) = 1;
        end
    end
    A(i,i) = 0;
    vtemp(i,:) = [];
end

G = graph(A,"lower");
figure(2); plot(G,"xdata",v(:,1),"ydata",v(:,2));

path = shortestpath(G,length(v)-3,length(v)-1);
traj = v(path,:);

for i = 2 : length(traj)
    traj(i,3) = atan2(traj(i,2)-traj(i-1,2),traj(i,1)-traj(i-1,1)); 
end

%% Ottimizzazione percorso
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
