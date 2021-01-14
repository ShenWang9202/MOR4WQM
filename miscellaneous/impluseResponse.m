function [impulseResponseX,impulseResponseY] = impluseResponse(A,B,C,D,ts,numofSteps,X0,outformat)
% n_temp = size(B,2);
% u = 1/ts*ones(n_temp,1);
% % x = B*u;
% % impulseResponseX = zeros(size(B));
% % for i = 1:numofSteps - 1
% %     impulseResponseX = [impulseResponseX x ];
% %     x = A*x;
% % end
% 
% % Dimension checking
% n = size(A,1);
% % need to minus 
% temp = B*u;
% n_temp = size(temp,2);

nu = size(B,2);
u = 1/ts*eye(nu);
% Dimension checking
n = size(A,1);
% need to minus 
temp = B*u;

% Allocate impulseObsX and compute each A^k B term
impulseResponseX = zeros(n,numofSteps*nu);
for k=0:numofSteps -1
    impulseResponseX(:,k*nu+1:(k+1)*nu) = temp;
    temp = A * temp;
end

impulseResponseY = C * impulseResponseX;
% add first step
impulseResponseY = [D * u impulseResponseY];

InitialY = C*X0;
InitialY = repmat(InitialY,1,numofSteps);
if(outformat)
    % orangize the data according to the input and output format
    [~,nu] = size(B);
    [nc,~] = size(C);
    yfull_my = zeros((numofSteps+1),nc,nu);
    impulseResponseY = impulseResponseY';
    for i = 1:nu
        yfull_my(:,:,i) = impulseResponseY(i:nu:end,:);
    end
    impulseResponseY = yfull_my;
end

end