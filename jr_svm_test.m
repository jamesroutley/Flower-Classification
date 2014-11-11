

% dummy training data matrix
Tr = [ 1, 0 ; 1.1, 0.1; 0, 1; -0.1, 0.9 ];
labelVector = [1; 1; 0; 0];

% dummy test data
Te = [0.1, 0];

% train SVMs  
    addpath libsvm-3.18/matlab
    model = svmtrain(labelVector, Tr, '-c 1 ');
    rmpath libsvm-3.18/matlab
    
 % test SVM  
    addpath libsvm-3.18/matlab
    [predict_label, accuracy, dec_values] = svmpredict(1, Te, model);
    rmpath libsvm-3.18/matlab