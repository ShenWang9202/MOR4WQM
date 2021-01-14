function [Yfull,YBPOD]= ModelReduction_stability(PreviousSystemDynamicMatrix,ReductionParameter,tInMin)
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
Yfull = [];



%% obtain parameter

NetworkName = ReductionParameter.NetworkName;
DurationofResponseTested = ReductionParameter.DurationofResponseTested;
delta_t = ReductionParameter.delta_t;
EnergyPercentageGoal_BPOD = ReductionParameter.EnergyPercentageGoal_BPOD;
BPOD_Steps = ReductionParameter.POD_Steps;
fullResponse = ReductionParameter.fullResponse;
stablization = ReductionParameter.stablization;
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
%% Model Reduction using BPOD

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
    
    if(stablization && ~isstable(sysBPOD))
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
if(fullResponse)
tic
disp('Obtaining impluse response for full model...')
[~,Yfull] = impluseDiscrete(sys.A,sys.B,sys.C,sys.D,sys.ts,steps,outformat);
tRes = toc;
dispText = sprintf('Full model impluse response takes %f sec',tRes);
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

end