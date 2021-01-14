function Hankel = obtainHankelMatrix(impulseResponseY,numofInput,numofoutput,numofSteps)
% impluseResponse = C*[B A*B A^2*B A^3*B A^4*B ... A^(2*numofSteps)*B]
Hankel = zeros(numofSteps*numofoutput,numofSteps*numofInput);
for i = 1:numofSteps
    indexRange = ((i-1)*numofInput + 1):((i-1)*numofInput + numofSteps*numofInput);
    HankelRow = impulseResponseY(:,indexRange);
    %Hankel = [Hankel;HankelRow];
    indexRange = ((i-1)*numofoutput + 1):((i-1)*numofoutput + numofoutput);
    Hankel(indexRange,:) = HankelRow;
end
end