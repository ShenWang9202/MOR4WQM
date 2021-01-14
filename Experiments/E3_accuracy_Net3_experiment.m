% run E3_accuracy_experiment.m for net3 to get the data.
% Do not try BT method for net3 since it would take 12 hours, and would not give a result.
% only try BOPD and POD 

load('Net3TempAccuracyData.mat')
[~,nu] = size(B);
[nc,~] = size(C);
YData = cell(1,nu*nc); % the first step is 0,which is not accounted, we need to add it back
Counter = 0;
for i = 1:nu
    for j = 1:nc
        Counter = Counter + 1;
        temp = [];
        temp = [temp Yfull(:,j,i)];
        if 0
            temp = [temp YBT(:,j,i)];
        end
        if 1 %ConfigurationConstants.POD
            temp = [temp YPOD(:,j,i)];
        end
        if 1 %ConfigurationConstants.BPOD
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
    'rBT',-1,...
    'rPOD',rPOD,...
    'rBPOD',rBPOD);

YData{1} = 250 * YData{1}; % This is used to simualte increasing the energy of impulse function
YData{2} = 250 * YData{2};
YData{3} = 250 * YData{3};
YData{4} = 250 * YData{4};
YData{5} = 250 * YData{5};
YData{6} = 250 * YData{6};

plotAccuracy4paper_Net3(XData,YData,dimension);