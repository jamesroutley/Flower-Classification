function decision_values = ...
    svm_test(flower_set_number, test_instance_matrix, weight_matrix)
%{
% generate test_instance_matrix
test_instance_matrix = zeros(size(tstid, 2), size(instance_matrix, 2));
for i = 1 : size(tstid, 2)
    test_instance_matrix(i, :) = instance_matrix(tstid(i), :);
end
%}
    
% initialise decision_values matrix
 decision_values = ones(flower_set_number, size(test_instance_matrix, 1));
 


for i = 1 : flower_set_number

    decision_value = ...
        svm_predict( test_instance_matrix, weight_matrix(i, :));
    
    
    % store decision_values
    decision_values(i, :) = decision_value'; 
end
end



% write code which calculates and returns accuracy