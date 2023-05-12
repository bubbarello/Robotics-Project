function traj = mappa_Voronoi(pstart,pgoal)

%% Generazione ostacoli
[X,Y,grid,obstacles] = mappa_Ostacoli();

xstart = pstart(1); 
ystart = pstart(2); 
xgoal = pgoal(1);
ygoal = pgoal(2);

%% Calcolo mappa di voronoi sui punti della meshgrid
x = X.*grid; 
y = Y.*grid; 
%Trasformazione in vettori colonna per voronoi
x = x(:);
y = y(:);
[vorx,vory] = voronoi(x,y);

%% Controllo mappa voronoi e cancellazione intersezioni

for i = length(vorx) : -1 : 1
    
    xlinea = vorx(:,i); 
    ylinea = vory(:,i);
    
    for j = 1 : size(obstacles,1)
        xost = [obstacles(j,1) obstacles(j,2)];
        yost = [obstacles(j,3) obstacles(j,4)];
  
        if check_Intersezione(xlinea,ylinea,xost,yost)
            vorx(:,i) = []; 
            vory(:,i) = [];
            break;
        end
    end
end

%% Inserimento vertice partenza e destinazione 


% Metto tutti i vertici in unico vettore v
v = [];
for i = 1 : length(vorx)
    v = [v ; [vorx(1,i) vory(1,i)] ; [vorx(2,i) vory(2,i)]];
end

%Cerco la distanza minima
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

vorx = [vorx  [xstart ; vstart(1)]  [xgoal ; vgoal(1)]];
vory= [vory   [ystart ; vstart(2)]  [ygoal ; vgoal(2)]];
v = [v ; [xstart ystart] ; [vstart(1) vstart(2)] ; [xgoal ygoal] ; [vgoal(1) vgoal(2)]];


%% Plot della mappa finale

figure(2);
plot(vorx,vory,"g","linewidth",2); 
hold on;
xstart = pstart(1); 
ystart = pstart(2); 
xgoal = pgoal(1); 
ygoal = pgoal(2);
plot(xstart,ystart,"ok","linewidth",2);
plot(xgoal,ygoal,"ok","linewidth",2);

%% Creazione grafo tramite matrice di adiacenza


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
figure(2); 
plot(G,"xdata",v(:,1),"ydata",v(:,2));

path = shortestpath(G,length(v)-3,length(v)-1);
traj = v(path,:);

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

end