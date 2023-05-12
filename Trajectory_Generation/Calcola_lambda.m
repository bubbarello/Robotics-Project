function [lambda] = Calcola_lambda(T1, T2, tsim)
 lambda = [];
 for i=1:length(tsim)
 sigma = (tsim(i)-T1)/(T2-T1);
 lambda = [lambda; 6*sigma^5 - 15*sigma^4 + 10*sigma^3];
 end
end