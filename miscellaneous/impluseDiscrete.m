function [impulseResponseX,impulseResponseY] = impluseDiscrete(A,B,C,D,ts,numofSteps,outformat)
u = 1/ts;
% increasing the energy of impulse repsonse 
u = 1000 * u;
% Dimension checking
n = size(A,1);
% need to minus 
temp = B*u;
nu = size(B,2);


% Allocate impulseObsX and compute each A^k B term
impulseResponseX = zeros(n,numofSteps*nu);

impulseResponseX(:,1:nu) = temp;
for k=1:numofSteps - 1
    temp = A * temp;
    impulseResponseX(:,k*nu+1:(k+1)*nu) = temp;
end

impulseResponseY = C *u * impulseResponseX;
if(outformat)
    % orangize the data according to the input and output format
    [~,nu] = size(B);
    [nc,~] = size(C);
    yfull_my = zeros((numofSteps),nc,nu);
    impulseResponseY = impulseResponseY';
    for i = 1:nu
        yfull_my(:,:,i) = impulseResponseY(i:nu:end,:);
    end
    impulseResponseY = yfull_my;
end

end