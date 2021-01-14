clear all, close all, clc
load testSys;  % previously saved system

q = 2;   % number of inputs
p = 2;   % number of outputs
n = 100; % state dimension
% sysFull = drss(n,p, q);
r = 10;  % reduced model order

%% Compute BPOD
ts = 1;
numofSteps = 51; % 0:1:(r*5)+1
numofInput = q;
% impluseSteps = 2*numofSteps;
% [impulseResponseX,impulseResponseY] = impluseDiscrete(sysFull.A,sysFull.B,sysFull.C,ts,impluseSteps);
% Hankel = obtainHankelMatrix(impulseResponseY,numofInput,numofSteps);
[impulseCtrlX,impulseObsY] = impulseCtrlObs(sysFull.A,sysFull.B,sysFull.C,ts,numofSteps);
Hankel =  impulseObsY * impulseCtrlX;

[U1,Sig1,V1] = svd(Hankel);
% indexRange = (2*numofInput + 1):((2 + numofSteps)*numofInput);
% impulseResponseX = impulseResponseX(:,indexRange);
% Phi1 = impulseResponseX*V1*Sig1^(-1/2); % modes
Phi1 = impulseCtrlX*V1*Sig1^(-1/2); % modes 
Psi1 = Sig1^(-1/2)*U1'*impulseObsY;

Ar = Psi1(1:r,:)*sysFull.A*Phi1(:,1:r);
Br = Psi1(1:r,:)*sysFull.B;
Cr = sysFull.C*Phi1(:,1:r);
Dr = sysFull.D;
sysBPOD1 = ss(Ar,Br,Cr,Dr,-1);

%% Plot impulse responses for all methods

figure
impulse(sysFull,0:1:60), hold on;
% impulse(sysBT,0:1:60)
impulse(sysBPOD1,0:1:60)
legend('FULL, r=100','Balanced POD1, r=10')