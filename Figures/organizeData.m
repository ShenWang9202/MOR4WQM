function [OutputError_L1_inputPerspective] = organizeData(Yfull,OutputError_L1,i_output)
inputNumber = size(Yfull,3);
output_L1Norm = [];
for j = 1:inputNumber
    input_response = Yfull(:,:,j);
    input_response = abs(input_response);
    input_response = sum(input_response,2);
    output_L1Norm = [output_L1Norm input_response];
end

num_r = i_output-1;

for i = 1:num_r
    error_r = OutputError_L1{i};
    inputNumber = size(error_r,3);
    error_L1Norm = [];
    for j = 1:inputNumber
        input_response_error = error_r(:,:,j);
        input_response_error = abs(input_response_error);
        input_response_error = sum(input_response_error,2);
        error_L1Norm = [error_L1Norm input_response_error];
    end
    OutputError_L1{i} = error_L1Norm;
%     realtiveError = error_L1Norm./output_L1Norm*100;
%     % for output_L1Norm is zero, set the realtive error as zeros;
%     [zeroRow,zeroColumIndex] = find(~output_L1Norm);
%     realtiveError(zeroRow,zeroColumIndex) = 0;
    
%     OutputRelativeError_L1{i} = error_L1Norm;

%     OutputError_L1_sensor{i} = error_L1Norm(:,1:end-1);
%     OutputError_L1_init{i} = error_L1Norm(:,end);
end

inputNumber = size(OutputError_L1{1},2);
OutputError_L1_inputPerspective = cell(1,inputNumber);
for j = 1:inputNumber
    temp = [];
    for i = 1:num_r
        error = OutputError_L1{i};
        temp = [temp error(:,j)];
    end
    OutputError_L1_inputPerspective{j} = temp;
end