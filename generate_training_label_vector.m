function training_label_vector = ...
    generate_training_label_vector(flower_set_number, model_num)
% generates the lableVector used by svmtrain and svmpredict

a = -ones(flower_set_number, 80);
a(model_num, :) = +1;
a = reshape(a', 1, []);
training_label_vector = a';
end