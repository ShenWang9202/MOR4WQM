% Main Program to do Model reduction-based MPC control with  considering Unknown, Demand, Parameter Uncertainties

% System: Windows, Ubuntu 16.04
% Author: Shen Wang
% Date: 9/24/2020

clear all
clc
close all
%% Load EPANET MATLAB TOOLKIT
start_toolkit;

% check this example Toolkit_EX3_Minimum_chlorine_residual.m
%% run EPANET MATLAB TOOLKIT to obtain data

% Demand uncertainty on or off
DEMAND_UNCERTAINTY = 0;
Demand_Unc = 0.1;
% Unknown uncertainty on or off
UNKNOW_UNCERTAINTY = 0;
% Parameter uncertainty on or off

PARAMETER_UNCERTAINTY = 0;
Kb_uncertainty = 0.1;
Kw_uncertainty = 0.1;

COMPARE = ConfigurationConstants.ONLY_COMPARE;
if(COMPARE == 1) % when compare LDE with EPANET, We have to make all uncertainty disappear
    PARAMETER_UNCERTAINTY = 0;
    UNKNOW_UNCERTAINTY = 0;
    DEMAND_UNCERTAINTY = 0;
end

Network = ConfigurationConstants.Network;
switch Network
    case 1
        % Quality Timestep = 1 min, and  Global Bulk = -0.3, Global Wall= -0.0
        % NetworkName = 'Threenode-cl-2-paper.inp'; pipe flow direction
        % never changed, and the result is perfectly matched with EPANET
        %NetworkName = 'Threenode-cl-3-paper.inp'; % Pipe flow direction changes
        NetworkName = 'Threenode-cl-2-MOR.inp'; % topogy changes
        %NetworkName = 'Threenode-cl-2-paper.inp'; % topogy changes
        Unknown_Happen_Time = 200;
        PipeID_Cell = {'P1'};
        JunctionID_Cell = {'J2'};
        Sudden_Concertration = 1.0; % Suddenly the concentration jumps to this value for no reason
        filename = 'Three-node_1day.mat';
    case 4
        % Quality Timestep = 1 min, and  Global Bulk = -0.3, Global Wall=
        % -0.0; initial value: J2 = 0.5 mg/L, J6 = 1.2 mg/L, R1 = 0.8 mg/L;
        % segment = 1000;
        NetworkName = 'tutorial8node1inital.inp';
        %         NetworkName = 'tutorial8node1inital2.inp';
        filename = '8node_1day.mat';
    case 7
        % Quality Timestep = 1 min, and  Global Bulk = -0.3, Global Wall= -0.0
        NetworkName = 'Net1-1min-new-demand-pattern.inp';
        Unknown_Happen_Time = 3000; % Unknow Disturbance happened at the 3000-th minutes
        PipeID_Cell = {'P11','P21','P31'};
        JunctionID_Cell = {'J11','J21','J31'};
        Sudden_Concertration = 0.5;
        filename = 'Net1_4days.mat';
    case 9
        %NetworkName = 'Net3-NH2CL-24hour-4.inp'; % this is used to test the topology changes
        NetworkName = 'Net3-NH2CL-24hour-modified.inp'; % 'Net3-NH2CL-24hour-zerovelocity.inp';%
        filename = 'Net3_1day.mat';
    otherwise
        disp('other value')
end
%% Prepare constants data for MPC
PrepareData4Control

%% initialize concentration at nodes

% initialize BOOSTER
% flow of Booster, assume we put booster at each nodes, so the size of it
% should be the number of nodes.
nodeCount = ElementCount.nodeCount;
NodeIndex = d.getNodeIndex;
LinkIndex = nodeCount+d.getLinkIndex;
NodeID = Variable_Symbol_Table2(NodeIndex,1);
LinkID = Variable_Symbol_Table2(LinkIndex,1);

PipeID = Variable_Symbol_Table2(PipeIndexInOrder,1);
JunctionID = Variable_Symbol_Table2(JunctionIndexInOrder,1);

