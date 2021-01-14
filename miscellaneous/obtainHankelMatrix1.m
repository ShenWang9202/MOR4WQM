function Hankel1 = obtainHankelMatrix1(impulseResponseY,numofInput,numofoutput,numofSteps)
% impluseResponse = [CB; CAB; CA^2*B; CA^3*B; C*A^4*B; ... C*A^(2*numofSteps)*B]
Hankel1 = zeros(numofSteps*numofoutput,numofSteps*numofInput);
for i = 1:numofSteps
    indexRange = ((i-1)*numofoutput + 1):((i-1)*numofoutput + numofSteps*numofoutput);
    HankelColumn = impulseResponseY(indexRange,:);
    indexRange = ((i-1)*numofInput + 1):((i-1)*numofInput + numofInput);
    Hankel1(:,indexRange) = HankelColumn;
end
end