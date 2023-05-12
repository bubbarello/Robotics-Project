function [lambda] = Calcola_lambda_3_ddot(T1, T2, tsim, coeff)
 lambda = [];
 a0 = double(coeff(1));
 a1 = double(coeff(2));
 a2 = double(coeff(3));
 a3 = double(coeff(4));
 for i=1:length(tsim)
        sigma = (tsim(i)-T1)/(T2-T1);
        lambda = [lambda; 6*a0*sigma + 2*a1];          
 end
end