switch Network
    case 1
        Location_B = {'J2'}; % NodeID here;
        flowRate_B = 10*ones(size(Location_B)); % unit: GPM
        Price_B = ones(size(Location_B));
        % the C_B is what we need find in MPC, useless here
        %C_B = [1]; % unit: mg/L % Concentration of booster
        Location_S = {'T3'};
        TargetedPipeID = [];%PipeID([2,4,6,8]);
        POD_Steps = 1000;
        DurationofResponseTested = 4000; %in seconds
        EnergyPercentageGoal_BT = 99.99999999995/100;
        EnergyPercentageGoal_BPOD = 99.9999995/100;
        EnergyPercentageGoal_POD = 99.99999/100;
    case {2,3,4}
        Location_B = {'J2','J7'}; % NodeID here;
        flowRate_B = 10*ones(size(Location_B)); % unit: GPM
        Price_B = ones(size(Location_B));
        Location_S = {'J2','J6','J7'};
        TargetedPipeID = [];% PipeID([2]); % TRY [], PipeID([2]) PipeID([2,4,6]) PipeID([3,5,7])
        POD_Steps = 5500;
        DurationofResponseTested = 40000; %in seconds
        EnergyPercentageGoal_BT = 99.999999999995/100;
        EnergyPercentageGoal_BPOD = 99.999999/100;
        EnergyPercentageGoal_POD = 99.999999/100;
    case {5,6,7}
        Location_B = {'J10'}; % NodeID here;
        flowRate_B = 10*ones(size(Location_B)); % unit: GPM
        Price_B = ones(size(Location_B));
        Location_S = {'J22','J23'};
        TargetedPipeID = [];%PipeID([2,4,6,8]);
        POD_Steps = 8000;
        DurationofResponseTested = 80000; %in seconds
        EnergyPercentageGoal_BT = 99.995/100;
        EnergyPercentageGoal_BPOD = 99.995/100;
        EnergyPercentageGoal_POD = 99.9999995/100;
    case 8
        Location_B = {'J2'}; % NodeID here;
        flowRate_B = [100]; % unit: GPM
        Price_B = [1];
    case 9
        Location_B = {'J237','J247'}; % NodeID here;
        Location_S = {'J255','J241','J249'};
        flowRate_B = 10*ones(size(Location_B)); % unit: GPM
        Price_B = ones(size(Location_B));
        TargetedPipeID = [];%PipeID;
        POD_Steps = 14000;
        DurationofResponseTested = 800; %in seconds
        EnergyPercentageGoal_BT = 99.999999999995/100;
        EnergyPercentageGoal_BPOD = 99.99999/100;
        EnergyPercentageGoal_POD = 99.999999/100;
    otherwise
        disp('other value')
end

%[q_B,C_B] = InitialBoosterFlow(nodeCount,Location_B,flowRate_B,NodeID,C_B);
Price_B1 = Price_B';
[q_B,Price_B,BoosterLocationIndex,BoosterCount] = InitialBooster(nodeCount,Location_B,flowRate_B,NodeID,Price_B);
SensorIndex = InitialSensor(Location_S,NodeID);

% Get the flow rate and head when use demand without uncertainty
HydraulicInfoWithoutUncertainty =[];
if DEMAND_UNCERTAINTY
    HydraulicInfoWithoutUncertainty = ObtainNetworkHydraulicInfoWithoutUncertainty(d);
end

% Compute Quality without MSX
% (This function contains events) Don't uncomment this commands!!! Crash
% easily
qual_res = d.getComputedQualityTimeSeries; %Value x Node, Value x Link
LinkQuality = qual_res.LinkQuality;
NodeQuality = qual_res.NodeQuality;

% Initial Concentration
C0 = [NodeQuality(1,:) LinkQuality(1,:)];

% add uncertainty to the network
NodeJunctionIndex = d.getNodeJunctionIndex;
NodePatternIndex = d.getNodePatternIndex;
JunctionPatternIndex = NodePatternIndex(NodeJunctionIndex);
UniqueJunctionPatternIndex = unique(JunctionPatternIndex);

