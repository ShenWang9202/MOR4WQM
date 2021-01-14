function PreviousSystemDynamicMatrix = ObtainSystemDynamic(CurrentValue,IndexInVar,aux,ElementCount)
% Here we need to know the current concentration vector x which includes
% the c^J, c^R, c^TK, c^P, c^M, and c^W.
q_B = aux.q_B;
BoosterLocationIndex = aux.BoosterLocationIndex;
[A,B,C] = ObtainDynamicNew(CurrentValue,IndexInVar,aux,ElementCount,q_B);
B = B(:,BoosterLocationIndex);
nu = size(B,2);
ny = size(C,1);
D = zeros(ny,nu);
PreviousSystemDynamicMatrix = struct('A',A,...
    'B',B,...
    'C',C,...,
    'D',D);