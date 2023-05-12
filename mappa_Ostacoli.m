function [X,Y,grid,obstacles] = mappa_Ostacoli()
%% Griglia
nr = 50; 
nc = 50;
grid = zeros(nr,nc);
[X,Y] = meshgrid(linspace(0,50,nc),linspace(0,50,nr));

%% Obstacles

%Bordi mappa
grid(1:2,1:50) = 1;         
obstacles(1,:) = [X(1,1) X(1,50) Y(1) Y(2)];
grid(49:50,1:50) = 1;    
obstacles(2,:) = [X(1,1) X(1,50) Y(49) Y(50)];
grid(1:50,1:2) = 1;         
obstacles(3,:) = [X(1,1) X(1,2) Y(1) Y(50)];
grid(1:50,49:50) = 1;    
obstacles(4,:) = [X(1,49) X(1,50) Y(1) Y(50)];

%Ostacoli
grid(8:20,30:45) = 1;      
obstacles(5,:) = [X(1,30) X(1,45) Y(8) Y(20)];
grid(30:40,25:30) = 1;      
obstacles(6,:) = [X(1,25) X(1,30) Y(30) Y(40)];
grid(25:26,10:30) = 1;      
obstacles(7,:) = [X(1,10) X(1,30) Y(25) Y(26)];
grid(30:45,40:45) = 1;      
obstacles(8,:) = [X(1,40) X(1,45) Y(30) Y(45)];
grid(10:20,10:20) = 1;      
obstacles(9,:) = [X(1,10) X(1,20) Y(10) Y(20)];
grid(35:45,10:20) = 1;      
obstacles(10,:) = [X(1,10) X(1,20) Y(35) Y(45)];


%% Plot
Z = 1.*grid; 
figure(1)
axis("equal");
axis([0 50 0 50]); 
hold on; 
mesh(X,Y,Z);

figure(2)
axis("equal");
axis([0 50 0 50]);
hold on; 
for i = 1 : 10
    temp = obstacles(i,:);
    rectangle("position",[temp(1) temp(3) temp(2)-temp(1) temp(4)-temp(3)],'facecolor','y');
end