% get junction patterns
Patterns = d.getPattern;
JunctionPattern = Patterns(UniqueJunctionPatternIndex,:);

% generate new pattern with uncertainty
JunctionPattern_Uncertainty = add_uncertainty(JunctionPattern,Demand_Unc);

% Set Pattern needs pattern index and the corresponding pattern.
% for example, we need the Junction 2's index is 2, and the correpsonding
% Pattern index is 1. If we want to set Junction 2's new pattern, then just
% setPattern(1,newpattern)

if DEMAND_UNCERTAINTY
    d.setPattern(UniqueJunctionPatternIndex,JunctionPattern_Uncertainty);
end

%% Construct aux struct
%'NumberofSegment',NumberofSegment,...
aux = struct('NumberofSegment4Pipes',NumberofSegment4Pipes,...
    'LinkLengthPipe',LinkLengthPipe,...
    'LinkDiameterPipe',LinkDiameterPipe,...
    'TankBulkReactionCoeff',TankBulkReactionCoeff,...
    'TankMassMatrix',TankMassMatrix,...
    'JunctionMassMatrix',JunctionMassMatrix,...
    'MassEnergyMatrix',MassEnergyMatrix,...
    'flowRate_B',flowRate_B,...
    'q_B',q_B,...
    'Price_B',Price_B1,...,
    'BoosterLocationIndex',BoosterLocationIndex,...,
    'SensorIndex',SensorIndex,...,
    'BoosterCount',BoosterCount,...,
    'NodeNameID',{NodeNameID},...
    'LinkNameID',{LinkNameID},...
    'NodeID',{NodeID},...
    'LinkID',{LinkID},...
    'TargetedPipeID',{TargetedPipeID},...
    'NodesConnectingLinksID',{NodesConnectingLinksID},...
    'COMPARE',COMPARE);
%    'Price_B',Price_B,...,

%% Start MPC control

T = [];
Head = [];
Flow = [];
UeachMin = [];
NpMatrix = [];
Magnitude = [];
X_estimated = [];
QsN_Control = [];
QsL_Control = [];
XX_estimated = [];
YY_estimated = [];
ControlActionU = [];
U_C_B_eachStep = [];
PreviousDelta_t = [];
NodeSourceQuality = [];
ControlActionU_LDE = [];
JunctionActualDemand = [];
UeachIntervalforEPANET = [];
PreviousSystemDynamicMatrix = [];
Y_estimated_reduced = [];
PreviousSystemDynamicMatrix_reduced = [];
VelocityPipe = [];

All_A = cell(1,24*60/5);
Acounter = 1;

Fullmodel = [];
BTmodel = [];
PODmodel = [];
BPODmodel = [];
AllTime = [];


MODELREDUCTION = (ConfigurationConstants.BT || ConfigurationConstants.POD || ConfigurationConstants.BPOD);

Hq_min = ConfigurationConstants.Hq_min;% I need that all concention 5 minutes later are  in 0.2 mg 4 mg
T_booster_min = ConfigurationConstants.T_booster_min; % Booster station inject chlorin each 2 minutes.
SimutionTimeInMinute = ConfigurationConstants.SimutionTimeInMinute;

PreviousValue = struct('PreviousDelta_t',PreviousDelta_t,...
    'PreviousSystemDynamicMatrix',PreviousSystemDynamicMatrix,...
    'PreviousSystemDynamicMatrix_reduced',PreviousSystemDynamicMatrix_reduced,...
    'X_estimated',X_estimated,...
    'Y_estimated_reduced',Y_estimated_reduced,...
    'U_C_B_eachStep',0,...
    'UeachIntervalforEPANET',0);

d.openHydraulicAnalysis;
d.openQualityAnalysis;
d.initializeHydraulicAnalysis;
d.initializeQualityAnalysis;

tleft = 1;
tInMin = 0;
delta_t = 0;

