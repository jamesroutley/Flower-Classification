function feature_vector = cnn_feature_extract(im_, net)
% im_ is not a local variable here.... why underscore?

% JR_CNN Feature extraction using ImageNet CNN model.
% Based on Vedaldi's CNN_IMAGENET_MINIMAL.

% setup toolbox
run(fullfile(fileparts(mfilename('fullpath')), '/cnn_matlab/vl_setupnn.m'));

% download a pre-trained CNN from the web
if ~exist('cnn_imagenet-vgg-f.mat')
  urlwrite('http://www.vlfeat.org/matconvnet/models/imagenet-vgg-f.mat', ...
    'cnn_imagenet-vgg-f.mat') ;
end

im_ = imresize(im_, net.normalization.imageSize(1:2)) ;
im_ = im_ - net.normalization.averageImage ;

res = vl_simplenn(net, im_) ;

% What does this line do? Is it from an example given by the cnn library?

feature_vector = squeeze(gather(res(20).x));
feature_vector = feature_vector';
feature_vector = feature_vector / norm(feature_vector);

end






