% impulseCtrlObs test
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

ts = 0.2;
numofSteps = 1000;
profile on
[impulseCtrlX,impulseObsY] = impulseCtrlObs(A,B,C,ts,numofSteps);
Hankel1 = impulseObsY * impulseCtrlX;
[impulseCtrlX,impulseObsY] = impulseCtrlObs_Acc(A,B,C,ts,numofSteps);
Hankel2 = impulseObsY * impulseCtrlX;
result = Hankel2 - Hankel1;
profile viewer