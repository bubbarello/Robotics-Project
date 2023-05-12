function Xdot = posture_Reg_2(t,X,Xstar,k1,k2,k3)

%% Error
x = X(1); 
y = X(2); 
theta = X(3);
xstar = Xstar(1); 
ystar = Xstar(2); 
thetastar = Xstar(3);
ex = xstar - x; 
ey = ystar - y; 
etheta = angleSub(thetastar,theta);

%% Control signals
rho = sqrt(ex^2 + ey^2);
gamma = angleSub(atan2(ey,ex),theta);
delta = angleSub(gamma,etheta);

v = k1*rho*cos(gamma);
w = k2*gamma + (k1*sin(gamma)*cos(gamma)*angleAdd(gamma,k3*delta))/gamma;

%% DD

r = 0.05; %raggio ruote 5 centimetri
L = 0.15; %distanza tra ruote 15 centimetri

K = [r/2 r/2 ; r/L -r/L];
wRwL = K \ [v ; w]; %inv(K) * [v ; w]
Xdot = [v*cos(theta) ; v*sin(theta) ; w];

end
