function [UeachIntervalforEPANET,U_C_B_eachStep,PreviousSystemDynamicMatrix] = ObtainControlAction(CurrentValue,IndexInVar,aux,ElementCount,x_estimated,PreviousValue,POD_Steps)
% Here we need to know the current concentration vector x which includes
% the c^J, c^R, c^TK, c^P, c^M, and c^W.

delta_t = CurrentValue.delta_t;
q_B = aux.q_B;
BoosterLocationIndex = aux.BoosterLocationIndex;
Np = CurrentValue.Np;
[A,B,C] = ObtainDynamicNew(CurrentValue,IndexInVar,aux,ElementCount,q_B);
B = B(:,BoosterLocationIndex);

nu = size(B,2);
ny = size(C,1);
D = zeros(ny,nu);

PreviousSystemDynamicMatrix = struct('A',A,...
    'B',B,...
    'C',C,...
    'D',D);

[UeachIntervalforEPANET,U_C_B_eachStep] = ApplyMPC(PreviousSystemDynamicMatrix,Np,x_estimated,PreviousValue,aux,delta_t);





