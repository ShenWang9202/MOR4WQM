function [impulseCtrlX,impulseObsY] = impulseCtrlObs_Acc(A,B,C,ts,numofSteps)
% Acceleration for impulseCtrlObs
u = 1/ts; % note that this 10*impluse

% Dimension checking
n  = size(A,1);
ny = size(C,1);
nu = size(B,2);

% Allocate impulseObsX and compute each A^k B term
impulseCtrlX = zeros(n,numofSteps*nu);
temp = B*u;
impulseCtrlX(:,1:nu) = temp;
for k=1:numofSteps - 1
    temp = A * temp;
    impulseCtrlX(:,k*nu+1:(k+1)*nu) = temp;
end

% This is slow

% % Allocate impulseCtrlY and compute each C A^k term
% impulseObsY = zeros(n*ny,n);
% impulseObsY(1:ny,:) = C*u;
% for k=1:numofSteps - 1
%   impulseObsY(k*ny+1:(k+1)*ny,:) = impulseObsY((k-1)*ny+1:k*ny,:) * A;
% end

% Much faster

% Allocate impulseCtrlY and compute each C A^k term
impulseObsY = zeros(n,numofSteps*ny);
temp = C'*u;
impulseObsY(:,1:ny) = temp;
Atranspose = A';
for k=1:numofSteps - 1
    temp = Atranspose * temp;
    impulseObsY(:,k*ny+1:(k+1)*ny) = temp;
end

impulseObsY = impulseObsY';

end