function [train_instance_matrix, test_instance_matrix, ...
    train_label_vector, test_label_vector] = cnn_gen_test_train_matrix ...
    (image_name, image_folder, image_labels, use_mirror, use_jitter, setid)

net = load('cnn_imagenet-vgg-f.mat') ;  % used in CNN. Taken out of cnn 
                                        % function for speed
trnid = setid.trnid;
valid = setid.valid;
tstid = setid.tstid;
num_images = size(image_name, 1);
num_test_images = size(tstid, 2);
num_train_images = size(trnid, 2) + size(valid, 2);
cnn_use_mirror = 1;
cnn_do_not_use_mirror = 0;
cnn_use_jitter = 1;
cnn_do_not_use_jitter = 0;
folder = strcat(image_folder, 'jpg/');


% load / generate the standard instance matrix
if exist(strcat(image_folder,'instance_matrix_standard.mat'))
    instance_matrix_standard = cell2mat(struct2cell( ... 
        load(strcat(image_folder,'instance_matrix_standard.mat'))));
else
    instance_matrix_standard = ones(num_images, 4096);

    for i = 1 : num_images
        instance_matrix_standard(i, :) = ...
            cnn(image_name(i, :), folder, net, ...
            cnn_do_not_use_mirror, cnn_do_not_use_jitter);
    end

    save(strcat(image_folder,'instance_matrix_standard.mat'),...
        'instance_matrix_standard');
end


% load / generate the mirror instance matrix
if exist(strcat(image_folder,'instance_matrix_mirror.mat'))
    instance_matrix_mirror = cell2mat(struct2cell( ... 
        load(strcat(image_folder,'instance_matrix_mirror.mat'))));
else
    instance_matrix_mirror = ones(num_images, 4096);

    for i = 1 : num_images
        instance_matrix_mirror(i, :) = ...
            cnn(image_name(i, :), folder, net, ...
            cnn_use_mirror, cnn_do_not_use_jitter);
    end

    save(strcat(image_folder,'instance_matrix_mirror.mat'), ...
        'instance_matrix_mirror');
end


% load / generate the jitter instance matrix
if exist(strcat(image_folder,'instance_matrix_jitter.mat'))
    instance_matrix_jitter = cell2mat(struct2cell( ... 
        load(strcat(image_folder,'instance_matrix_jitter.mat'))));
else
    instance_matrix_jitter = ones(num_images * 4, 4096);

    for i = 1 : num_images
        instance_matrix_jitter(4*i - 3 : 4*i, :) = ...
            cnn(image_name(i, :), folder, net, ...
            cnn_do_not_use_mirror, cnn_use_jitter);
    end

    save(strcat(image_folder,'instance_matrix_jitter.mat'), ...
        'instance_matrix_jitter');
end

% construct train_instance_matrix
trainid = sort(cat(2, trnid, valid));
if use_mirror == 1 && use_jitter == 1
    train_instance_matrix = zeros(num_train_images * 6, 4096);
    train_label_vector = zeros(num_train_images * 6, 1);
    for i = 1 : num_train_images
        train_instance_matrix(6*i - 5, :) = instance_matrix_standard(trainid(i), :);
        train_instance_matrix(6*i - 4, :) = instance_matrix_mirror(trainid(i), :);
        train_instance_matrix(6*i-3 : 6*i, :) = instance_matrix_jitter(4*trainid(i)-3 : 4*trainid(i), :);
        
        train_label_vector(6*i-5 : 6*i) = image_labels(trainid(i));
    end
    
elseif use_jitter == 1
    train_instance_matrix = zeros(num_train_images * 5, 4096);
    train_label_vector = zeros(num_train_images * 5, 1);
    for i = 1 : num_train_images
        train_instance_matrix(5*i - 4, :) = instance_matrix_standard(trainid(i), :);
        train_instance_matrix(5*i-3 : 5*i, :) = instance_matrix_jitter(4*trainid(i)-3 : 4*trainid(i), :);
        train_label_vector(5*i-4 : 5*i) = image_labels(trainid(i));
    end
    
elseif use_mirror == 1 
    train_instance_matrix = zeros(num_train_images * 2, 4096);
    train_label_vector = zeros(num_train_images * 2, 1);
    for i = 1 : num_train_images
        train_instance_matrix(2*i - 1, :) = instance_matrix_standard(trainid(i), :);
        train_instance_matrix(2*i, :) = instance_matrix_mirror(trainid(i), :);
        
        train_label_vector(2*i-1 : 2*i) = image_labels(trainid(i));
    end
    
else
    train_instance_matrix = zeros(num_train_images, 4096);
    train_label_vector = zeros(num_train_images, 1);
    for i = 1 : num_train_images
        train_instance_matrix(i, :) = instance_matrix_standard(trainid(i), :);
        
        train_label_vector(i) = image_labels(trainid(i));
    end
end


% construct test_instance_matrix
test_instance_matrix = zeros(num_test_images, 4096);
test_label_vector = zeros(num_test_images, 1);
for i = 1 : num_test_images
    test_instance_matrix(i, :) = instance_matrix_standard(tstid(i), :);
    test_label_vector(i) = image_labels(tstid(i));
end



end
