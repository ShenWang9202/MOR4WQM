function [UeachIntervalforEPANET,U_C_B_eachStep] = ApplyMPC(systemMatrix,systemMatrix_reduced,Np,yk,PreviousValue,aux,delta_t,MODELREDUCTION)
if(MODELREDUCTION)
    A = systemMatrix_reduced.Ar;
    B = systemMatrix_reduced.Br;
    B = B(:,1:end-1);
    C = systemMatrix_reduced.Cr;
    D = systemMatrix_reduced.Dr;
    D = D(:,1:end-1);
else
    A = systemMatrix.A;
    B = systemMatrix.B;
    C = systemMatrix.C;
    D = systemMatrix.D;
end



Price_B = aux.Price_B;
flowRate_B = aux.flowRate_B;

% MPC data
[W,Z,~,~,~] = MPCScale(A,B,C,D,Np);

% x = x_estimated;
[nx,~] = size(A);
% yk = C*x
[ny,~] = size(yk);
Deltax = zeros(nx,1);
Xa = [Deltax;yk];
nu = size(B,2);
n_deltau = Np*nu;

%% Nail down parameters R, Q, b

% Change this R_coeff to change the smoothness of control action.
R_coeff = ConfigurationConstants.R_coeff;
R =  R_coeff * speye(n_deltau,n_deltau);

% reference
n_ref = ny*Np;
reference = ConfigurationConstants.reference;
reference = reference*ones(n_ref,1);
% only select the pipes now.
n_Q = Np*ny;
Q_coeff = ConfigurationConstants.Q_coeff;
Q = Q_coeff * speye(n_Q,n_Q);

b = [];
%b = ones(n_deltau,1);
for i = 1:Np
    temp = Np*[Price_B;];
    b = [b; temp];
end

% if(MODELREDUCTION)
%     R(end,end) = 10^15;
% end

Price_Weight = ConfigurationConstants.Price_Weight;

%DeltaU = (R + Z'*Q*Z)^(-1)*(Z'*Q*(reference-W*Xa)-Price_Weight*b);
preCal = Z'*Q;
DeltaU = (R + preCal*Z)\(preCal*(reference-W*Xa)-Price_Weight*b);
% We reshape it based on the number of nodes.
[m_Delta,~] = size(DeltaU);
column = m_Delta/nu;
DeltaU = reshape(DeltaU,nu,column);
% % Just pick the Junction2 out
% DeltaU_Junction2 = DeltaU(1,:);
% Times the flowRate_B to get the mass which is in mg/min
%DeltaU =  DeltaU .* q_B .* ConfigurationConstants.Gallon2Liter;
% Accumulate Delta U and make it as U;

% Note DeltaU is a relative value in terms of each step (delta_t)
[m_Delta,n_Delta] = size(DeltaU);
U = zeros(m_Delta,n_Delta);
U(:,1) = DeltaU(:,1);
for i = 1:n_Delta-1
    U(:,i+1) = U(:,i) + DeltaU(:,i+1);
end

% Note that this U is still a relative value (still a delta value) in terms of its previous value
% (5 minutes ago)

% Now the U_C_B is in mg/L.
U_C_B = U;

U_C_B_eachStep = U_C_B;
% Next, we obtain the true U
% Get the prevoius U;
PreviousU_C_B_eachStep = PreviousValue.U_C_B_eachStep;
% Get the Current asolute U;
U_C_B_eachStep = U_C_B_eachStep + PreviousU_C_B_eachStep(:,end);


% make sure the U_C_B_eachStep IS NOT NEGATIVE
% Because we only can add concentration to it, and cannot extract
% concnetration from water.
[m_UCB,n_UCB] = size(U_C_B_eachStep);
for i = 1:m_UCB
    for j = 1:n_UCB
        if(U_C_B_eachStep(i,j) < 0)
            disp('U_C_B_eachStep negative')
            U_C_B_eachStep(i,j) = 0;
        end
    end
end


% fix this, since we need to calcuate the average value for EPAENT in a
% minute. Our LDE model can apply in second, but due to the simulation step
% for EPANET is one minute, we only can apply control action at the integer
% minuter (1 2 3 4 .... minutes), but for LDE it is (1.2 1.3 1.4 minutes)

% even though the LDE and EPANET are close superly, the control action
% applied to the epanet and lde is different. This makes the final control
% effect is a little bit different.


% Next, we calcuate the realtive U for EPANET.



% This U is acutally C_B; UforEPANET is the source quality for EPAENT
% software since it requirs mg/min

% What we get here U (mg/L) is the concentration for each step,and our each step is in second instead of minute.
% Besides that, we assume the booster flow rate is q_B (gallon/min),so in order to get the mg/sec, we should convert
% flow reate to L/sec first,

% Now the UforEPANET is in mg for each step).
% UforEPANET =  U_C_B_eachStep .* q_B .* ConfigurationConstants.Gallon2Liter ./ ConfigurationConstants.MinInSecond * delta_t;
UforEPANET =  U_C_B_eachStep .* flowRate_B' .* ConfigurationConstants.Gallon2Liter ./ ConfigurationConstants.MinInSecond * delta_t;


% Get the prevoius U;
PreviousUforEPANET = PreviousValue.UeachIntervalforEPANET;

% Get the absolute U first
%UforEPANET = UforEPANET + PreviousUforEPANET(:,end);

% now this is the U for next Hq_min = 5 mins here
% But our Quality Time Step is set to 1 min, so we need to pick out the
% value at each minute.

Hq_min = ConfigurationConstants.Hq_min;
T_booster_min = ConfigurationConstants.T_booster_min;
NumofInterval = Hq_min/T_booster_min; % T_booster_min must be a factor or divisor of Hq_min when setting
NumofStepsEachInterval = Np/NumofInterval;

UeachIntervalforEPANET = [];
for i = 1:NumofInterval
    startIndex = NumofStepsEachInterval*(i-1) + 1;
    endIndex =  NumofStepsEachInterval * i;
    eachMinMass = sum(UforEPANET(:,startIndex:endIndex),2);
    UeachIntervalforEPANET = [UeachIntervalforEPANET eachMinMass];
end

% make sure the UeachIntervalforEPANET IS NOT NEGATIVE
[m_UCB,n_UCB] = size(UeachIntervalforEPANET);
for i = 1:m_UCB
    for j = 1:n_UCB
        if(UeachIntervalforEPANET(i,j) < 0)
            disp('U_C_B_eachMin negative')
            UeachIntervalforEPANET(i,j) = 0;
        end
    end
end

end