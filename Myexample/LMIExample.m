clc
clear
% load('unstabilitytest.mat')
load('unstabilitytestNet3.mat')
isstable(sys)
isstable(sysBT)
isstable(sysBPOD)

%% test stability using LMI method
tic
Ar = sysBPOD.A;
%Ar = [0.9 0;0 0.9]
r = size(Ar,1);
cvx_begin sdp
    variable P(r,r) symmetric
    minimize( 0 );
    subject to
    P >= eps*eye(r)
    Ar'*P*Ar - P <= -eps*eye(r)
cvx_end
time_cvx = toc;

%% test YalMIP that is much faster than CVX
tic
A = sysBPOD.A;
r = size(A,1);
% A = [-1 2 0;-3 -4 1;0 0 -2];
P = sdpvar(r,r);
F = [P >= 0, A'*P+P*A <= 0, trace(P)==1];
optimize(F,P(1,1));
time_YalMIP=toc

%% stablize Ar using CVX
cvx_clear
Ar = [1.1 0;0 0.9];
r = size(Ar,1);
cvx_begin sdp
    variable P(r,r) symmetric
    variable DeltaY(r,r)
    variable alpha_my(r,r) diagonal
    minimize( trace(alpha_my)/r );
    subject to
        P >= eye(r);
        alpha_my >= eps*eye(r);
        [eye(r), DeltaY; DeltaY', alpha_my] >= eps*eye(2*r);
        [-P, (P*Ar + DeltaY)';(P*Ar + DeltaY), -P] <= -eps*eye(2*r);
cvx_end

DeltaX = P\DeltaY;
NewAr = Ar + DeltaX;
eig(Ar)
eig(NewAr)
eig(NewAr) - eig(Ar)
cvx_clear
%% Another model using cvx; this is slower
% Ar = [1.1 0;0 0.9];
% r = size(Ar,1);
cvx_begin sdp
    variable P(r,r) symmetric
    variable DeltaY(r,r)
    minimize(norm(DeltaY,1));
    subject to
        P >= eye(r);
        [-P, (P*Ar + DeltaY)';(P*Ar + DeltaY), -P] <= -eps*eye(2*r);
cvx_end

DeltaX = P\DeltaY;
NewAr = Ar + DeltaX;
eig(Ar)
eig(NewAr)
eig(NewAr) - eig(Ar)


%% stablize Ar while preserving the performance of BPOD/POD using YalMIP

% note that this code needs YalMIP and SDPNALplus solver
% See https://yalmip.github.io/download/
% See https://blog.nus.edu.sg/mattohkc/softwares/sdpnalplus/
% See https://yalmip.github.io/solver/sdpnal/

% Be careful that the interface folder in sdpnal should be removed, since
% the classes it defined conflicts the one in YalmMIP

% Note that there is a name clash between YALMIP and SDPNAL, so the 
% directory interface/@constraint in SDPNAL has to be removed or 
% removed from the path for SDPNAL to work in YALMIP (or add YALMIP
% after SDPNAL in the path)

Ar = sysBPOD.A;
Ar = [1.1, 0 , 0, 0.2;
      0,   0.8, 0, 0.3;
      0.2, 0.3, 0.9, 0;
      0, 0, 0, 0.2;]
r = size(Ar,1);
P =  eye(r);%sdpvar(r,r);
DeltaY = sdpvar(r,r,'full');
alpha_my = diag(sdpvar(r,1));
Constraints1 = [];
%Constraints1 = [Constraints1, P >= eye(r)];
Constraints1 = [Constraints1, [eye(r), DeltaY; DeltaY', alpha_my] >= eps*eye(2*r)];
Constraints1 = [Constraints1, [-P, (P*Ar + DeltaY)';(P*Ar + DeltaY), -P] <= -eps*eye(2*r);];
Obj = trace(alpha_my)/r;
% Obj = norm(DeltaY,1);
% ops = sdpsettings('solver','sdpt3','verbose',1,'debug',1);
ops = sdpsettings('solver','sdpnal','sdpnal.maxiter',500,'verbose',1,'debug',1);

sol = optimize(Constraints1,Obj,ops)
P0 = value(P);
DeltaY0 = value(DeltaY);
alpha_my0 = value(alpha_my);

DeltaX = P0\DeltaY0;
DeltaX1 = roundn(DeltaX,-4);
P1 = roundn(P0,-2);
NewAr = Ar + DeltaX;
eigA = abs(eig(Ar));
eigNewA = abs(eig(NewAr));
eig(NewAr)
eig(NewAr) - eig(Ar)

[V,D] = eig(Ar);
V1 = roundn(V,-4)
resultA = Ar - V*D*inv(V);
resultA = roundn(resultA,-5);
