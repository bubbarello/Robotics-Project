function Xdot = traj_Tracking_3(tsim,X,xstar,xdotstar,~,ystar,ydotstar,~,~,b,k1,k2,tv)

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
xdotstar = xdotstar(i) + 0.00001; 
ydotstar = ydotstar(i) + 0.00001;

xb = x + b*cos(theta);
yb = y + b*sin(theta);

%% Control signals

Tinv = [cos(theta) sin(theta) ; -sin(theta)/b cos(theta)/b];

u1 = xdotstar + k1*(xstar - xb); 
u2 = ydotstar + k2*(ystar - yb);
vw = Tinv*[u1;u2];

v = double(vw(1));
w = double(vw(2));

%% DD

r = 0.05; %raggio ruote 5 centimetri
L = 0.15; %distanza tra ruote 15 centimetri

K = [r/2 r/2 ; r/L -r/L];
wRwL = K \ [v ; w];

Xdot = [v*cos(theta) ; v*sin(theta) ; w];

end
