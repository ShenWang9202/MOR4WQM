% Main Program to do Model reduction-based MPC control with  considering Unknown, Demand, Parameter Uncertainties

% System: Windows, Ubuntu 16.04
% Author: Shen Wang
% Date: 9/24/2020

clear all
clc
close all
%% Load EPANET MATLAB TOOLKIT
start_toolkit;

if 1
    PODStep_Settings = 2350; % 2650 is just right.
    fullResponse = true;
    stablization = false;
    
    [Yfull,YBPOD_unstable,delta_t] = stabilityMain(PODStep_Settings,fullResponse,stablization);
    
    PODStep_Settings = 2350;
    fullResponse = false;
    stablization = true;
    [~,YBPOD_postStabilized,~] = stabilityMain(PODStep_Settings,fullResponse,stablization);
    
    
    PODStep_Settings = 8000;
    fullResponse = false;
    stablization = false; % This is just in case option. Don't use posterior stablization
    [~,YBPOD_prioriStabilized,~] = stabilityMain(PODStep_Settings,fullResponse,stablization);
    
    %%
    Ydata = struct('Yfull',Yfull,...
        'YBPOD_unstable',YBPOD_unstable,...
        'YBPOD_postStabilized',YBPOD_postStabilized,...
        'YBPOD_prioriStabilized',YBPOD_prioriStabilized);
else
    load('E5_stability_experiment_data_2400.mat')
end
plotStablization(Ydata,delta_t);

%% find the poles.

% stop at Line 357 in stabilityMain file, and find FullSystemModel, the exe
% the following commands

% A = FullSystemModel.A
% [V,D] = eig(full(A));
% D = diag(D)
% scatter(real(D),imag(D))
% D1 = D;
% 
% absD = abs(D);
% 
% Final = [D,absD]
% [va,I] = maxk(absD,4)
% 
% -4/log(0.9983)



