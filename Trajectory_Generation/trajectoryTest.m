clear; close all;

P = [2 2 ; 20 20 ; 40 20];

    X(1,:) = [P(1,:) pi];
%     Robot path
    for i = 2 : length(P)
        thetaTraj = atan2(P(i,2)-P(i-1,2),P(i,1)-P(i-1,1));
        X(i,:) = [P(i,:) thetaTraj];
    end
    
T = linspace(0,length(X)-1,length(X));
tsim = [];
    for i = 1 : length(T)-1
        temp = linspace(T(i),T(i+1),20)';
        tsim = [tsim , temp];
    end    
[xstar, xdotstar, xddotstar, ystar, ydotstar, yddotstar, thetastar, tsim] = trajectory_Gen2(X, T, tsim, 1);


yOut = [];
tsim = tsim(:);
yOut = [xstar ystar thetastar];
    %Posizioni
    figure(2); 
    subplot(3,1,1); 
    plot(tsim,xstar,"r"); 
    hold on; title("X");
    subplot(3,1,2); 
    plot(tsim,ystar,"b"); 
    hold on; title("Y");
    subplot(3,1,3); 
    plot(tsim,thetastar,"g"); 
    hold on; 
    title("\theta");
    
%     Velocitá
    figure(3); 
    subplot(2,1,1); 
    plot(tsim,xdotstar,"r"); hold on; title("Xdot");
    subplot(2,1,2); 
    plot(tsim,ydotstar,"b"); hold on; title("Ydot");
    
    figure(4); 
    subplot(2,1,1); 
    plot(tsim,xddotstar,"r"); hold on; title("Xddot");
    subplot(2,1,2); 
    plot(tsim,yddotstar,"b"); hold on; title("Yddot");


%Plot dinamico
figure(1); axis([0 50 0 50]), hold on; plotRobot(yOut,1.5);