if DEMAND_UNCERTAINTY
    % load the head, flow, and velocity without uncertainty
    HeadWithoutUncertainty = HydraulicInfoWithoutUncertainty.Head;
    FlowWithoutUncertainty = HydraulicInfoWithoutUncertainty.Flow;
    VelocityPipeWithoutUncertainty = HydraulicInfoWithoutUncertainty.Velocity;
end

% profile on
tic
while (tleft > 0 && tInMin < SimutionTimeInMinute && delta_t <= 60)
    t1 = d.runHydraulicAnalysis;
    t=d.runQualityAnalysis;
    
    % Obtain the actual Concentration
    QsN_Control=[QsN_Control; d.getNodeActualQuality];
    QsL_Control=[QsL_Control; d.getLinkActualQuality];
    Head=[Head; d.getNodeHydaulicHead];
    Flow=[Flow; d.getLinkFlows];
    TempDemand = d.getNodeActualDemand;
    JunctionActualDemand = [JunctionActualDemand; TempDemand(NodeJunctionIndex)];
    
    % Calculate Control Action
    tInMin = t/60;
    if(mod(tInMin,Hq_min) == 0)
        % 5 miniute is up, Calculate the New Control Action
        disp('Current time')
        tInMin
        tInHour = tInMin/60;
        
        if DEMAND_UNCERTAINTY
            CurrentVelocity = VelocityPipeWithoutUncertainty(tInMin + 1,:);
        else
            CurrentVelocity = d.getLinkVelocity;
        end
        
        CurrentVelocityPipe = CurrentVelocity(:,PipeIndex);
        VelocityPipe = [VelocityPipe; CurrentVelocityPipe];
        if PARAMETER_UNCERTAINTY
            Kb_all = add_uncertainty(Kb_all, Kb_uncertainty);
            Kw_all = add_uncertainty(Kw_all, Kw_uncertainty);
        end
        PipeReactionCoeff = CalculatePipeReactionCoeff(CurrentVelocityPipe,LinkDiameterPipe,Kb_all,Kw_all,PipeIndex);
        % the minium step length for all pipes
        delta_t = LinkLengthPipe./NumberofSegment4Pipes./CurrentVelocityPipe;
        delta_t = min(delta_t);
        delta_t = MakeDelta_tAsInteger(delta_t)
        
        if DEMAND_UNCERTAINTY
            % Because tInmin starts from 0, but matlab's index is from 1, so we need to add 1 here
            CurrentFlow = FlowWithoutUncertainty(tInMin + 1,:);
            CurrentHead = HeadWithoutUncertainty(tInMin + 1,:);
        else
            CurrentFlow = d.getLinkFlows;
            CurrentHead = d.getNodeHydaulicHead;
        end
        
        Volume = d.getNodeTankVolume;
        CurrentNodeTankVolume = Volume;
        CurrentHead = d.getNodeHydaulicHead;
        
        % Estimate Hp of concentration; basciall 5 mins = how many steps
        SetTimeParameter = Hq_min*ConfigurationConstants.MinInSecond/delta_t;
        Np = round(SetTimeParameter)
        NpMatrix = [NpMatrix Np];
        %Np = floor(SetTimeParameter) + 1;
        
        % Collect the current value
        CurrentValue = struct('CurrentVelocityPipe',CurrentVelocityPipe,...
            'CurrentNodeTankVolume',CurrentNodeTankVolume,...
            'CurrentFlow',CurrentFlow,...
            'CurrentHead',CurrentHead,...
            'delta_t',delta_t,...
            'PipeReactionCoeff',PipeReactionCoeff,...
            'Np',Np);


        ReductionParameter = struct('POD_Steps',POD_Steps,...
            'NetworkName',NetworkName,...
            'DurationofResponseTested',DurationofResponseTested,...
            'delta_t',delta_t,...
            'EnergyPercentageGoal_BT',EnergyPercentageGoal_BT,...
            'EnergyPercentageGoal_POD',EnergyPercentageGoal_POD,...
            'EnergyPercentageGoal_BPOD',EnergyPercentageGoal_BPOD);

        % Esitmate the concentration in all elements according to the
        % system dynamics each 5 mins
        
        xx_estimated = EstimateState_XX_SaveMem(CurrentValue,IndexInVar,aux,ElementCount,q_B,tInMin,C0,PreviousValue);
        x_estimated = xx_estimated(:,end);
        
        % Store the estimated value for future use
        % This is every 5 miutes, that is, the 5-th mins, for control
        % purpose
        %X_estimated = [X_estimated x_estimated];
        % This is every 1 minute, that is, all 5 mins, for records purpose
        XX_estimated = [XX_estimated xx_estimated];
        
        PreviousSystemDynamicMatrix = ObtainSystemDynamic(CurrentValue,IndexInVar,aux,ElementCount);
        y_estimated = PreviousSystemDynamicMatrix.C * x_estimated;
        
        %X0 = 0;
        if(MODELREDUCTION)
            if (tInMin == 0)
                yy_estimated_reduced = PreviousSystemDynamicMatrix.C * x_estimated;
            else
                yy_estimated_reduced = EstimateState_YY_Reduced_SaveMem(CurrentValue,IndexInVar,aux,ElementCount,q_B,tInMin,C0,PreviousValue);
            end
            
            y_estimated = yy_estimated_reduced(:,end);
            YY_estimated = [YY_estimated yy_estimated_reduced];
            
            tempA = PreviousSystemDynamicMatrix.A;
            tempB = PreviousSystemDynamicMatrix.B;
            tempC = PreviousSystemDynamicMatrix.C;
            tempD = PreviousSystemDynamicMatrix.D;
            FullSystemModel = PreviousSystemDynamicMatrix;
            
            % we haven't consider the non-zero intial condition for POD yet, so
            % cannot compare this between POD and BPOD, to do later.
            
            if(~all(x_estimated == 0)) % if initial vector X0 is not all zero, then we need to agument our system, only B is updated
                % original system
                FullSystemModel.B = [tempB tempA*x_estimated*delta_t];
                FullSystemModel.D = [tempD tempC*x_estimated*delta_t];
            end
            
            profile on
            [sysFull,ReducedsystemMatrix_BT,ReducedsystemMatrix_POD,ReducedsystemMatrix_BPOD,timeCost] = ModelReduction_accuracy_nonzero(FullSystemModel,ReductionParameter,tInMin);
            Fullmodel = [Fullmodel sysFull];
            BTmodel = [BTmodel ReducedsystemMatrix_BT];
            PODmodel = [PODmodel ReducedsystemMatrix_POD];
            BPODmodel = [BPODmodel ReducedsystemMatrix_BPOD];
            AllTime = [AllTime timeCost];
            
            profile viewer
            if ConfigurationConstants.BT
                ReducedsystemMatrix = ReducedsystemMatrix_BT;
            end
            
            if ConfigurationConstants.POD
                ReducedsystemMatrix = ReducedsystemMatrix_POD;
            end
            
            if ConfigurationConstants.BPOD
                ReducedsystemMatrix = ReducedsystemMatrix_BPOD;
            end
            
            PreviousSystemDynamicMatrix_reduced = ReducedsystemMatrix;
        end
        
        if ~COMPARE % Not only compare with EPANET, that is, do MPC control
            % Calculate all of the control actions at each min
            [UeachIntervalforEPANET,U_C_B_eachStep] = ApplyMPC(PreviousSystemDynamicMatrix,PreviousSystemDynamicMatrix_reduced,Np,y_estimated,PreviousValue,aux,delta_t,MODELREDUCTION);
            % Save control actions and apply it to EPANET software
            ControlActionU = [ControlActionU; UeachIntervalforEPANET'];
            % Save control actions and apply it to OUR LDE model
            ControlActionU_LDE = [ControlActionU_LDE; U_C_B_eachStep'];
        end
        
        PreviousDelta_t = [PreviousDelta_t delta_t];
        PreviousValue.PreviousDelta_t = delta_t;
        PreviousValue.X_estimated = xx_estimated(:,end);
        
        if MODELREDUCTION % using reduced model
            PreviousValue.Y_estimated_reduced = yy_estimated_reduced(:,end);
            PreviousValue.PreviousSystemDynamicMatrix_reduced = PreviousSystemDynamicMatrix_reduced;
        end
        
        PreviousValue.PreviousSystemDynamicMatrix = PreviousSystemDynamicMatrix;
        PreviousValue.U_C_B_eachStep = U_C_B_eachStep;
        PreviousValue.UeachIntervalforEPANET = UeachIntervalforEPANET;
    end
    
    % Apply Control action
    if(tInMin > 0 && ~COMPARE && mod(tInMin,T_booster_min) == 0)
        % Set booster type as mass booster
        for booster_i = 1:BoosterCount
            d.setNodeSourceType(BoosterLocationIndex(booster_i),'MASS'); %Junction2's index is 1; we set it as mass booster
        end
        
        TmpNodeSourceQuality = d.getNodeSourceQuality;
        NodeSourceQuality = [NodeSourceQuality; TmpNodeSourceQuality];
        intervalIndex = tInMin/T_booster_min;
        TmpNodeSourceQuality = ControlActionU(intervalIndex,:)/T_booster_min; %1 is the index of junction 2
        %applycounter = applycounter + 1;
        for booster_i = 1:BoosterCount
            indBooster = BoosterLocationIndex(booster_i);
            SourceQualityValue = TmpNodeSourceQuality(booster_i);
            d.setNodeSourceQuality(indBooster,SourceQualityValue);
        end
    end
    
    T=[T; t];
    tstep1 = d.nextHydraulicAnalysisStep;
    tstep = d.nextQualityAnalysisStep;
end
runningtime = toc
d.closeQualityAnalysis;
d.closeHydraulicAnalysis;
% p = profile('info')
% save myprofiledata p
% profile viewer
%% Start to plot
disp('Done!! Start to organize data')
disp('Summary:')
disp(['Compare is: ',num2str(COMPARE)]);
disp(['Demand uncertainty is: ',num2str(DEMAND_UNCERTAINTY)]);
disp(['Unknown uncertainty is: ',num2str(UNKNOW_UNCERTAINTY)]);
disp(['Parameter uncertainty is: ',num2str(PARAMETER_UNCERTAINTY)]);
disp(['NumberofSegment4Pipes is: '])
NumberofSegment4Pipes

disp('Done!! Start to organize data')


figure
plot(JunctionActualDemand)
xlabel('Time (minute)')
ylabel('Demand at junctions (GPM)')
legend(NodeID)

figure
plot(Flow)
legend(LinkID)
xlabel('Time (minute)')
ylabel('Flow rates in links (GPM)')

figure
plot(YY_estimated');
legend(Location_S);
xlabel('Time (minute)');
ylabel('Concentration at sensors (MOR result)');

% plot comparsion results between EPANET and LDE
plotComparsion
% plot control action obtained from MPC algorithm
if ~COMPARE
    plotControlAction
end

% plot imagine of segment concentration of intested pipe
InterestedID = [];
switch Network
    case 1
        InterestedID = LinkID(PipeIndex)';
    case 4
        InterestedID = LinkID(PipeIndex)';
    case 7
        InterestedID = LinkID(PipeIndex)';
    case 9
        InterestedID =  {'P245','P247','P249'}; % LinkID(PipeIndex)' ;%
    otherwise
        disp('other value')
end
plotImaginesc4InterestedComponents(XX_estimated,Pipe_CStartIndex,NumberofSegment4Pipes,InterestedID,LinkID);
save(filename,'NetworkName','Fullmodel','BTmodel','PODmodel','BPODmodel','AllTime','Location_S','Location_B','NumberofSegment4Pipes','Variable_Symbol_Table2','YY_estimated','X_Junction_control_result')

