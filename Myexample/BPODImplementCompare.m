clear all, close all, clc
load testSys;  % previously saved system

q = 2;   % number of inputs
p = 2;   % number of outputs
n = 100; % state dimension
% sysFull = drss(n,p, q);
r = 10;  % reduced model order

%% Plot Hankel singular values
hsvs = hsvd(sysFull); % Hankel singular values
figure
subplot(1,2,1)
semilogy(hsvs,'k','LineWidth',2)
hold on, grid on
semilogy(r,hsvs(r),'ro','LineWidth',2)
ylim([10^(-15) 100])
subplot(1,2,2)
plot(0:length(hsvs),[0; cumsum(hsvs)/sum(hsvs)],'k','LineWidth',2)
hold on, grid on
plot(r,sum(hsvs(1:r))/sum(hsvs),'ro','LineWidth',2)
set(gcf,'Position',[1 1 550 200])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/FIG_BT_HSVS');

%% Exact balanced truncation
sysBT = balred(sysFull,r);  % balanced truncation
%% Compute BPOD
% this is the orignal way to compute Hankel Mtrix
tic
[yFull,t,xFull] = impulse(sysFull,0:1:(r*5)+1);  
sysAdjoint = ss(sysFull.A',sysFull.C',sysFull.B',sysFull.D',-1);
[yAdjoint,t,xAdjoint] = impulse(sysAdjoint,0:1:(r*5)+1);
% not the fastest way to compute, but illustrative
% both xAdjoint and xFull are size m x n x 2
HankelOC = [];  % Compute Hankel matrix H=OC
% we start at 2 to avoid incorporating the D matrix
for i=2:size(xAdjoint,1)
    Hrow = [];
    for j=2:size(xFull,1)
        Ystar = permute(squeeze(xAdjoint(i,:,:)),[2 1]);        
        MarkovParameter = Ystar*squeeze(xFull(j,:,:));
        Hrow = [Hrow MarkovParameter];
    end
    HankelOC = [HankelOC; Hrow];
end

toc
% this is the my way to compute Hankel Mtrix, much more efficient
tic
ts = 1;
numofSteps = 51; % 0:1:(r*5)+1
numofInput = q;
% impluseSteps = 2*numofSteps;
% [impulseResponseX,impulseResponseY] = impluseDiscrete(sysFull.A,sysFull.B,sysFull.C,ts,impluseSteps);
% Hankel = obtainHankelMatrix(impulseResponseY,numofInput,numofSteps);
[impulseCtrlX,impulseObsY] = impulseCtrlObs(sysFull.A,sysFull.B,sysFull.C,ts,numofSteps);
Hankel =  impulseObsY * impulseCtrlX;
toc

[U,Sig,V] = svd(HankelOC);
Xdata = [];
Ydata = [];
for i=2:size(xFull,1)  % we start at 2 to avoid incorporating the D matrix
    Xdata = [Xdata squeeze(xFull(i,:,:))];
    Ydata = [Ydata squeeze(xAdjoint(i,:,:))];
end
Phi = Xdata*V*Sig^(-1/2); % modes
Psi = Ydata*U*Sig^(-1/2);


[U1,Sig1,V1] = svd(Hankel);
% indexRange = (2*numofInput + 1):((2 + numofSteps)*numofInput);
% impulseResponseX = impulseResponseX(:,indexRange);
% Phi1 = impulseResponseX*V1*Sig1^(-1/2); % modes
Phi1 = impulseCtrlX*V1*Sig1^(-1/2); % modes 
Psi1 = Sig1^(-1/2)*U1'*impulseObsY;



Ar = Psi(:,1:r)'*sysFull.A*Phi(:,1:r);
Br = Psi(:,1:r)'*sysFull.B;
Cr = sysFull.C*Phi(:,1:r);
Dr = sysFull.D;
sysBPOD = ss(Ar,Br,Cr,Dr,-1);

Ar = Psi1(1:r,:)*sysFull.A*Phi1(:,1:r);
Br = Psi1(1:r,:)*sysFull.B;
Cr = sysFull.C*Phi1(:,1:r);
Dr = sysFull.D;
sysBPOD1 = ss(Ar,Br,Cr,Dr,-1);

%% Plot impulse responses for all methods
figure
impulse(sysFull,0:1:60), hold on;
% impulse(sysBT,0:1:60)
impulse(sysBPOD,0:1:60)
legend('FULL, r=100','Balanced POD, r=10')

figure
impulse(sysFull,0:1:60), hold on;
% impulse(sysBT,0:1:60)
impulse(sysBPOD1,0:1:60)
legend('FULL, r=100','Balanced POD1, r=10')

figure
impulse(sysBPOD,0:1:60),hold on;
impulse(sysBPOD1,0:1:60)
legend('Balanced POD, r=10','Balanced POD1, r=10')

%% Plot impulse responses for all methods
figure
[y1,t1] = impulse(sysFull,0:1:200);
[y2,t2] = impulse(sysBT,0:1:100)
[y5,t5] = impulse(sysBPOD,0:1:100)
subplot(2,2,1)
stairs(y1(:,1,1),'LineWidth',2);
hold on
stairs(y2(:,1,1),'LineWidth',1.2);
stairs(y5(:,1,1),'LineWidth',1.);
ylabel('y_1')
title('u_1')
set(gca,'XLim',[0 60]);
grid on
subplot(2,2,2)
stairs(y1(:,1,2),'LineWidth',2);
hold on
stairs(y2(:,1,2),'LineWidth',1.2);
stairs(y5(:,1,2),'LineWidth',1.);
title('u_2')
set(gca,'XLim',[0 60]);
grid on
subplot(2,2,3)
stairs(y1(:,2,1),'LineWidth',2);
hold on
stairs(y2(:,2,1),'LineWidth',1.2);
stairs(y5(:,2,1),'LineWidth',1.);
xlabel('t')
ylabel('y_2')
set(gca,'XLim',[0 60]);
grid on
subplot(2,2,4)
stairs(y1(:,2,2),'LineWidth',2);
hold on
stairs(y2(:,2,2),'LineWidth',1.2);
stairs(y5(:,2,2),'LineWidth',1.);
xlabel('t')
set(gca,'XLim',[0 60]);
grid on
subplot(2,2,2)
legend('Full model, n=100',['Balanced truncation, r=',num2str(r)],['Balanced POD, r=',num2str(r)])
set(gcf,'Position',[100 100 550 350])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/FIG_BT_IMPULSE');