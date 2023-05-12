function [lambda] = Calcola_lambda_ddot(T1, T2, tsim)
 lambda = [];
 for i=1:length(tsim)
 sigma = (tsim(i)-T1)/(T2-T1);
 lambda = [lambda; 120*sigma^3 - 180*sigma^2 + 60*sigma];
 end
end