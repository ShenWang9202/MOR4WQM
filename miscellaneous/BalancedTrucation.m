function [sysb, r] = BalancedTrucation(sys)
HankelSigularValue = hsvd(sys); % Hankel singular values
% decide the best reduced order r according to the energy
goal = 99.995/100;
fullModeNum = size(sys.A,1);
r = ObtainModeR(fullModeNum,goal,HankelSigularValue);


%%
% Wc = gram(sys,'c'); % controllability Gramian
% Wo = gram(sys,'o'); % observability Gramian

[sysb] = balred(sys,r); % balance system
end