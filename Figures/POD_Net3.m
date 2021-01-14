function ReducedsystemMatrix = POD_Net3(systemMatrix,sampleTime,numofSteps,r,EnergyPercentageGoal_POD)
% if r is -1, it means we need to decide the best r

A = systemMatrix.A;
B = systemMatrix.B;
C = systemMatrix.C;
D = systemMatrix.D;
ts = sampleTime;

[impulseCtrlX,~] = impulseCtrlObs_Acc(A,B,C,ts,numofSteps);
R = impulseCtrlX'*impulseCtrlX;

%% Eigvalue method
% [Vect,Diag] = eig(R);
% [Vect,Diag] = sortem(Vect,Diag);
% nx = size(A,1);
% 
% if(numofSteps >= nx)
%     Vect = Vect(:,1:nx);
%     Diag = Diag(1:nx,1:nx);
% end
% 
% goal = 99.99999995/100;
% fullModeNum = size(Diag,1);
% if r == -1
%     r = ObtainModeR(fullModeNum,goal,diag(Diag));
% end
% Vect = Vect(:,1:r);
% Diag = Diag(1:r,1:r);
% 
% 
% T2 = impulseCtrlX*Vect*Diag^(-1/2); % modes
% S2 = Diag^(-1/2)*Vect'*impulseCtrlX';

%% SVD method
[U1,Sig1,V1] = rsvd1(R,1000,2,0); % Randomized SVD

goal = EnergyPercentageGoal_POD;
fullModeNum = size(Sig1,1);
if r == -1
    r = ObtainModeR(fullModeNum,goal,diag(Sig1));
end
Sig1 = Sig1(1:r,1:r);
U1 = U1(:,1:r);
V1 = V1(:,1:r);


T1 = impulseCtrlX*V1*Sig1^(-1/2); % modes
S1 = Sig1^(-1/2)*U1'*impulseCtrlX';
Ar = S1*A*T1;
Br = S1*B;
Cr = C*T1;
Dr = D;

ReducedsystemMatrix = struct('Ar',Ar,...
    'Br',Br,...
    'Cr',Cr,...
    'Dr',Dr,...
    'nr',r,...
    'T',T1,...
    'S',S1);
end