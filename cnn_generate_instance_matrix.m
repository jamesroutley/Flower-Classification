function [instance_matrix] = cnn_generate_instance_matrix ...
    (image_name, image_folder, use_mirror, use_jitter)

net = load('cnn_imagenet-vgg-f.mat') ;  % used in CNN. Taken out of cnn 
                                        % function for speed

num_images = size(image_name, 1);
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
    instance_matrix_standard = ones(num_images, 4096 );

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
    instance_matrix_mirror = ones( num_images , 4096 );

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
    instance_matrix_jitter = ones( num_images * 4 , 4096 );

    for i = 1 : num_images
        instance_matrix_jitter(4*i - 3 : 4*i, :) = ...
            cnn(image_name(i, :), folder, net, ...
            cnn_do_not_use_mirror, cnn_use_jitter);
    end

    save(strcat(image_folder,'instance_matrix_jitter.mat'), ...
        'instance_matrix_jitter');
end


% construct instance matrix
if use_mirror == 1 && use_jitter == 1
    instance_matrix = zeros(num_images * 6, 4096);
    for i = 1 : num_images
        instance_matrix(6*i - 5, :) = instance_matrix_standard(i, :);
        instance_matrix(6*i - 4, :) = instance_matrix_mirror(i, :);
        instance_matrix(6*i - 3:6*i, :) = ...
            instance_matrix_jitter(4*i-3:4*i, :);
    end
elseif use_mirror == 1 
    instance_matrix = zeros(num_images * 2, 4096);
    for i = 1 : num_images
        instance_matrix(2*i - 1, :) = instance_matrix_standard(i, :);
        instance_matrix(2*i, :) = instance_matrix_mirror(i, :);
    end
elseif use_jitter == 1
    instance_matrix = zeros(num_images * 5, 4096);
    for i = 1 : num_images
        instance_matrix(5*i - 4, :) = instance_matrix_standard(i, :);
        instance_matrix(5*i - 3:5*i, :) = ...
            instance_matrix_jitter(4*i-3:4*i, :);
    end
else
    instance_matrix = instance_matrix_standard;
end


end
