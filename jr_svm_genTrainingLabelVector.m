function labelVector = jr_svm_genTrainingLabelVector(numberOfPhotos, modelNum)
% generates the lableVector used by svmtrain and svmpredict

a = -ones(numberOfPhotos,80);
a(modelNum, :) = +1;
a = reshape(a', 1, []);
labelVector = a';
end