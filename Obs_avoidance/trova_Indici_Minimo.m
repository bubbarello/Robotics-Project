function [min, ind] = trova_Indici_Minimo(v)
  min = v(1,1);
  ind = [1 1];
  for i = 1 : size(v,1)
      for j = 1 : size(v,2)
          if v(i,j) <= min
              min = v(i,j);
              ind = [i j];
          end
      end
  end
end