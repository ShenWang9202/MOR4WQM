function YY = EstimateState_YY_Reduced_SaveMem(CurrentValue,IndexInVar,aux,ElementCount,q_B,tInMin,C0,PreviousValue)



MassEnergyMatrix = aux.MassEnergyMatrix;


Previous_delta_t = PreviousValue.PreviousDelta_t;
PreviousSystemDynamicMatrix = PreviousValue.PreviousSystemDynamicMatrix_reduced;

U_C_B_eachStep = PreviousValue.U_C_B_eachStep;
% We need to know the states 5 mins ago, apply the system dynamic for
% the past 5 mins to obtain the estimation of current value.
A = PreviousSystemDynamicMatrix.Ar;
B = PreviousSystemDynamicMatrix.Br;
C = PreviousSystemDynamicMatrix.Cr;
D = PreviousSystemDynamicMatrix.Dr;
NumberofX = size(A,1);
NumberofU = size(B,2);
Hq_min = ConfigurationConstants.Hq_min;

x_estimated = zeros(NumberofX,1);

% how many steps in 1 min
SetTimeParameter = Hq_min * ConfigurationConstants.MinInSecond/Previous_delta_t;
Np = round(SetTimeParameter);

U_C_B_eachStep;

U = zeros(NumberofU,Np);
if ~ConfigurationConstants.ONLY_COMPARE
    U(1:end-1,:) = U_C_B_eachStep;
end
U(end,1) = 1/Previous_delta_t;
XX = zeros(NumberofX,Hq_min);

%     A_1min = A^StepIn1Min;
%     A_1min = speye(NumberofX);

%     for i = 1:StepIn1Min
%         A_1min =  A_1min * A;
%     end

%     B_1min = sparse()
%     for i = 1:StepIn1Min
%         B_1min =
%     end
IndexofApplyingU = [];
for i = 1:Hq_min
    IndexofApplyingU = [IndexofApplyingU round(i * ConfigurationConstants.MinInSecond/Previous_delta_t)];
end
indexEachMin  = 1;
for i = 1:Np
    x_estimated = A * x_estimated + B * U(:,i);
    if( i == IndexofApplyingU(indexEachMin))
        XX(:,indexEachMin) = x_estimated;
        indexEachMin = indexEachMin + 1;
    end
    
end

YY = C * XX;

end