function [sysFull,ReducedsystemMatrix_BT,ReducedsystemMatrix_POD,ReducedsystemMatrix_BPOD,timeCost]= ModelReduction_accuracy(PreviousSystemDynamicMatrix,ReductionParameter,tInMin)
%% initialize
sysBT = [];
ReducedsystemMatrix_BT = [];
ReducedsystemMatrix_POD = [];
ReducedsystemMatrix_BPOD = [];
POD_STABLIZED = 0;
BPOD_STABLIZED = 0;
tStablization_POD = -1;
tStablization_BPOD = -1;
tBT = -1;
tPOD = -1;
tBPOD = -1;

%% obtain parameter

NetworkName = ReductionParameter.NetworkName;
DurationofResponseTested = ReductionParameter.DurationofResponseTested;
delta_t = ReductionParameter.delta_t;
EnergyPercentageGoal_BPOD = ReductionParameter.EnergyPercentageGoal_BPOD;
EnergyPercentageGoal_POD = ReductionParameter.EnergyPercentageGoal_POD;
EnergyPercentageGoal_BT = ReductionParameter.EnergyPercentageGoal_BT;
BPOD_Steps = ReductionParameter.POD_Steps;

%% original sys

A = PreviousSystemDynamicMatrix.A;
B = PreviousSystemDynamicMatrix.B;
C = PreviousSystemDynamicMatrix.C;
D = PreviousSystemDynamicMatrix.D;

sysFull = struct('A',A,...
    'B',B,...
    'C',C,...
    'D',D,...
    'ts',delta_t);
[nx,~] = size(A);

sys = ss(A,B,C,D,delta_t);
% stepinfo(sys)
%% Model Reduction using BT, POD, BPOD
if ConfigurationConstants.BT
    % BT
    rBT = -1;
    tic
    ReducedsystemMatrix_BT = BalancedTrucation2(sys,EnergyPercentageGoal_BT,rBT);
    tBT = toc;
    dispText = sprintf('BT takes %f sec',tBT);
    disp(dispText)
    
    sysBT = ss(ReducedsystemMatrix_BT.Ar,ReducedsystemMatrix_BT.Br,...
        ReducedsystemMatrix_BT.Cr,ReducedsystemMatrix_BT.Dr,delta_t);
    rBT = size(ReducedsystemMatrix_BT.Ar,1);
    
end

if ConfigurationConstants.POD
    tic
    
    numofSteps = BPOD_Steps;%2000%900%500;%2*Np;
    rPOD = -1;
    ReducedsystemMatrix_POD = POD(PreviousSystemDynamicMatrix,delta_t,numofSteps,rPOD,EnergyPercentageGoal_POD);
    
    tPOD = toc;
    dispText = sprintf('POD takes %f sec',tPOD);
    disp(dispText)
    
    sysPOD = ss(ReducedsystemMatrix_POD.Ar,ReducedsystemMatrix_POD.Br,...
        ReducedsystemMatrix_POD.Cr,ReducedsystemMatrix_POD.Dr,delta_t);
    rPOD = size(ReducedsystemMatrix_POD.Ar,1);

    if(ConfigurationConstants.STABLIZE_POD && ~isstable(sysPOD))
        tic
        POD_STABLIZED = 1;
        newAr = stablizeSys(sysPOD.A,ConfigurationConstants.solver);
        ReducedsystemMatrix_POD.Ar = newAr;
        sysPOD.A = newAr;
        tStablization_POD = toc;
        dispText = sprintf('Stablization of POD takes %f sec',tStablization_POD);
        disp(dispText)
    end
end

if ConfigurationConstants.BPOD
    tic
    
    numofSteps = BPOD_Steps;%2000%900%500;%2*Np;
    rBPOD = -1;
    ReducedsystemMatrix_BPOD = BPOD(PreviousSystemDynamicMatrix,delta_t,numofSteps,rBPOD,EnergyPercentageGoal_BPOD);
    
    tBPOD = toc;
    dispText = sprintf('BPOD takes %f sec',tBPOD);
    disp(dispText)
    
    sysBPOD = ss(ReducedsystemMatrix_BPOD.Ar,ReducedsystemMatrix_BPOD.Br,...
        ReducedsystemMatrix_BPOD.Cr,ReducedsystemMatrix_BPOD.Dr,delta_t);
    rBPOD = size(ReducedsystemMatrix_BPOD.Ar,1);
    
    if(ConfigurationConstants.STABLIZE_BPOD && ~isstable(sysBPOD))
        tic
        BPOD_STABLIZED = 1;
        newAr = stablizeSys(sysBPOD.A,ConfigurationConstants.solver);
        ReducedsystemMatrix_BPOD.Ar = newAr;
        sysBPOD.A = newAr;
        tStablization_BPOD = toc;
        dispText = sprintf('Stablization of BPOD takes %f sec',tStablization_BPOD);
        disp(dispText)
    end
end
%% Obtain impluse repsonse

outformat = 1;
steps = floor(DurationofResponseTested/(delta_t));
XData = 0:delta_t:(steps-1)*delta_t;
XData = XData';

