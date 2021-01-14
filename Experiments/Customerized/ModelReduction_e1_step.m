function [sysFull,ReducedsystemMatrix_BT,ReducedsystemMatrix_POD,ReducedsystemMatrix_BPOD,timeCost]= ModelReduction_e1(PreviousSystemDynamicMatrix,ReductionParameter,tInMin)
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
    rBT = size(ReducedsystemMatrix_BT.Ar,1)
    
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
    rPOD = size(ReducedsystemMatrix_POD.Ar,1)

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
    rBPOD = size(ReducedsystemMatrix_BPOD.Ar,1)
    
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

%% Obtain step repsonse
% figure
% [~,Yfull] = step(10*sys,DurationofResponseTested), hold on;
% step(10*sysBT,DurationofResponseTested), hold on;
% step(10*sysPOD,DurationofResponseTested), hold on;
% step(10*sysBPOD,DurationofResponseTested)
% legend('Full model','Balanced POD')

outformat = 1;
steps = floor(DurationofResponseTested/(delta_t));
TimeLast = 0:delta_t:(steps-1)*delta_t;
TimeLast = TimeLast';

tic
disp('Obtaining step response for full model...')
[Yfull,~] = step(50*sys,TimeLast);%impluseDiscrete(sys.A,sys.B,sys.C,sys.D,sys.ts,steps,outformat);


tRes = toc;
dispText = sprintf('Full model step response takes %f sec',tRes);
disp(dispText)

if ConfigurationConstants.BT
    disp('Obtaining step response for BT model...')
    tic
    [YBT,~] = step(50*sysBT,TimeLast);%impluseDiscrete(sysBT.A,sysBT.B,sysBT.C,sysBT.D,sysBT.ts,steps,outformat);
    tRes = toc;
    dispText = sprintf('BT model step response takes %f sec',tRes);
    disp(dispText)
end

if ConfigurationConstants.POD
    disp('Obtaining step response for POD model...')
    tic
    [YPOD,~] = step(50*sysPOD,TimeLast);%impluseDiscrete(sysPOD.A,sysPOD.B,sysPOD.C,sysPOD.D,sysPOD.ts,steps,outformat);
%     YPOD = YPOD + sysFull.C * X0;
    tRes = toc;
    dispText = sprintf('POD model step response takes %f sec',tRes);
    disp(dispText)
end

if ConfigurationConstants.BPOD
    disp('Obtaining step response for BPOD model...')
    tic
    [YBPOD,~] = step(50*sysBPOD,TimeLast);%impluseDiscrete(sysBPOD.A,sysBPOD.B,sysBPOD.C,sysBPOD.D,sysBPOD.ts,steps,outformat);
%     YBPOD = YBPOD + sysFull.C * X0;
    tRes = toc;
    dispText = sprintf('BPOD model step response takes %f sec',tRes);
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
        if ConfigurationConstants.POD
            temp = [temp YPOD(:,j,i)];
        end
        if ConfigurationConstants.BPOD
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
fontsize = 35;
% Make sure nc = nu = 1;
fig2 = figure;
h1 = subplot(1,3,1);
% plot(XData,YData{1});

Ydata = YData{1};
plot(TimeLast,Ydata(:,1),'LineWidth',4);
hold on
plot(TimeLast,Ydata(:,2),'-.','LineWidth',3.5);
hold on
plot(TimeLast,Ydata(:,3),'--','LineWidth',3);
hold on
plot(TimeLast,Ydata(:,4),'--','LineWidth',3);


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
lgndString{Counter} = ['Full'];

if ConfigurationConstants.BT
    Counter = Counter + 1;
    lgndString{Counter} = ['BT'];
end

if ConfigurationConstants.POD
    Counter = Counter + 1;
    lgndString{Counter} = ['POD'];
end

if ConfigurationConstants.BPOD
    Counter = Counter + 1;
    lgndString{Counter} = ['BPOD'];
end

% add a bit space to the figure
% fig = gcf;
% fig.Position(4) = fig.Position(4) + 400;
% add legend

lgd = legend(lgndString,'Location','SouthEast');%
%sgtitle(['Impulse Response when t = ',int2str(tInMin),'min']);
% lgnd.Position(1) = 0.3;
% lgnd.Position(2) = 0.02;

lgd.FontSize = fontsize-12;
lgd.NumColumns = 2;
%title('$h^{M} = s^2 (h_0 - r (q/s)^{\nu})$','interpreter','latex','FontSize',fontsize+7)
set(lgd,'box','off')
set(lgd,'Interpreter','Latex');
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
ylabel('Amplitude','FontSize',fontsize,'interpreter','latex')
%% enlarged part 1
h2 = subplot(1,3,2);
InterestedTime1 = floor(530/delta_t);
InterestedTime2 = floor(630/delta_t);
ranges = InterestedTime1:InterestedTime2;

Ydata = YData{1};
plot(TimeLast(ranges,:),Ydata(ranges,1),'LineWidth',4);
hold on
plot(TimeLast(ranges,:),Ydata(ranges,2),'-.','LineWidth',3.5);
hold on
plot(TimeLast(ranges,:),Ydata(ranges,3),'--','LineWidth',3);
hold on
plot(TimeLast(ranges,:),Ydata(ranges,4),'--','LineWidth',3);
xticks([530,580,630])
xticklabels({'530','580','630'})
xlim([530,630])
xlabel('Time (sec)','FontSize',fontsize,'interpreter','latex')
set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);
%% enlarged part 2
h3 = subplot(1,3,3);
InterestedTime1 = floor((40000-4000)/delta_t);
InterestedTime2 = floor(40000/delta_t);
ranges = InterestedTime1:InterestedTime2;
plot(TimeLast(ranges,:),Ydata(ranges,1),'LineWidth',4);
hold on
plot(TimeLast(ranges,:),Ydata(ranges,2),'-.','LineWidth',3.5);
hold on
plot(TimeLast(ranges,:),Ydata(ranges,3),'--','LineWidth',3);
hold on
plot(TimeLast(ranges,:),Ydata(ranges,4),'--','LineWidth',3);
xlim([(40000-4000),40000])

set(gca, 'TickLabelInterpreter', 'latex','fontsize',fontsize);


    
savedFileName = [NetworkName(1:end-4),'StepResponse_',int2str(tInMin),'min'];

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

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 16 4])
print(fig2,savedFileName,'-depsc2','-r300');
print(fig2,savedFileName,'-dpng','-r300');
close all;
end