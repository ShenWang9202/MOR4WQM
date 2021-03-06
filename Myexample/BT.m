clear all, close all, clc

A = [-.75 1; -.3 -.75];
B = [2; 1];
C = [1 2];
D = 0;

sys = ss(A,B,C,D,0.3);

Wc = gram(sys,'c'); % controllability Gramian
Wo = gram(sys,'o'); % observability Gramian

[sysb,g,Ti,T] = balreal(sys); % balance system

BWc = gram(sysb,'c') % balanced Gramians
BWo = gram(sysb,'o')

[T,D] = eig(Wc*Wo);

At = inv(T)*A*T;
Bt = inv(T)*B;
Ct = C*T;
Dt = 0;
sysBal = ss(At,Bt,Ct,Dt);

BWc = gram(sysBal,'c') % balanced Gramians
BWo = gram(sysBal,'o')

sc = diag(BWc)./diag(BWo);
T = T*diag(sc.^(1/4));

At = inv(T)*A*T;
Bt = inv(T)*B;
Ct = C*T;
Dt = 0;
sysBal = ss(At,Bt,Ct,Dt);

BWc = gram(sysBal,'c') % balanced Gramians
BWo = gram(sysBal,'o')
%% Plot Gramians
theta = 0:.01:2*pi;
xc = cos(theta);
yc = sin(theta);
CIRC = [xc; yc];

ELLIPb = Ti*sqrt(BWc)*T*CIRC;
ELLIPc = sqrt(Wc)*CIRC;
ELLIPo = sqrt(Wo)*CIRC;

plot(xc,yc,'k--','LineWidth',2)
hold on

% Draw controllability Gramian (unbalanced)
plot(ELLIPc(1,:),ELLIPc(2,:),'r','LineWidth',2)
patch(ELLIPc(1,:),ELLIPc(2,:),'r','FaceAlpha',.75)

% Draw observability Gramian (unbalanced)
plot(ELLIPo(1,:),ELLIPo(2,:),'b','LineWidth',2)
patch(ELLIPo(1,:),ELLIPo(2,:),'b','FaceAlpha',.75)

% Draw balanced Gramians
patch(ELLIPb(1,:),ELLIPb(2,:),'k','FaceColor',[.5 0 .5],'FaceAlpha',.25)
plot(ELLIPb(1,:),ELLIPb(2,:),'Color',[.35 0 .35],'LineWidth',2)

%% Formatting
axis equal, grid on
set(gcf,'Position',[1 1 550 400])
set(gcf,'PaperPositionMode','auto')
% print('-depsc2', '-loose', '../figures/FIG_BT_GRAM');
