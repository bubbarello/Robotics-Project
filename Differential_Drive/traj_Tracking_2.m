function Xdot = traj_Tracking_2(tsim,X,xstar,xdotstar,xddotstar,ystar,ydotstar,yddotstar,thetastar,k1,k2,k3,tv)

%% Estrazione dati dalla traiettoria da inseguire
for i = 1 : length(tv)-1
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
etheta = angleSub(thetastar,theta) + 0.00001;

%% Control signals

vstar = sqrt(xdotstar^2 + ydotstar^2);
wstar = (yddotstar*xdotstar - ydotstar*xddotstar) / (xdotstar^2 + ydotstar^2);

v = double(vstar*cos(etheta) + k1(vstar,wstar)*ex);
w = double(wstar + k2*vstar*sin(etheta)*ey/etheta + k3(vstar,wstar)*etheta);

%% DD

r = 0.05; %raggio ruote 5 centimetri
L = 0.15; %distanza tra ruote 15 centimetri

K = [r/2 r/2 ; r/L -r/L];
wRwL = K \ [v ; w];

Xdot = [v*cos(theta) ; v*sin(theta) ; w];
end

