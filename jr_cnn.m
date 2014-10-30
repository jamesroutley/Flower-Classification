function featureVect = jr_cnn(imageFileName) 
% JR_CNN Feature extraction using ImageNet CNN model.
% Based on Vedaldi's CNN_IMAGENET_MINIMAL. 

% setup toolbox
run(fullfile(fileparts(mfilename('fullpath')), '/cnn_matlab/vl_setupnn.m')) ;

% download a pre-trained CNN from the web
if ~exist('cnn_imagenet-vgg-f.mat')
  urlwrite('http://www.vlfeat.org/matconvnet/models/imagenet-vgg-f.mat', ...
    'cnn_imagenet-vgg-f.mat') ;
end
net = load('cnn_imagenet-vgg-f.mat') ;

% obtain and preprocess an image
im = imread(strcat('oxfordflower5/jpg/',imageFileName)) ;
im_ = single(im) ; % note: 255 range
im_ = imresize(im_, net.normalization.imageSize(1:2)) ;
im_ = im_ - net.normalization.averageImage ;

% run the CNN
res = vl_simplenn(net, im_) ;
featureVect = squeeze(gather(res(end).x));
featureVect = featureVect';
end



