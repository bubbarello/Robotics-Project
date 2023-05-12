close all;
clear;
clc;

P_start = [5 5];
P_goal = [35 25];

scelta = input('1: grafi di visibilita, 2: potenziali, 3: potenziali discreti, 4: mappe voronoi \n' );

switch scelta

    case 1
        P = grafi_Visibilita(P_start,P_goal);
    case 2
        P = potenziali(P_start,P_goal);
    case 3
        P = potenziali_Discreti(P_start,P_goal);
    case 4        
        P = mappa_Voronoi(P_start,P_goal);
    otherwise
        disp('Input non valido')
end

%% Trajectory generation

T = linspace(0,length(P)-1,length(P));
tsim = []; 
ttotal = [];
for i = 1 : length(T)-1
    temp = linspace(T(i),T(i+1),20)';
    tsim = [tsim , temp];
    ttotal = [ttotal ; temp];
end

scelta = input('1: Percorso arrotondato, 2: Percorso punto punto \n' );

switch scelta()
    case 1
        [xstar,xdotstar,xddotstar,ystar,ydotstar,yddotstar,thetastar,tsim] = trajectory_Gen2(P, T, tsim, 1);
    case 2
        [xstar,xdotstar,xddotstar,ystar,ydotstar,yddotstar,thetastar,tsim] = trajectory_Gen2(P, T, tsim, 2);
end   
%Traiettoria di partenza + errore
err = 0;
x = xstar(1,1) + err; 
y = ystar(1,1) + err; 
theta = P(1,3) + deg2rad(err); 
X = double([x  y  theta]);
tsim = tsim(:);

scelta = input('1: Controllo linearizzato, 2: Controllo non lineare, 3: Feedback Linearization \n' );

switch scelta
     case 1
%       Controllo linearizzato
        a = 10; 
        delta = 1;
        controlFunction = @(t,X) ...
            (traj_Tracking_1(t,X,xstar,xdotstar,xddotstar,ystar,ydotstar,yddotstar,thetastar,delta,a,tsim));
     case 2   
%       Controllo nonlineare
        k1 = @(vstar,wstar) (1); 
        k2 = 1;
        k3 = @(vstar,wstar) (1); 
        controlFunction = @(t,X) ...
            traj_Tracking_2(t,X,xstar,xdotstar,xddotstar,ystar,ydotstar,yddotstar,thetastar,k1,k2,k3,tsim);
     case 3
%       Feedback Linearization 
        k1 = 1; 
        k2 = 1; 
        b = 0.1;
        controlFunction = @(t,X) ...
            traj_Tracking_3(t,X,xstar,xdotstar,xddotstar,ystar,ydotstar,yddotstar,thetastar,b,k1,k2,tsim);
     otherwise
         disp('Input non valido');
 end
 
[tOut,yOut] = ode45(controlFunction, [tsim(1) tsim(end)], X);

%% Posture Regulation finale
X = yOut(length(yOut),:); 
Xstar = [P_goal,0];

scelta = input('1: Posture Regulation 1, 2: Posture Regulation 2 \n');

switch scelta
    case 1
        k1 = 1;
        k2 = 2;
        controlFunction = @(t,X) posture_Reg_1(t,X,Xstar(1:2),k1,k2);
    case 2
        k1 = 1; 
        k2 = 1; 
        k3 = 1;
        controlFunction = @(t,X) (posture_Reg_2(t,X,Xstar,k1,k2,k3));
     otherwise
         disp('Input non valido');
end
% 
[tOut,yOuttemp] = ode45(controlFunction, [0 5], X);
yOut = [yOut ; yOuttemp];

%% Plotting

figure(2); 
axis([0 50 0 50]) 
hold on; 
plotRobot(yOut,1.5, 0.05);
plot(xstar, ystar, "ob");

