function [weight_matrix, model_labels] = ...
    svm_train_102(flower_set_number, trnid, valid, instance_matrix, image_labels)

% generate training_instance_matrix, label_vector
training_instance_matrix = zeros(size(trnid, 2) + size(valid, 2), ...
    size(instance_matrix, 2));
label_vector = zeros(size(trnid, 2) + size(valid, 2), 1);

for i = 1 : size(trnid, 2)
    training_instance_matrix(2*i - 1, :) = instance_matrix(trnid(i), :);
    training_instance_matrix(2*i, :) = instance_matrix(valid(i), :);
    label_vector(2*i -1) = image_labels(trnid(i));
    label_vector(2*i) = image_labels(valid(i));
end
               
% generate sparse training instance matrices
sparse_training_instance_matrix = sparse(training_instance_matrix);

weight_matrix = zeros(flower_set_number,size(training_instance_matrix, 2));
model_labels = zeros(2, flower_set_number);

for i = 1:flower_set_number
    % generate label vectors
    training_label_vector = -ones(size(label_vector, 1), 1);
    for j = 1 : size(label_vector, 1)
        if label_vector(j) == i
            training_label_vector(j) = 1;
        end
    end
        

    
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
