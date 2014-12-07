% find optimal -c parameters
function accuracies = generate_c_parameter_102(flower_set_number, instance_matrix, trnid, valid, image_labels)


c_params = {'-c 0.001'; 
                   '-c 0.01'; 
                   '-c 0.1'; 
                   '-c 1'; 
                   '-c 10';
                   '-c 100';
                   '-c 1000'};


% c_params = {'-c 1'; '-c 10'};

accuracies = zeros(102, size(c_params, 1));

for index = 1 : size(c_params, 1)
    % generate training_instance_matrix, label_vector
    training_instance_matrix = zeros(size(trnid, 2),  ...
        size(instance_matrix, 2));
    label_vector = zeros(size(trnid, 2), 1);

    for i = 1 : size(trnid, 2)
        training_instance_matrix(i, :) = instance_matrix(trnid(i), :);
        label_vector(i) = image_labels(trnid(i));
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
            sparse_training_instance_matrix, c_params(index));

        weight_matrix(i,:) = model.w(:);

        % check for multiply by -1. TODO, if statement which multiplies
        % weight_matrix by -1. 
        model_labels(:,i) = model.Label;
        rmpath liblinear-1.95/matlab

    end

    %%%%%%%%%%%%%%%%%

    % generate test_instance_matrix
    test_instance_matrix = zeros(size(valid, 2), size(instance_matrix, 2));
    for i = 1 : size(valid, 2)
        test_instance_matrix(i, :) = instance_matrix(valid(i), :);
    end

    % initialise decision_values matrix
     decision_values = ones(flower_set_number, size(test_instance_matrix, 1));



    for i = 1 : flower_set_number

        decision_value = ...
            svm_predict( test_instance_matrix, weight_matrix(i, :));


        % store decision_values
        decision_values(i, :) = decision_value'; 
    end



    confusion_matrix = generate_confusion_matrix_102( ... 
        decision_values, valid, image_labels);
    
    for j = 1 : 102
         accuracies(j, index) = confusion_matrix(j, j);

    end
end

