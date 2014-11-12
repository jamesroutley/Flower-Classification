function decision_values = ...
    svm_test(flower_set_number, test_instance_matrix, weight_matrix)

% initialise predictLabels, accuracies, decValues matrices

 decision_values = ones(flower_set_number, size(test_instance_matrix, 1));

for i = 1 : flower_set_number

    decision_value = ...
        svm_predict( test_instance_matrix, weight_matrix(i, :));
    
    
    % store decision_values
    decision_values(i, :) = decision_value'; 
end
end


% write code which calculates and returns accuracy