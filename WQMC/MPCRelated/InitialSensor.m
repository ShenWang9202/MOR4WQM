function SensorIndex = InitialSensor(Location_S,NodeID)
[~,nB] = size(Location_S);
SensorIndex = [];
for i = 1:nB
    index = findIndexByID(Location_S{i},NodeID);
    SensorIndex = [SensorIndex index];
end
end