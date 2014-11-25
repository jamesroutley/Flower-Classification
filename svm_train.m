function [weight_matrix] = ...
    svm_train(flower_set_number, training_instance_matrix)

 % using the default 1. Will improve later
 svm_parameters = {'-c 1'; 
                   '-c 1'; 
                   '-c 0.001'; 
                   '-c 1'; 
                   '-c 0.0001'};
               
% generate sparse training and test instance matrices
sparse_training_instance_matrix = sparse(training_instance_matrix);

weight_matrix = zeros(flower_set_number,size(training_instance_matrix, 2));
model_labels = zeros(2, flower_set_number);

for i = 1:flower_set_number
    % generate label vectors
    training_label_vector = ...
        generate_label_vector(flower_set_number, i, ... 
        size(training_instance_matrix, 1) / flower_set_number);

    
    % train + test SVMs  
    addpath liblinear-1.95/matlab
    model = train(training_label_vector, ...
        sparse_training_instance_matrix, '-c 1');
    
    weight_matrix(i,:) = model.w(:);
    
    % check for multiply by -1. TODO, if statement which multiplies
    % weight_matrix by -1. 
    model_labels(:,i) = model.Label;
    rmpath liblinear-1.95/matlab
    

end
end
