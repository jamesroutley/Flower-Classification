
addpath libsvm-3.18/matlab
model1 = svmtrain(lableVectorOne, trainingInstanceMatrix, '-c 1 -g 1');

[predict_label1, accuracy1, dec_values1] = svmpredict(lableVectorOne, testInstanceMatrix, model1);

model2 = svmtrain(lableVectorTwo, trainingInstanceMatrix, '-c 1 -g 1');

[predict_label2, accuracy2, dec_values2] = svmpredict(lableVectorTwo, testInstanceMatrix, model2);

model3 = svmtrain(lableVectorTwo, trainingInstanceMatrix, '-c 1 -g 1');

[predict_label3, accuracy3, dec_values3] = svmpredict(lableVectorThree, testInstanceMatrix, model3);
rmpath libsvm-3.18/matlab