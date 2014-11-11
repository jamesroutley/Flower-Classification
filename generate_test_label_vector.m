function test_label_vector = ...
    generate_test_label_vector(flower_set_number, model_num)
% generates the lableVector used by svmtrain and svmpredict

a = -ones(flower_set_number,40);
a(model_num, :) = +1;
a = reshape(a', 1, []);
test_label_vector = a';
end