function ReducedX0 = ReducedModelInitialize(CurrentValue,IndexInVar,aux,ElementCount,C0,S)
NumberofX = IndexInVar.NumberofX;
MassEnergyMatrix = aux.MassEnergyMatrix;
x0 = zeros(NumberofX,1);
CurrentHead = CurrentValue.CurrentHead;
NumberofSegmentsEachPipe = aux.NumberofSegment4Pipes;
x0 = InitialConcentration(x0,C0,MassEnergyMatrix,CurrentHead,IndexInVar,ElementCount,NumberofSegmentsEachPipe);
ReducedX0 = S * x0;