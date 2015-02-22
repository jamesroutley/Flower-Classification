%{ 
classification script. Reads in a single image and classifies it. Uses the
weight matrix stored in MatLab's workspace.

TODO: read in a weight matrix from memory. Refactor to make it a function?
Need to look at how matlab code is called by python. 
%}

function ranking = classification(im)
% im = imread('oxfordflower17/jpg/image_0001.jpg');

im_ = single(im);
net = load('cnn_imagenet-vgg-f.mat');
feature_vector = cnn_feature_extract(im_, net);

class_decision_values = feature_vector * weight_matrix';

% note we find the rankings by utilising the 'unique' function. This
% assumes all class_decision values are unique. Each class_decision_value
% is stored to 7dp so it probably won't be an issue.
[~, ranking, ~] = unique(class_decision_values);
ranking = flipud(ranking);
end