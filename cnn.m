function feature_vector = cnn(image_file_name, image_folder, net, ...
    use_mirror, use_jitter)

% use_mirror and use_jitter should be an enumeration rather than 2 binary flags.
% What happens if both are 1? I would expect both jitter and mirror to apply but
% in the implementation, only mirror will apply.

% load image
im = imread(fullfile(image_folder, image_file_name)) ;
im_ = single(im) ; % note: 255 range

if use_mirror == 1 && use_jitter == 1
    feature_vector = zeros(5, 4096);
    
    im_ = fliplr(im_);

    height = size(im_, 1);
    width = size(im_, 2);
    desired_height = floor(height * 3/4 );
    desired_width = floor(width * 3/4 );
    half_height = floor((height - desired_height)/2);
    half_width = floor((width - desired_width)/2);

    % generate images
    im_jittered = {
        im_(1:desired_height, 1:desired_width, :);
        im_(1:desired_height, width-desired_width: width, :);
        im_(height-desired_height : height, 1:desired_width, :);
        im_(height-desired_height : height, width-desired_width: width, :);
        im_(half_height : half_height + desired_height, ...
            half_width : half_width + desired_width, : )
        };

    for i = 1 : size(im_jittered)
        feature_vector(i, :) = cnn_feature_extract(cell2mat(im_jittered(i)), net);
    end

elseif use_mirror == 1
    im_ = fliplr(im_);
    feature_vector = cnn_feature_extract(im_, net);

elseif use_jitter == 1
    feature_vector = zeros(5, 4096);

    height = size(im_, 1);
    width = size(im_, 2);
    desired_height = floor(height * 3/4 );
    desired_width = floor(width * 3/4 );
    half_height = floor((height - desired_height)/2);
    half_width = floor((width - desired_width)/2);

    % generate images
    im_jittered = {
        im_(1:desired_height, 1:desired_width, :);
        im_(1:desired_height, width-desired_width: width, :);
        im_(height-desired_height : height, 1:desired_width, :);
        im_(height-desired_height : height, width-desired_width: width, :);
        im_(half_height : half_height + desired_height, ...
            half_width : half_width + desired_width, : )
        };

    for i = 1 : size(im_jittered)
        feature_vector(i, :) = cnn_feature_extract(cell2mat(im_jittered(i)), net);
    end

else
    feature_vector = cnn_feature_extract(im_, net);
end
end



