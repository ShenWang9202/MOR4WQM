% Main Program to do Model reduction-based MPC control with  considering Unknown, Demand, Parameter Uncertainties

% System: Windows, Ubuntu 16.04
% Author: Shen Wang
% Date: 9/24/2020

clear all
clc
close all
%% Load EPANET MATLAB TOOLKIT
start_toolkit;


%% Set BPOD && MPC in ConfigurationConstants.m

if 0 % this needs 32G memoery


% settings
%         % select a network
%         Network = 9;% use 1 4 7 9
%         % Only do water quality simulation using LDE model and compare it
%         % with EPANET (set ONLY_COMPARE variable as 1, otherwise, set it as 0)
%         ONLY_COMPARE = 0;

%         % Control Horizen (in minutes) of MPC algorithm (must be a factor or divisor of Hydraulic Time Step, which is 60 minutes defaultly in our case studies)
%         Hq_min = 5;

%         % try BPOD method to do reduced model based MPC control.
%         BPOD = 0;
%         % if Ar from BPOD is not stable, stablize it.
%         STABLIZE_BPOD = 1;

% Then run
% no plots
No_Plots = true;
saveFileName = 'E7_Net3_MPC_full_experiment1.mat';
main_BPOD_MPC(No_Plots,saveFileName);



% Set run MPC only in ConfigurationConstants.m
% Then run the mpc on full model

% New settings
%         % try BPOD method to do reduced model based MPC control.
%         BPOD = 1;
%         % if Ar from BPOD is not stable, stablize it.
%         STABLIZE_BPOD = 1;


% no plots
No_Plots = true;
saveFileName = 'E3_Net1_MPC_BPOD_experiment1.mat';
main_BPOD_MPC(No_Plots,saveFileName);

close all;


else

% get the result from full model
load('E7_Net1_MPC_full_experiment1.mat', 'NodeID')
load('E7_Net1_MPC_full_experiment1.mat', 'X_Junction_control_result')
load('E7_Net1_MPC_BPOD_experiment1.mat', 'Location_S')
load('E7_Net1_MPC_BPOD_experiment1.mat', 'Location_B')
load('E7_Net1_MPC_BPOD_experiment1.mat', 'ControlActionU')
load('E7_Net1_MPC_BPOD_experiment1.mat', 'YY_estimated')

end

% remove the first sensor J10
Location_S = Location_S(2:end);


[~,n] = size(Location_S);
SensorIndices = [];
for i = 1:n
    % find index according to ID.
    SensorIndices = [SensorIndices findIndexByID(Location_S{i},NodeID)];
end
YY_full = X_Junction_control_result(:,SensorIndices);

% get the result from BPOD 

YY_reduced = YY_estimated';


% remove the first sensor J10
YY_reduced = YY_reduced(:,2:end);

Error = YY_reduced - YY_full;
plotL1Norm_MPC_Reduced_Full(ControlActionU,YY_reduced,Location_S,Location_B,Error);


