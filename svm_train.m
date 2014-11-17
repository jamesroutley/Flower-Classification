function [weight_matrix] = ...
    svm_train(flower_set_number, training_instance_matrix)

 % using the default 1. Will improve later
 svm_parameters = {'-c 1'; 
                   '-c 1'; 
                   '-c 1'; 
                   '-c 1'; 
                   '-c 1'};
               
% generate sparse training and test instance matrices
sparse_training_instance_matrix = sparse(training_instance_matrix);

weight_matrix = zeros(flower_set_number,size(training_instance_matrix, 2));

for i = 1:flower_set_number
    % generate label vectors
    training_label_vector = ...
        generate_label_vector(flower_set_number, i, ... 
        size(training_instance_matrix, 1) / flower_set_number);

    
    % train + test SVMs  
    addpath liblinear-1.95/matlab
    model = train(training_label_vector, ...
        sparse_training_instance_matrix, svm_parameters(i));
    
    weight_matrix(i,:) = model.w(:);
    rmpath liblinear-1.95/matlab
    

end
end