tic
disp('Obtaining impluse response for full model...')
[~,Yfull] = impluseDiscrete(sys.A,sys.B,sys.C,sys.D,sys.ts,steps,outformat);
tRes = toc;
dispText = sprintf('Full model impluse response takes %f sec',tRes);
disp(dispText)

if ConfigurationConstants.BT
    disp('Obtaining impluse response for BT model...')
    tic
    [~,YBT] = impluseDiscrete(sysBT.A,sysBT.B,sysBT.C,sysBT.D,sysBT.ts,steps,outformat);
    tRes = toc;
    dispText = sprintf('BT model impluse response takes %f sec',tRes);
    disp(dispText)
end

if ConfigurationConstants.POD
    disp('Obtaining impluse response for POD model...')
    tic
    [~,YPOD] = impluseDiscrete(sysPOD.A,sysPOD.B,sysPOD.C,sysPOD.D,sysPOD.ts,steps,outformat);
    tRes = toc;
    dispText = sprintf('POD model impluse response takes %f sec',tRes);
    disp(dispText)
end

if ConfigurationConstants.BPOD
    disp('Obtaining impluse response for BPOD model...')
    tic
    [~,YBPOD] = impluseDiscrete(sysBPOD.A,sysBPOD.B,sysBPOD.C,sysBPOD.D,sysBPOD.ts,steps,outformat);
    tRes = toc;
    dispText = sprintf('BPOD model impluse response takes %f sec',tRes);
    disp(dispText)
end

timeCost = struct('tBT',tBT,...
    'tPOD',tPOD,...
    'tBPOD',tBPOD,...
    'tStablization_POD',tStablization_POD,...
    'tStablization_BPOD',tStablization_BPOD);

[~,nu] = size(B);
[nc,~] = size(C);
YData = cell(1,nu*nc); % the first step is 0,which is not accounted, we need to add it back
Counter = 0;
for i = 1:nu
    for j = 1:nc
        Counter = Counter + 1;
        temp = [];
        temp = [temp Yfull(:,j,i)];
        if ConfigurationConstants.BT
            temp = [temp YBT(:,j,i)];
        end
        if ConfigurationConstants.POD  %1 %ConfigurationConstants.POD
            temp = [temp YPOD(:,j,i)];
        end
        if ConfigurationConstants.BPOD %1 %ConfigurationConstants.BPOD
            temp = [temp YBPOD(:,j,i)];
        end
        YData{Counter} = temp;
    end
end

%% Plot impluse responses
% figure
% impulse(sys,DurationofResponseTested), hold on;
% impulse(sysBPOD,DurationofResponseTested)
% legend('Full model','Balanced POD')
dimension = struct('full',nx,...
    'rBT',rBT,...
    'rPOD',rPOD,...
    'rBPOD',rBPOD);

plotAccuracy4paper_Net1(XData,YData,dimension);
%plotAccuracy4paper_Net3(XData,YData,dimension);
fig2 = figure;
for i = 1:Counter
    subplot(nc,nu,i)
    stairs(XData,YData{i});
end

% create legend strings
Counter = 1;

if ConfigurationConstants.BT
    Counter = Counter + 1;
end

if ConfigurationConstants.POD
    Counter = Counter + 1;
end

if ConfigurationConstants.BPOD
    Counter = Counter + 1;
end

lgndString = cell(1,Counter);
Counter = 1;
lgndString{Counter} = ['FULL, r=',int2str(nx)];

if ConfigurationConstants.BT
    Counter = Counter + 1;
    lgndString{Counter} = ['BT, r=',int2str(rBT)];
end

if ConfigurationConstants.POD
    Counter = Counter + 1;
    lgndString{Counter} = ['POD, r=',int2str(rPOD) ,',step = ', int2str(numofSteps)];
end

if ConfigurationConstants.BPOD
    Counter = Counter + 1;
    lgndString{Counter} = ['BPOD, r=',int2str(rBPOD) ,',step = ', int2str(numofSteps)];
end

% add a bit space to the figure
fig = gcf;
fig.Position(4) = fig.Position(4) + 400;
% add legend

lgnd = legend(lgndString);%'Location','NorthEast'
sgtitle(['Impulse Response when t = ',int2str(tInMin),'min']);
lgnd.Position(1) = 0.3;
lgnd.Position(2) = 0.02;

savedFileName = [NetworkName(1:end-4),'ImpulseResponse_',int2str(tInMin),'min'];

if ConfigurationConstants.BT
    savedFileName = [savedFileName,'_BT'];
end

if ConfigurationConstants.POD
   savedFileName = [savedFileName,'_POD'];
   if (ConfigurationConstants.STABLIZE_POD && POD_STABLIZED)
   savedFileName = [savedFileName,'stablized'];
   end
end

if ConfigurationConstants.BPOD
   savedFileName = [savedFileName,'_BPOD'];
   if (ConfigurationConstants.STABLIZE_BPOD && BPOD_STABLIZED)
   savedFileName = [savedFileName,'stablized'];
   end
end

if ~ConfigurationConstants.ONLY_COMPARE
   savedFileName = [savedFileName,'_MPC'];
end

print(fig2,savedFileName,'-dpng','-r300');
close all;
end