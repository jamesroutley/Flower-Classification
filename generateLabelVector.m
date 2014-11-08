function labelVector = generateLabelVector(numberOfPhotos, modelNum)
% generates the lableVector used by svmtrain and svmpredict

a = zeros(numberOfPhotos,80);
a(modelNum, :) = +1;
a = reshape(a', 1, []);
labelVector = a';
end