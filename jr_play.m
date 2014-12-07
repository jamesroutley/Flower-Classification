

im = imread('oxfordflower17/jpg/image_0001.jpg');
im_ = single(im) ; % note: 255 range

im_1 = {im_(1:150, 1:150, :); 
    im_(1:155, 1:155, :)}; 

im_ = imresize(cell2mat(im_1(1)), net.normalization.imageSize(1:2)) ;
im_ = im_ - net.normalization.averageImage ;

res = vl_simplenn(net, im_) ;
feature_vector = squeeze(gather(res(20).x));
feature_vector = feature_vector';