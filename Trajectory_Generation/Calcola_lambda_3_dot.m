function [lambda] = Calcola_lambda_3_dot(T1, T2, tsim, coeff)
 lambda = [];
 a0 = double(coeff(1));
 a1 = double(coeff(2));
 a2 = double(coeff(3));
 a3 = double(coeff(4));
 for i=1:length(tsim)
         sigma = (tsim(i)-T1)/(T2-T1);
         lambda = [lambda; 3*a0*sigma^2 + 2*a1*sigma + a2];         
 end
end