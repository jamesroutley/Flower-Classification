function decision_values = ...
    svm_test(flower_set_number, test_instance_matrix, weight_matrix)
    
% initialise decision_values matrix
 decision_values = ones(flower_set_number, size(test_instance_matrix, 1));

% This loop is unnecessary too...
% decision_value = test_instance_matrix * weight_matrix should do it.
% (maybe you need to transpose the matrices prior multiplication)
for i = 1 : flower_set_number

    decision_value = ...
        svm_predict( test_instance_matrix, weight_matrix(i, :));
    
    
    % store decision_values
    decision_values(i, :) = decision_value'; 
end
end
