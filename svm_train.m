function [weight_matrix, model_labels] = svm_train( ... 
    flower_set_number, train_instance_matrix, train_label_vector)
%{
% generate training_instance_matrix, label_vector
if use_mirror == 0;
    %train_instance_matrix = zeros(size(trnid, 2) + size(valid, 2), ...
    %    size(instance_matrix, 2));
    label_vector = zeros(size(trnid, 2) + size(valid, 2), 1);

    for i = 1 : size(trnid, 2)
    %    train_instance_matrix(2*i - 1, :) = instance_matrix(trnid(i), :);
    %    train_instance_matrix(2*i, :) = instance_matrix(valid(i), :);
        label_vector(2*i -1) = image_labels(trnid(i));
        label_vector(2*i) = image_labels(valid(i));
    end
end

% generate training_instance_matrix, label_vector using mirrors
if use_mirror == 1;
    training_instance_matrix = zeros((size(trnid, 2) + size(valid, 2)) * 2, ...
        size(instance_matrix, 2));
    label_vector = zeros((size(trnid, 2) + size(valid, 2)) * 2, 1);

    for i = 1 : size(trnid, 2)
        training_instance_matrix(4*i - 3, :) = instance_matrix(trnid(i), :);
        training_instance_matrix(4*i - 2, :) = instance_matrix(valid(i), :);
        training_instance_matrix(4*i - 1, :) = training_instance_matrix_mirror(2*i -1, :);
        training_instance_matrix(4*i, :) = training_instance_matrix_mirror(2*i, :);
        label_vector(4*i -3) = image_labels(trnid(i));
        label_vector(4*i -2) = image_labels(trnid(i));
        label_vector(4*i -1) = image_labels(valid(i));
        label_vector(4*i) = image_labels(valid(i));
    end
end
%}
               
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
