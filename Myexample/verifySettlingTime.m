% This is used to verify the settling time for net1 with zero inital
% conditions (Set X= 0 in main.m).

% According to my derviation, y[k] = C*A^(k-1)*B =  

A = PreviousSystemDynamicMatrix.A
[V,D] = eig(full(A));
D = diag(D)
scatter(real(D),imag(D))
D1 = D;

absD = abs(D);

Final = [D,absD]
[va,I] = maxk(absD,4)

-4/log(0.9983)
