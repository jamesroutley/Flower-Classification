

% dummy training data matrix
training_matrix = [ 1, 0 ; 1.1, 0.1; 0, 1; -0.1, 0.9 ];
label_vector = [1; 1; 0; 0];

% dummy test data
test_matrix = [-0.1, 0.9];

sparse_training_matrix = sparse(training_matrix);
sparse_test_matrix = sparse(test_matrix);

% train SVMs  
addpath liblinear-1.95/matlab
model = train(label_vector, sparse_training_matrix, '-c 1 ');
rmpath liblinear-1.95/matlab

% test SVM  
addpath liblinear-1.95/matlab
[predict_label, accuracy, dec_values] = predict(1, sparse_test_matrix, model);
rmpath liblinear-1.95/matlab

decision = model.w * test_matrix';
    

    
    
    