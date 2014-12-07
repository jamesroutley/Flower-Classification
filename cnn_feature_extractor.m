function feature_vector = cnn_feature_extractor(image_file_name, image_folder, net, use_jittering) 
% JR_CNN Feature extraction using ImageNet CNN model.
% Based on Vedaldi's CNN_IMAGENET_MINIMAL. 

% setup toolbox
run(fullfile(fileparts(mfilename('fullpath')), '/cnn_matlab/vl_setupnn.m'));

% download a pre-trained CNN from the web
if ~exist('cnn_imagenet-vgg-f.mat')
  urlwrite('http://www.vlfeat.org/matconvnet/models/imagenet-vgg-f.mat', ...
    'cnn_imagenet-vgg-f.mat') ;
end
%net = load('cnn_imagenet-vgg-f.mat') ;

% obtain and preprocess an image
im = imread(strcat(image_folder, image_file_name)) ;
im_ = single(im) ; % note: 255 range




if use_jittering == 1
    feature_matrix = zeros(5, 4096);
    
    height = size(im, 1);
    width = size(im, 2);
    desired_height = floor(height * 2/3 );
    desired_width = floor(width * 2/3 );
    half_height = floor((height - desired_height)/2);
    half_width = floor((width - desired_width)/2);
    
    % generate images
    im_jittered = {im_(1:desired_height, 1:desired_width, :);
        im_(1:desired_height, width-desired_width: width, :);
        im_(height-desired_height : height, 1:desired_width, :);
        im_(height-desired_height : height, width-desired_width: width, :);
        im_(half_height : half_height + desired_height, ...
            half_width : half_width + desired_width, : )};

    
    for i = 1 : size(im_jittered, 1)
        
        im_ = imresize(cell2mat(im_jittered(i)), net.normalization.imageSize(1:2)) ;
        im_ = im_ - net.normalization.averageImage ;
        
        res = vl_simplenn(net, im_) ;
        feature_vector = squeeze(gather(res(20).x));
        feature_matrix(i, :) = feature_vector';
    end
    feature_vector = mean(feature_matrix, 1);
else
    im_ = imresize(im_, net.normalization.imageSize(1:2)) ;
    im_ = im_ - net.normalization.averageImage ;
    % run the CNN (no jittering)
    res = vl_simplenn(net, im_) ;
    feature_vector = squeeze(gather(res(20).x));
    feature_vector = feature_vector';
end
end




