
function [predictLabels, accuracies, decValues]= jr_svm(flowerSetNumber, numTestImages, trainingInstanceMatrix, testInstanceMatrix)

% initialise predictLabels, accuracies, decValues matrices
 predictLabels = ones(flowerSetNumber, numTestImages);
 accuracies = ones(flowerSetNumber, 3);
 decValues = ones(flowerSetNumber, numTestImages);
 
 svmParameter = {'-c 2.0 -g 0.0001220703125'; '-c 8.0 -g 3.0517578125e-05'; '-c 8.0 -g 0.0001220703125';'-c 2.0 -g 0.0001220703125';'-c 2.0 -g 0.0001220703125'};
 
for i = 1:flowerSetNumber
    % generate label vectors
    trainingLabelVector = jr_svm_genTrainingLabelVector(flowerSetNumber, i);
    testLabelVector = jr_svm_genTestLabelVector(flowerSetNumber, i);
    
    % train + test SVMs  
    addpath libsvm-3.18/matlab
    model = svmtrain(trainingLabelVector, trainingInstanceMatrix, svmParameter(i));
    [predict_label, accuracy, dec_values] = svmpredict(testLabelVector, testInstanceMatrix, model);
    rmpath libsvm-3.18/matlab
    
    % store predict_label, accuracy, dec_values
    predictLabels(i, :) = predict_label';
    accuracies(i, :) = accuracy;
    decValues(i, :) = dec_values'; 
end
