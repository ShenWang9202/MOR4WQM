function [sysFull,ReducedsystemMatrix_BT,ReducedsystemMatrix_POD,ReducedsystemMatrix_BPOD,timeCost]= ModelReduction_Noplots(PreviousSystemDynamicMatrix,ReductionParameter,tInMin)
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


timeCost = struct('tBT',tBT,...
    'tPOD',tPOD,...
    'tBPOD',tBPOD,...
    'tStablization_POD',tStablization_POD,...
    'tStablization_BPOD',tStablization_BPOD);


end