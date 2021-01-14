clear all, close all, clc

A = [-.75 1; -.3 -.75];
B = [2; 1];
C = [1 2];
D = 0;


clear all, close all, clc
load testSys;  % previously saved system

q = 2;   % number of inputs
p = 2;   % number of outputs
n = 100; % state dimension
% sysFull = drss(n,p, q);
r = 10;  % reduced model order
A = sysFull.A;
B = sysFull.B;
C = sysFull.C;
D = sysFull.D;
sysDiscrete = ss(A,B,C,D,10);

Wc = gram(sysDiscrete,'c'); % controllability Gramian
Wo = gram(sysDiscrete,'o'); % observability Gramian

all = abs(eig(Wo*Wc))

nx = size(A,1);
ControlabilityGramian = sparse(nx,nx);
temp1 = B;
Temp = B * B';
kf = 20;
for j=1:kf
    % from [0,k]
    ControlabilityGramian = ControlabilityGramian + Temp;
    temp1 = A * temp1;
    Temp = temp1*temp1';
end

nx = size(A,1);
ObservabilityGramian = sparse(nx,nx);
temp1 = C;
Temp = C' * C;
for j=1:kf
    % from [0,k]
    ObservabilityGramian = ObservabilityGramian + Temp;
    temp1 = temp1*A;
    Temp = temp1'*temp1;
end
part = abs(eig(ObservabilityGramian*ControlabilityGramian))
