function decision_value = svm_predict( test_instance_matrix, weight_vector)

weight_vector = weight_vector';
decision_value = zeros(size(test_instance_matrix, 1), 1);

for i = 1 : size(test_instance_matrix, 1)
    decision_value(i) = test_instance_matrix(i, :) * weight_vector;
end
