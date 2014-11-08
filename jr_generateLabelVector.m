function labelVector = jr_generateLabelVector(imageLabels, modelNum)
% generates the lableVector used by svmtrain and svmpredict

c = unique(imageLabels, 'stable');

labelVector = imageLabels(:) == c(modelNum);

labelVector = double(labelVector);

end