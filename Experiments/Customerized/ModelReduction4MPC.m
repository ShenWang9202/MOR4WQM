function [sysBT,ReducedsystemMatrix_POD,ReducedsystemMatrix_BPOD]= ModelReduction4MPC(PreviousSystemDynamicMatrix,delta_t,BPOD_Steps)
%% initialize
sysBT = [];
ReducedsystemMatrix_POD = [];
ReducedsystemMatrix_BPOD = [];

%% original sys
A = PreviousSystemDynamicMatrix.A;
B = PreviousSystemDynamicMatrix.B;
C = PreviousSystemDynamicMatrix.C;
D = 0;
sysFull = struct('A',A,...
    'B',B,...
    'C',C,...
    'D',D,...
    'ts',delta_t);

sys = ss(A,B,C,D,delta_t);
%% Model Reduction using BT, POD, BPOD
if ConfigurationConstants.BT
    % BT
    tic
    [sysBT, rBT] = BalancedTrucation(sys);
    tBT = toc;
    dispText = sprintf('BT takes %f sec',tBT);
    disp(dispText)
end

if ConfigurationConstants.POD
    tic
    
    numofSteps = BPOD_Steps;%2000%900%500;%2*Np;
    rPOD = -1;
    ReducedsystemMatrix_POD = POD(PreviousSystemDynamicMatrix,delta_t,numofSteps,-1);
    
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
    ReducedsystemMatrix_BPOD = BPOD(PreviousSystemDynamicMatrix,delta_t,numofSteps,-1);
    
    tBPOD = toc;
    dispText = sprintf('BPOD takes %f sec',tBPOD);
    disp(dispText)
    
    sysBPOD = ss(ReducedsystemMatrix_BPOD.Ar,ReducedsystemMatrix_BPOD.Br,...
        ReducedsystemMatrix_BPOD.Cr,ReducedsystemMatrix_BPOD.Dr,delta_t);
    rBPOD = size(ReducedsystemMatrix_BPOD.Ar,1);
    
    if(ConfigurationConstants.STABLIZE_BPOD && ~isstable(sysBPOD))
        tic
        newAr = stablizeSys(sysBPOD.A,ConfigurationConstants.solver);
        ReducedsystemMatrix_BPOD.Ar = newAr;
        sysBPOD.A = newAr;
        tStablization_BPOD = toc;
        dispText = sprintf('Stablization of BPOD takes %f sec',tStablization_BPOD);
        disp(dispText)
    end
end


end