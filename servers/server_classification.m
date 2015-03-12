%{
classification script. Reads in a single image and classifies it. Uses the
weight matrix stored in MatLabs workspace.

TODO: read in a weight matrix from memory. Refactor to make it a function?
Need to look at how matlab code is called by python.
%}

function ranking = server_classification(im_name, weight_matrix, net)
% im = imread('oxfordflower17/jpg/image_0001.jpg');

im = imread(fullfile('images/', im_name));
im_ = single(im);
feature_vector = server_cnn_feature_extract(im_, net);

class_decision_values = feature_vector * weight_matrix';

% note we find the rankings by utilising the 'unique' function. This
% assumes all class_decision values are unique. Each class_decision_value
% is stored to 7dp so it probably won't be an issue.
[~, ranking, ~] = unique(class_decision_values);
ranking = flipud(ranking);
ranking = ranking(1:8)
end
