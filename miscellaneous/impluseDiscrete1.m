function impulseResponseY = impluseDiscrete1(A,B,C,D,ts,numofSteps)
u = 1/ts;
% Dimension checking
n = size(A,1);
% need to minus 
temp = B*u;
nu = size(B,2);
ny = size(C,1);

% Allocate impulseObsX and compute each A^k B term
impulseResponseY = zeros(numofSteps*ny,nu);

impulseResponseY(1:ny,:) = C*u*temp;
for k=1:numofSteps - 1
    temp = A * temp;
    impulseResponseY(k*ny+1:(k+1)*ny,:) = C*u*temp;
end
end