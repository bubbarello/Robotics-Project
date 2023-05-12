function Xdot = posture_Reg_1(t,X,Xstar,k1,k2)

%% Error
x = X(1); 
y = X(2); 
theta = X(3);
xstar = Xstar(1); 
ystar = Xstar(2);
ex = xstar - x; 
ey = ystar - y;

%% Control signals
v = k1 * (ex*cos(theta) + ey*sin(theta));

if norm([ex ; ey]) <= 0.01
    w = 0;
else
    w = k2 * (angleSub(atan2(ey,ex),theta));
end

%% DD

r = 0.05; %raggio ruote 5 centimetri
L = 0.15; %distanza tra ruote 15 centimetri

K = [r/2 r/2 ; r/L -r/L];
wRwL = K \ [v ; w]; %inv(K) * [v ; w]
Xdot = [v*cos(theta) ; v*sin(theta) ; w];

end

