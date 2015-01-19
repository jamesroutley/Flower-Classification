function [weight_matrix, model_labels] = svm_train( ... 
    flower_set_number, train_instance_matrix, train_label_vector)
               
% generate sparse training instance matrices
sparse_training_instance_matrix = sparse(train_instance_matrix);

weight_matrix = zeros(flower_set_number, size(train_instance_matrix, 2));
model_labels = zeros(2, flower_set_number);

for i = 1:flower_set_number
    % generate label vectors
    label_vector = -ones(size(train_label_vector, 1), 1);
    for j = 1 : size(train_label_vector, 1)
        if train_label_vector(j) == i
            label_vector(j) = 1;
        end
    end
    
    % train + test SVMs  
    addpath liblinear-1.95/matlab
    model = train(label_vector, ...
        sparse_training_instance_matrix, '-c 1');
    
    weight_matrix(i,:) = model.w(:);
    
    % check for multiply by -1. TODO, if statement which multiplies
    % weight_matrix by -1. 
    model_labels(:,i) = model.Label;
    rmpath liblinear-1.95/matlab
    
end
end
