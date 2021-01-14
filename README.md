# Model ordre reduction for Water-Quality-Modeling-and-Control

This is the source code for our paper "Model Order Reduction for Water Quality Dynamics in Drinking Water Distribution Networks"

Abstract: A state-space representation of water quality dynamics is used to describe the time evolution of disinfectant (e.g., chlorine) concentration in drinking water distribution networks. The complexity of water quality dynamics often results in a high state-space dimension. Therefore, the direct utilization of chlorine transport dynamics is rendered computationally prohibitive. Consequently, incorporating high-dimensional state-space models into model-based control algorithms or state estimators becomes challenging, and at times, intractable. This paper studies, for the first time: (i) the effectiveness of state-of-the-art model order reduction (MOR) methods that reduce the dimensionality of the state-space to a computationally tractable order, (ii) proposes two stabilization methods to obtain a stable reduced-order model that can enable high-speed, large-scale simulations of chlorine transport without requiring prohibitive computational resources, and (iii) an efficient implementation of model predictive control (MPC) is described, which leverages reduced-order model to allow fast control update computations. Realistic case studies are provided using EPANET benchmark (i.e., Net1 and Net3 networks). The simulation results demonstrate that MOR methodologies are effective in reducing the model order for Net1 (Net3) networks from 1293 (29374) states to 129 (491) states without significant loss in prediction accuracy, the reduced-order models are stable using our proposed methods, and that closing the loop with performance-optimizing controllers such as MPC yields maximum 0.028% relative error compared to a full-order model implementation

# How to use?

- This model is based on EPANET-Matlab-Toolkit (Version  v2.2.0-beta.2) which is a Matlab class for EPANET water distribution simulation libraries, please test this toolkit before simulation, see https://github.com/OpenWaterAnalytics/EPANET-Matlab-Toolkit#How-to-use-the-Toolkit for details.

- This model also needs the supports from SDPNAL+v1.0 and YALMIP-master when doing Stablization.

- To reproduce the results, simple go to Experiments folder, and start to exe E1_xxx.m, E2_xxx.m, ..., E7_xxx.m

  E1 and E2 are is for Network = 1; E3 is for Network = 7; E4 is for Network = 1,4,9; E5, E6, and E7 are for Network = 7?

  - Configurations for this WQMC are in ConfigurationConstants.m. For example, setting Network = 1 and ONLY_COMPARE = 0 to simulate MPC control in 3-node network; setting Network = 1 and ONLY_COMPARE = 1 to simulate Water quality simulation; The total simualtion duration is controlled by SimutionTimeInMinute = 24*60; control/prediction horizon is set by Hq_min = 5; For each experiment, you are supposed to change the network via this source file. 

  - We now only give three simple examples (3-node, Net1, and Net3), but our code is general for all kinds of networks. The readers are welcome to extend their own examples.

  - The networks in case studies are located in network/ folder

  - The code related to MPC-based Control simulation are in WQMC/MPCRelated folder,
