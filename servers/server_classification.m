%{
classification script. Reads in a single image and classifies it. Uses the
weight matrix stored in MatLabs workspace.

TODO: read in a weight matrix from memory. Refactor to make it a function?
Need to look at how matlab code is called by python.
%}

function ranking = server_classification(im_name, weight_matrix, net)
%tic
%im = imread('t.jpg');

mirror = 1;
sample = 1;

im = imread(fullfile('images/', im_name));
im_ = single(im);

height = size(im_, 1);
    width = size(im_, 2);
    desired_height = floor(height * 3/4 );
    desired_width = floor(width * 3/4 );
    half_height = floor((height - desired_height)/2);
    half_width = floor((width - desired_width)/2);

if mirror == 1 && sample == 1
    fv_1 = server_cnn_feature_extract(im_, net);
    fv_2 = server_cnn_feature_extract(fliplr(im_), net);
    
    fv_3 = zeros(5, 4096);
    im_jittered = {
        im_(1:desired_height, 1:desired_width, :);
        im_(1:desired_height, width-desired_width: width, :);
        im_(height-desired_height : height, 1:desired_width, :);
        im_(height-desired_height : height, width-desired_width: width, :);
        im_(half_height : half_height + desired_height, ...
            half_width : half_width + desired_width, : )
        };
    for i = 1 : size(im_jittered)
        fv_3(i, :) = server_cnn_feature_extract(cell2mat(im_jittered(i)), net);
    end
    fv_3 = mean(fv_3, 1);
    
    im_mirror = fliplr(im_);
    fv_4 = zeros(5, 4096);
    im_jittered = {
        im_mirror(1:desired_height, 1:desired_width, :);
        im_mirror(1:desired_height, width-desired_width: width, :);
        im_mirror(height-desired_height : height, 1:desired_width, :);
        im_mirror(height-desired_height : height, width-desired_width: width, :);
        im_mirror(half_height : half_height + desired_height, ...
            half_width : half_width + desired_width, : )
        };
    for i = 1 : size(im_jittered)
        fv_4(i, :) = server_cnn_feature_extract(cell2mat(im_jittered(i)), net);
    end
    fv_4 = mean(fv_4, 1);
    
    feature_vector = (fv_1 + fv_2 + fv_3 + fv_4) / 4;
    
    
    
elseif sample == 1
    fv_1 = zeros(5, 4096);
    
    
    
    im_jittered = {
        im_(1:desired_height, 1:desired_width, :);
        im_(1:desired_height, width-desired_width: width, :);
        im_(height-desired_height : height, 1:desired_width, :);
        im_(height-desired_height : height, width-desired_width: width, :);
        im_(half_height : half_height + desired_height, ...
            half_width : half_width + desired_width, : )
        };

    for i = 1 : size(im_jittered)
        fv_1(i, :) = server_cnn_feature_extract(cell2mat(im_jittered(i)), net);
    end
    
    fv_1 = mean(fv_1, 1);
    fv_2 = server_cnn_feature_extract(im_, net);
    
    feature_vector = (fv_1 + fv_2 )/2;
    
elseif mirror == 1
    fv_1 = server_cnn_feature_extract(im_, net);
    fv_2 = server_cnn_feature_extract(fliplr(im_), net);
    feature_vector = (fv_1 + fv_2 )/2;
else 
    feature_vector = server_cnn_feature_extract(im_, net);
end

class_decision_values = feature_vector * weight_matrix';

% note we find the rankings by utilising the 'unique' function. This
% assumes all class_decision values are unique. Each class_decision_value
% is stored to 7dp so it probably won't be an issue.
[~, ranking, ~] = unique(class_decision_values);
ranking = flipud(ranking);
ranking = ranking(1:8);
%toc
end
