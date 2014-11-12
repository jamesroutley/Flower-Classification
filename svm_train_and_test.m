function [prediction_labels, accuracies, decision_values, weight_matrix] = ...
    svm_train_and_test(flower_set_number, num_test_images, ...
        training_instance_matrix, test_instance_matrix)

% initialise predictLabels, accuracies, decValues matrices
 prediction_labels = ones(flower_set_number, num_test_images);
 accuracies = ones(flower_set_number, 3);
 decision_values = ones(flower_set_number, num_test_images);
 
 % using the default 1. Will improve later
 svm_parameters = {'-c 1'; 
                   '-c 1'; 
                   '-c 1'; 
                   '-c 1'; 
                   '-c 1'};
               
% generate sparse training and test instance matrices
sparse_training_instance_matrix = sparse(training_instance_matrix);
sparse_test_instance_matrix = sparse(test_instance_matrix);

weight_matrix = zeros(flower_set_number, 4096);

for i = 1:flower_set_number
    % generate label vectors
    training_label_vector = ...
        generate_training_label_vector(flower_set_number, i);
    test_label_vector = generate_test_label_vector(flower_set_number, i);
    
    % train + test SVMs  
    addpath liblinear-1.95/matlab
    model = train(training_label_vector, ...
        sparse_training_instance_matrix, svm_parameters(i));
    weight_matrix(i,:) = model.w(:);
    [predict_label, accuracy, dec_values] = ...
        predict(test_label_vector, sparse_test_instance_matrix, model);
    rmpath liblinear-1.95/matlab
    
    % store predict_label, accuracy, dec_values
    prediction_labels(i, :) = predict_label';
    accuracies(i, :) = accuracy;
    decision_values(i, :) = dec_values'; 
end
