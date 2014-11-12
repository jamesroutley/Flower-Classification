function label_vector = ...
    generate_label_vector(flower_set_number, model_num, num_photos)
% generates the lableVector used by svmtrain and svmpredict

a = -ones(flower_set_number, num_photos);
a(model_num, :) = +1;
a = reshape(a', 1, []);
label_vector = a';
end