function [train_instance_matrix, test_instance_matrix, ...
    train_label_vector, test_label_vector] = ...
    generate_train_test_matrices ( ... 
    instance_matrix, trnid, valid, tstid, new_image_labels)

num_train_images = size(trnid, 2) + size(valid, 2);
num_test_images = size(tstid, 2);



train_instance_matrix = zeros(num_train_images, 4096);
train_label_vector = zeros(num_train_images, 1);
% combine and sort trnid and valid to index the training images in
% instance_matrix
trainid = sort(cat(1, trnid, valid));
for i = 1 : num_train_images
    train_instance_matrix(i, :) = instance_matrix(trainid(i), :);
    train_label_vector(i) = new_image_labels(trainid(i));
end

test_instance_matrix = zeros(num_test_images, 4096);
test_label_vector = zeros(num_test_images, 1);
for i = 1 : num_test_images
    test_instance_matrix(i, :) = instance_matrix(tstid(i), :);
    test_label_vector(i) = new_image_labels(tstid(i)); 
end

end
    
    
