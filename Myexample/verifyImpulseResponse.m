% verify impulse response of state space model
clear;clc;
A = [-.75 1; -.3 -.75];
B = [1; 1];
C = [1 2];
D = 1;
ts = 2;
numofSteps = 10;
fullTime = numofSteps*ts;
tic
sysFull = ss(A,B,C,D,ts);
[yfull,t,xfull] = impulse(sysFull,0:ts:fullTime);
toc

% From the observation, I noticed that the impulse is defined as 1/ts, that
% is, the u = 1/ts (when dimesion is 1)

% the following is my way to calculate impulse response

u = 1/ts;
x = B*u;
tic
xfull_myway = [0;0];
xfull_myway = [xfull_myway x];
for i = 1:numofSteps
    x = A*x;
    xfull_myway = [xfull_myway x ];
end
yfull_myway = C * xfull_myway;

impulseResponse1 = yfull_myway;
toc

% make the above as a function
impulseResponse1 = impluseDiscrete(A,B,C,D,ts,numofSteps,0,0);

n = 100;
p = 2;
q = 2;
sysFull = drss(n,p, q);
A = sysFull.A;
B = sysFull.B;
C = sysFull.C;
D = [1,0;0,1];
ts = 0.3;
sysFull = ss(A,B,C,D,ts);
numofSteps = 10;
fullTime = numofSteps*ts;
tic
[yfull,t,xfull] = impulse(sysFull,0:ts:fullTime);
toc

tic 
[impulseResponseX,impulseResponseY] = impluseResponse(A,B,C,D,ts,numofSteps,0,1);
toc

