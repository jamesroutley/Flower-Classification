
function [prediction_labels, accuracies, decision_values] = ...
    svm_train_and_test(flower_set_number, num_test_images, ...
        training_instance_matrix, test_instance_matrix)

% initialise predictLabels, accuracies, decValues matrices
 prediction_labels = ones(flower_set_number, num_test_images);
 accuracies = ones(flower_set_number, 3);
 decision_values = ones(flower_set_number, num_test_images);
 
 svm_parameters = {'-c 2.0 -g 0.0001220703125'; 
                   '-c 8.0 -g 3.0517578125e-05'; 
                   '-c 8.0 -g 0.0001220703125';
                   '-c 2.0 -g 0.0001220703125';
                   '-c 2.0 -g 0.0001220703125'};
 
for i = 1:flower_set_number
    % generate label vectors
    training_label_vector = ...
        generate_training_label_vector(flower_set_number, i);
    test_label_vector = generate_test_label_vector(flower_set_number, i);
    
    % train + test SVMs  
    addpath libsvm-3.18/matlab
    model = svmtrain(training_label_vector, ...
        training_instance_matrix, svm_parameters(i));
    [predict_label, accuracy, dec_values] = ...
        svmpredict(test_label_vector, test_instance_matrix, model);
    rmpath libsvm-3.18/matlab
    
    % store predict_label, accuracy, dec_values
    prediction_labels(i, :) = predict_label';
    accuracies(i, :) = accuracy;
    decision_values(i, :) = dec_values'; 
end
