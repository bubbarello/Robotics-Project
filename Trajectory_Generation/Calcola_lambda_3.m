function [lambda] = Calcola_lambda_3(T1, T2, tsim, coeff)
 lambda = [];
 a0 = coeff(1);
 a1 = coeff(2);
 a2 = coeff(3);
 a3 = coeff(4);
 for i=1:length(tsim)
         sigma = (tsim(i)-T1)/(T2-T1);
         lambda = [lambda; a0*sigma^3 + a1*sigma^2 + a2*sigma + a3]; 
 end
end