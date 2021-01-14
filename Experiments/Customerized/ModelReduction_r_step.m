function [sysFull,ReducedsystemMatrix_BT,ReducedsystemMatrix_POD,ReducedsystemMatrix_BPOD]= ModelReduction_r_step(PreviousSystemDynamicMatrix,ReductionParameter,r_vector, tInMin,Network)
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

% Obtain impluse repsonse
outformat = 1;
steps = floor(DurationofResponseTested/(delta_t));
TimeLast = 0:delta_t:(steps-1)*delta_t;
TimeLast = TimeLast';

tic
disp('Obtaining step response for full model...')
[Yfull,~] = step(50*sys,TimeLast);
% [~,Yfull] = impluseDiscrete(sys.A,sys.B,sys.C,sys.D,sys.ts,steps,outformat);
tRes = toc;
dispText = sprintf('Full model step response takes %f sec',tRes);
disp(dispText)

OutputError_L1 = cell(1,10);
OutputRelativeError_L1 = cell(1,10);
OutputError_L1_sensor = cell(1,10);
OutputError_L1_init = cell(1,10);

i_output = 1;
% BT
if ConfigurationConstants.BT
    for r = r_vector
        tic
        ReducedsystemMatrix_BT = BalancedTrucation2_r(sys,r);
        tBT = toc;
        dispText = sprintf('BT takes %f sec',tBT);
        disp(dispText)
        
        sysBT = ss(ReducedsystemMatrix_BT.Ar,ReducedsystemMatrix_BT.Br,...
            ReducedsystemMatrix_BT.Cr,ReducedsystemMatrix_BT.Dr,delta_t);
        rBT = size(ReducedsystemMatrix_BT.Ar,1);
        
        disp('Obtaining step response for BT model...')
        tic
        %[~,YBT] = impluseDiscrete(sysBT.A,sysBT.B,sysBT.C,sysBT.D,sysBT.ts,steps,outformat);
        [YBT,~] = step(50*sysBT,TimeLast);
        tRes = toc;
        dispText = sprintf('BT model step response takes %f sec',tRes);
        disp(dispText)
        
        OutputError_L1{i_output} = YBT - Yfull;
        i_output = i_output + 1;
    end
    %explorePerformance('BT',Yfull,OutputError_L1,i_output,delta_t,r_vector,tInMin,Network);
    OutputError_L1_inputPerspective_BT = organizeData(Yfull,OutputError_L1,i_output);
end

if ConfigurationConstants.POD
    OutputError_L1 = cell(1,10);
    OutputRelativeError_L1 = cell(1,10);
    OutputError_L1_sensor = cell(1,10);
    OutputError_L1_init = cell(1,10);
    
    i_output = 1;
    numofSteps = BPOD_Steps;%2000%900%500;%2*Np;
    %rPOD = -1;
    
    for rPOD = r_vector
        tic
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
        
        disp('Obtaining step response for POD model...')
        tic
        %[~,YPOD] = impluseDiscrete(sysPOD.A,sysPOD.B,sysPOD.C,sysPOD.D,sysPOD.ts,steps,outformat);
        [YPOD,~] = step(50*sysPOD,TimeLast);
        tRes = toc;
        dispText = sprintf('POD model step response takes %f sec',tRes);
        disp(dispText)
        
        OutputError_L1{i_output} = YPOD - Yfull;
        i_output = i_output + 1;
    end
    %explorePerformance('POD',Yfull,OutputError_L1,i_output,delta_t,r_vector,tInMin,Network);
    OutputError_L1_inputPerspective_POD = organizeData(Yfull,OutputError_L1,i_output);
end

if ConfigurationConstants.BPOD
    OutputError_L1 = cell(1,10);
    OutputRelativeError_L1 = cell(1,10);
    OutputError_L1_sensor = cell(1,10);
    OutputError_L1_init = cell(1,10);
    
    i_output = 1;
    numofSteps = BPOD_Steps;%2000%900%500;%2*Np;
    %rPOD = -1;
    
    for rBPOD = r_vector
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
        
        disp('Obtaining step response for BPOD model...')
        tic
        %[~,YBPOD] = impluseDiscrete(sysBPOD.A,sysBPOD.B,sysBPOD.C,sysBPOD.D,sysBPOD.ts,steps,outformat);
        %     YBPOD = YBPOD + sysFull.C * X0;
        [YBPOD,~] = step(50*sysBPOD,TimeLast);
        tRes = toc;
        dispText = sprintf('BPOD model step response takes %f sec',tRes);
        disp(dispText)

        OutputError_L1{i_output} = YBPOD - Yfull;
        i_output = i_output + 1;
    end
    OutputError_L1_inputPerspective_BPOD = organizeData(Yfull,OutputError_L1,i_output);
    %explorePerformance('BPOD',Yfull,OutputError_L1,i_output,delta_t,r_vector,tInMin,Network);
end

 plotOutputError_r_all_StepResponse(OutputError_L1_inputPerspective_BT,OutputError_L1_inputPerspective_POD,OutputError_L1_inputPerspective_BPOD,delta_t,r_vector,tInMin)


close all;
end