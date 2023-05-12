function Xdot = traj_Tracking_1(tsim,X,xstar,xdotstar,xddotstar,ystar,ydotstar,yddotstar,thetastar,delta,a,tv)

%% Estrazione dati dalla traiettoria da inseguire
for i = 1 : length(tv) - 1
    if tsim >= tv(i) && tsim < tv(i+1)
        break
    end
end

%Devo prendere le star attuali per poter inseguire la traiettoria attuale e potere
%aggiornare in tempo reale il segnale di comando
x = X(1);
y = X(2);
theta = X(3);

xstar = xstar(i); 
ystar = ystar(i); 
thetastar = thetastar(i);
xdotstar = xdotstar(i) + 0.00001; 
ydotstar = ydotstar(i) + 0.00001;
xddotstar = xddotstar(i); 
yddotstar = yddotstar(i);


%% Errore

ex = cos(theta)*(xstar-x) + sin(theta)*(ystar-y);
ey = -sin(theta)*(xstar-x) + cos(theta)*(ystar-y);
etheta = angleSub(thetastar,theta);

%% Control signals

vstar = sqrt(xdotstar^2 + ydotstar^2);
wstar = (yddotstar*xdotstar - ydotstar*xddotstar) / (xdotstar^2 + ydotstar^2);

k1 = 2*delta*a;
k3 = k1;
k2 = (a^2 - (wstar)^2) / (vstar);

v = double(vstar*cos(etheta) + k1*ex);
w = double(wstar + k2*ey + k3*etheta);

%% DD

r = 0.05; %raggio ruote 5 centimetri
L = 0.15; %distanza tra ruote 15 centimetri

K = [r/2 r/2 ; r/L -r/L];
wRwL = K \ [v ; w];

Xdot = [v*cos(theta) ; v*sin(theta) ; w];
end
