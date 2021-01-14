classdef ConfigurationConstants
    properties( Constant = true )
        
        % select a network
        Network = 1;% use 1  7 9
        % Only do water quality simulation using LDE model and compare it
        % with EPANET (set ONLY_COMPARE variable as 1, otherwise, set it as 0)
        ONLY_COMPARE = 1;
        % REDUCE_MODEL = 0: use full model to do MPC control.
        % REDUCE_MODEL = 1: use reduced model to do MPC control.
        
        % try BT method to do reduced model based MPC control.
        BT = 1;
        
        % try POD method to do reduced model based MPC control.
        POD = 1;
        % if Ar from POD is not stable, stablize it.
        STABLIZE_POD = 1;
        
        % try BPOD method to do reduced model based MPC control.
        BPOD = 1;
        % if Ar from BPOD is not stable, stablize it.
        STABLIZE_BPOD = 1;
        
        % if BT, POD, BPOD are all set as zeros, then we defaultly use full model to do MPC control.
        
        SimutionTimeInMinute = 24*60;
        %SimutionTimeInMinute = 4*24*60; % Simulate Net1 for 4 day
        SimutionTimeInMinute4RBC = 24*60;
        % Interval (in minutes) of injecting chlorin from boosters (must be a factor or divisor of Hq_min)
        T_booster_min = 1;
        % Control Horizen (in minutes) of MPC algorithm (must be a factor or divisor of Hydraulic Time Step, which is 60 minutes defaultly in our case studies)
        Hq_min = 20;
        % How many segements of a pipe. This is deprecated; see
        % GenerateSegments4Pipes.m for details.
        NumberofSegment = 100;
        
        % setting up a solver to solve the SDP problem stabilizing Ar from
        % BPOD
        solver = 'sdpnal+'; % 'cvx'
        
        % The price of injecting chlorine,
        Price_Weight = 0.001;
        % The setpoint or reference of chlorin concentration in WDNs (any value between 0.4~4mg/L);
        reference = 0.6;
        % Q coefficent is an index of pushing the concentration in links
        % and nodes to the reference value
        Q_coeff = 1;
        % R coefficent is an index of controlling the smoothness of control
        % actions
        R_coeff = 3;

%         for 3node network
%         reference = 2;
%         Q_coeff = 2;
%         R_coeff = 3;
        
%         for 8node network
%         reference = 1;
%         Q_coeff = 2;
%         R_coeff = 3;

%         for net1 network
%         reference = 1.5;
%         Q_coeff = 4;
%         R_coeff = 1;
        
        
        DayInSecond = 86400;
        MinInSecond = 60;
        Gallon2Liter = 3.78541;
        FT2Inch = 12;
        pi = 3.141592654;
        GPMperCFS= 448.831;
        AFDperCFS= 1.9837;
        MGDperCFS= 0.64632;
        IMGDperCFS=0.5382;
        LPSperCFS= 28.317;
        M2FT = 3.28084;
        LPS2GMP = 15.850372483753;
        LPMperCFS= 1699.0;
        CMHperCFS= 101.94;
        CMDperCFS= 2446.6;
        MLDperCFS= 2.4466;
        M3perFT3=  0.028317;
        LperFT3=   28.317;
        MperFT=    0.3048;
        PSIperFT=  0.4333;
        KPAperPSI= 6.895;
        KWperHP=   0.7457;
        SECperDAY= 86400;
        SpecificGravity = 1;
    end
end
