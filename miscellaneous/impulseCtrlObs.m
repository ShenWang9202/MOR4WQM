function [impulseCtrlX,impulseObsY] = impulseCtrlObs(A,B,C,ts,numofSteps)
u = 1/ts; % note that this 10*impluse
ctrlX = B*u;
ctrlY = C*u;

impulseCtrlX = [];
impulseObsY = [];
for i = 1:numofSteps
    impulseCtrlX = [impulseCtrlX ctrlX];
    impulseObsY = [impulseObsY; ctrlY];
    ctrlX = A*ctrlX;
    ctrlY = ctrlY*A;
end
end