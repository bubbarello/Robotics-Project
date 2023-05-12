function [xs, xdots, xddots, ys, ydots, yddots, thetas, tsim] = trajectory_Gen(P, T, tsim, metodo)

    X = P;
    xs = [];
    xdots = [];
    xddots = [];
    ys = [];
    ydots = [];
    yddots = [];
    thetas = [];
    if metodo == 1
        
        t_blend = 2;
        bt = 0.09;
        xdotcost = zeros(size(X,1)*4,1);
        ydotcost = zeros(size(X,1)*4,1);
        for i = 1: length(P)
            syms t a0 a1 a2 a3 b0 b1 b2 b3 lambdax lambday;            
            if i < length(P)
                delta_t = T(i+1) - T(i);
                xdotcost(t_blend + 1) = (X(i+1,1) - X(i,1))/delta_t + 0.00001;
                ydotcost(t_blend + 1) = (X(i+1,2) - X(i,2))/delta_t + 0.00001;
            else
                T = [T, T(i) + 1];
                tsim = [tsim, linspace(T(i),T(i+1),20)'];
            end
            tb1 = tsim(1,i) - bt;
            if t_blend <= 10
                tb2 = tsim(t_blend, i);  
            else
                t_blend = 2;
                tb2 = tsim(t_blend, i); 
            end
            lambdax = a0*t^3 + a1*t^2 + a2*t + a3;
            lambday = b0*t^3 + b1*t^2 + b2*t + b3;
            lambdaxdot = diff(lambdax);
            lambdaydot = diff(lambday);
            cx(1) = subs(lambdax,t,0.1) == X(i,1) + xdotcost(t_blend - 1) * (tb1 - T(i));
            cx(2) = subs(lambdax,t,0.9) == X(i,1) + xdotcost(t_blend + 1) * (tb2 - T(i)) + bt * xdotcost(t_blend + 1);
            
            cx(4) = subs(lambdaxdot,t,0.1) == xdotcost(t_blend - 1);
            cx(5) = subs(lambdaxdot,t,0.9) == xdotcost(t_blend + 1);
                 
            cy(1) = subs(lambday,t,0.1) == X(i,2) + ydotcost(t_blend - 1) * (tb1 - T(i));
            cy(2) = subs(lambday,t,0.9) == X(i,2) + ydotcost(t_blend + 1) * (tb2 - T(i)) + bt * ydotcost(t_blend + 1);
            
            cy(4) = subs(lambdaydot,t,0.1) == ydotcost(t_blend - 1);
            cy(5) = subs(lambdaydot,t,0.9) == ydotcost(t_blend + 1);
          
            [a0, a1, a2, a3] = vpasolve(cx);
            [b0, b1, b2, b3] = vpasolve(cy);
            coeffx = double([a0 a1 a2 a3]);
            coeffy = double([b0 b1 b2 b3]);
            
            xs = [xs; Calcola_lambda_3(T(i),T(i+1), tsim(:,i), coeffx)];

            xdots = [xdots; Calcola_lambda_3_dot(T(i),T(i+1), tsim(:,i), coeffx)];

            xddots = [xddots; Calcola_lambda_3_ddot(T(i),T(i+1), tsim(:,i), coeffx)];

            ys = [ys; Calcola_lambda_3(T(i),T(i+1), tsim(:,i), coeffy)];

            ydots = [ydots; Calcola_lambda_3_dot(T(i),T(i+1), tsim(:,i), coeffy)];

            yddots = [yddots; Calcola_lambda_3_ddot(T(i),T(i+1), tsim(:,i), coeffy)];
            
            t_blend = t_blend + 2;
            
        end
        
        thetas = [thetas; atan2(ydots, xdots)];
    
    elseif metodo == 2

        for i = 1 : size(tsim,2)

            xs = [xs; X(i,1) + Calcola_lambda(T(i),T(i+1), tsim(:,i))*(X(i+1,1)-X(i,1))];

            xdots = [xdots; Calcola_lambda_dot(T(i),T(i+1), tsim(:,i)) * (X(i+1,1)-X(i,1)) / (T(i+1) - T(i))];

            xddots = [xddots; Calcola_lambda_ddot(T(i),T(i+1), tsim(:,i)) * (X(i+1,1)-X(i,1)) / (T(i+1) - T(i))^2];

            ys = [ys; X(i,2) + Calcola_lambda(T(i),T(i+1), tsim(:,i))*(X(i+1,2)-X(i,2))];

            ydots = [ydots; Calcola_lambda_dot(T(i),T(i+1), tsim(:,i)) * (X(i+1,2)-X(i,2)) / (T(i+1) - T(i))];

            yddots = [yddots; Calcola_lambda_ddot(T(i),T(i+1), tsim(:,i)) * (X(i+1,2)-X(i,2)) / (T(i+1) - T(i))^2];           

        end
        
        thetas = [thetas; atan2(ydots, xdots)];
    
    end
end
