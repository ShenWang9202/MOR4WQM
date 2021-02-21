# Model ordre reduction for Water-Quality-Modeling-and-Control

This is the source code for our paper "Model Order Reduction for Water Quality Dynamics in Drinking Water Distribution Networks"

Abstract: A state-space representation of water quality dynamics describing disinfectant (e.g., chlorine) transport dynamics in drinking water distribution networks has been recently proposed. Such representation is a byproduct of space- and time-discretization of the PDE modeling transport dynamics. This results in a large state-space dimension even for small networks with tens of nodes. Although such a state-space model provides a model-driven approach to predict water quality dynamics, incorporating it into model-based control algorithms or state estimators for large networks is challenging and at times intractable.   To that end, this paper investigates model order reduction (MOR) methods for water quality dynamics. The presented investigation focuses on reducing state-dimension by orders of magnitude, the stability of the MOR methods, and the application of these methods to model predictive control.  

# How to use?

- This model is based on EPANET-Matlab-Toolkit (Version  v2.2.0-beta.2) which is a Matlab class for EPANET water distribution simulation libraries, please test this toolkit before simulation, see https://github.com/OpenWaterAnalytics/EPANET-Matlab-Toolkit#How-to-use-the-Toolkit for details.

- This model also needs the supports from SDPNAL+v1.0 and YALMIP-master when doing Stablization.

- To reproduce the results, simple go to Experiments folder, and start to exe E1_xxx.m, E2_xxx.m, ..., E7_xxx.m

  E1 and E2 are is for Network = 1; E3 is for Network = 7; E4 is for Network = 1,4,9; E5, E6, and E7 are for Network = 7?

  - Configurations for this WQMC are in ConfigurationConstants.m. For example, setting Network = 1 and ONLY_COMPARE = 0 to simulate MPC control in 3-node network; setting Network = 1 and ONLY_COMPARE = 1 to simulate Water quality simulation; The total simualtion duration is controlled by SimutionTimeInMinute = 24*60; control/prediction horizon is set by Hq_min = 5; For each experiment, you are supposed to change the network via this source file. 

  - We now only give three simple examples (3-node, Net1, and Net3), but our code is general for all kinds of networks. The readers are welcome to extend their own examples.

  - The networks in case studies are located in network/ folder

  - The code related to MPC-based Control simulation are in WQMC/MPCRelated folder,
