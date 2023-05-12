function [lambda] = Calcola_lambda_dot(T1, T2, tsim)
 lambda = [];
 for i=1:length(tsim)
 sigma = (tsim(i)-T1)/(T2-T1);
 lambda = [lambda; 30*sigma^4 - 60*sigma^3 + 30*sigma^2];
 end
end