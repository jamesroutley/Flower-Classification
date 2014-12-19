function [train_instance_matrix, test_instance_matrix] = ...
    generate_train_test_matrices (instance_matrix, trnid, valid, tstid)

num_train_images = size(trnid, 1) + size(valid, 1);
num_test_images = size(tstid, 1);



train_instance_matrix = zeros(num_train_images, 4096);
% combine and sort trnid and valid to index the training images in
% instance_matrix
trainid = sort(cat(1, trnid, valid));
for i = 1 : num_train_images
    train_instance_matrix(i, :) = instance_matrix(trainid(i), :);
end

test_instance_matrix = zeros(num_test_images, 4096);
for i = 1 : num_test_images
    test_instance_matrix(i) = instance_matrix(tstid(i));
end
    
    
