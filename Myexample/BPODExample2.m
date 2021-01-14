% This example is use to explore the impact of the number of steps

clear all, close all, clc
load testSys;  % previously saved system
q = 2;   % number of inputs
p = 2;   % number of outputs
n = 100; % state dimension
% sysFull = drss(n,p, q);

%% Compute BPOD1
ts = 1;

numofSteps = 50;
%change r from 10 to 100;

for r = 10:20:100
    ReducedsystemMatrix1 = BPOD(sysFull,ts,numofSteps,r);
    
    sysBPOD1 = ss(ReducedsystemMatrix1.Ar,ReducedsystemMatrix1.Br,...
        ReducedsystemMatrix1.Cr,ReducedsystemMatrix1.Dr,ts);
    figure
    impulse(sysFull,0:1:60), hold on;
    % impulse(sysBT,0:1:60)
    impulse(sysBPOD1,0:1:60)
    legend('FULL, r=100',['Balanced POD1, r=',int2str(r),', step = ', int2str(numofSteps)])
end

%% Decide the best r
ts = 1;

numofSteps = 50;
%change r from 10 to 100;
r = -1;
ReducedsystemMatrix1 = BPOD(sysFull,ts,numofSteps,r);

sysBPOD1 = ss(ReducedsystemMatrix1.Ar,ReducedsystemMatrix1.Br,...
    ReducedsystemMatrix1.Cr,ReducedsystemMatrix1.Dr,ts);
r = size(ReducedsystemMatrix1.Ar,1);
figure
impulse(sysFull,0:1:60), hold on;
% impulse(sysBT,0:1:60)
impulse(sysBPOD1,0:1:60)
legend('FULL, r=100',['Balanced POD1, r=',int2str(r),', step = ', int2str(numofSteps)])



%% Compute BPOD1
ts = 1;
%change this from 10 to 100;
r = 20;
for numofSteps = 10:20:100
    ReducedsystemMatrix1 = BPOD(sysFull,ts,numofSteps,r);
    
    sysBPOD1 = ss(ReducedsystemMatrix1.Ar,ReducedsystemMatrix1.Br,...
        ReducedsystemMatrix1.Cr,ReducedsystemMatrix1.Dr,ts);
    figure
    impulse(sysFull,0:1:60), hold on;
    % impulse(sysBT,0:1:60)
    impulse(sysBPOD1,0:1:60)
    legend('FULL, r=100',['Balanced POD1, r=',int2str(r),', step = ', int2str(numofSteps)])
end
