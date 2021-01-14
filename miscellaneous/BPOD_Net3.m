function ReducedsystemMatrix = BPOD_Net3(systemMatrix,sampleTime,numofSteps,r,EnergyPercentageGoal_BPOD)
% if r is -1, it means we need to decide the best r

A = systemMatrix.A;
B = systemMatrix.B;
C = systemMatrix.C;
D = systemMatrix.D;
ts = sampleTime;

[impulseCtrlX,impulseObsY] = impulseCtrlObs_Acc(A,B,C,ts,numofSteps);

% Hankel =  impulseObsY * impulseCtrlX; %too slow for large-scale matrix
%[~,impulseResponseY] = impluseDiscrete(A,B,C,D,ts,2*numofSteps,0);
impulseResponseY1 = impluseDiscrete1(A,B,C,D,ts,2*numofSteps);
numofInput = size(B,2);
numofoutput = size(C,1);
% tic
% Hankel = obtainHankelMatrix(impulseResponseY,numofInput,numofoutput,numofSteps);
% toc1 = toc;
Hankel1 = obtainHankelMatrix1(impulseResponseY1,numofInput,numofoutput,numofSteps);
% toc2 = toc;
% toc2 - toc1

%Hankel = roundn(Hankel1,-5);
% Hankel1 = roundn(Hankel1,-20);
% restul = Hankel - Hankel1;

% 1. This is svd method, super slow
% Hankel = full(Hankel);
%
% [U,Sig,V] = svd(Hankel);
% [U1,Sig1,V1] = svd(Hankel1,'econ');

% large iteration can get better results, but costs too much time at the
% same time;
iteration = 2;
[U1,Sig1,V1] = rsvd1(Hankel1,1000,iteration,0); % Randomized SVD
% [Ua,Siga,Va] = rSVDPI(Hankel1,500,2,0); % Randomized SVD
% [Ub,Sigb,Vb] = rSVDBKI(Hankel1,500,2,0); % Randomized SVD

goal = EnergyPercentageGoal_BPOD;
fullModeNum = size(Sig1,1);
if r == -1
    r = ObtainModeR(fullModeNum,goal,diag(Sig1));
end
Sig1 = Sig1(1:r,1:r);
U1 = U1(:,1:r);
V1 = V1(:,1:r);
% V_transpose = V';
% V1_transpose = V_transpose(1:r,:);
% V1 = V1_transpose';

% 2. This is random svd method, 27 times faster

% power iteration: i = 1;
% oversample: s = 0;
% [U1,Sig1,V1] = rsvd1(Hankel1,r,1,0); % Randomized SVD


% [U2,Sig2,V2] = rsvd(Hankel,r,1,0); % Randomized SVD


% 3. The following method also faster, same level as rsvd1

%[U1, S1, V1] = rSVDPI(Hankel, r, i);
% [U2, S2, V2] = basicrSVD(Hankel, r, i);
% [U3, S3, V3] = rSVDBKI(Hankel, r, i);
% [U4, S4, V4] = rSVDpack(Hankel, r, i);
% [U5, S5, V5] = pcafast(Hankel, r, i);


T1 = impulseCtrlX*V1*Sig1^(-1/2); % modes
S1 = Sig1^(-1/2)*U1'*impulseObsY;
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