% FLOWER_RECOGNITION_SCRIPT 102
% TODO resplit data, run tests again, average accuracy increase, standard
% deviation, 

% Refactor code to use new cnn_feature_extractor. 

use_mirrored_images = 0;

% initialise variables
flower_set_number = 102;
image_folder = 'oxfordflower102/';



% import vector of flower file names
image_name = importdata(strcat(image_folder,'files.txt'));
image_name = cell2mat(image_name);

load(strcat(image_folder, 'setid.mat'));


% generate vector of image categorisation labels
image_labels = load(strcat(image_folder,'labels.mat'));
image_labels = (cell2mat(struct2cell(image_labels)));



% load / generate instance_matrix storing test flower feature data

if  exist(strcat(image_folder,'instance_matrix.mat'))
    instance_matrix = load( ...
        strcat(image_folder,'instance_matrix.mat'));
    instance_matrix = (cell2mat(struct2cell(instance_matrix)));
else
    instance_matrix = ones(size(labels, 2), 4096);
    images_folder = strcat(image_folder, 'jpg/');
    net = load('cnn_imagenet-vgg-f.mat') ;
    
    for i = 1 : size(labels, 2)
        instance_matrix(i, :) = cnn_feature_extractor( ... 
            image_name(i, :), images_folder, net);
    end
    
    save(strcat(image_folder,'instance_matrix.mat'), ...
        'instance_matrix');
end

% load / generate training_instance_matrix_mirror
if use_mirrored_images == 1
    if exist(strcat(image_folder, 'training_instance_matrix_mirror.mat'))
        training_instance_matrix_mirror = load( ...
            strcat(image_folder, 'training_instance_matrix_mirror.mat'));
        training_instance_matrix_mirror = (cell2mat(struct2cell(training_instance_matrix_mirror)));
    else
        training_instance_matrix_mirror = ones(size(trnid, 2) + size(valid, 2), 4096);
        images_folder = strcat(image_folder, 'jpgmirror/');
        for i = 1 : size(trnid, 2)
            training_instance_matrix_mirror(2*i -1, :) = cnn_feature_extractor( ... 
                image_name(trnid(i), :), images_folder, net);
            training_instance_matrix_mirror(2*i, :) = cnn_feature_extractor( ... 
                image_name(valid(i), :), images_folder, net);
        end

        save(strcat(image_folder,'training_instance_matrix_mirror.mat'), ...
            'training_instance_matrix_mirror');
    end
end


% train models 
if 1
[weight_matrix, model_labels] = ...
    svm_train_102(flower_set_number, trnid, valid, instance_matrix, ...
    image_labels, use_mirrored_images, training_instance_matrix_mirror);
end

% test models
if 1
decision_values = ...
    svm_test_102(flower_set_number, instance_matrix, tstid, weight_matrix);
end


% measure quality of results; confusion matrix, contingency table, ROC,
% and error (sum of false positives and false negatives)
% TODO export confusion matrices
confusion_matrix = generate_confusion_matrix_102( ... 
    decision_values, tstid, image_labels);


% find average accuracy = 85.3% for non mirror; 85.7% mirror
ave_confustion_matrix_accuracy = trace(confusion_matrix) / ...
    flower_set_number;

% generate confusion matrix diagram
ImshowAxesVisible = true;
imshow(confusion_matrix, 'InitialMagnification',10000)  % # you want your cells 
to be larger than single pixels
colormap(jet) % # to change the default grayscale colormap 
 
plot_rank_accuracy (decision_values, tstid, image_labels)

%{
textStrings = num2str(confusion_matrix(:)/40,'%0.2f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding


idx = find(strcmp(textStrings(:), '0.00'));
textStrings(idx) = {'   '};



[x,y] = meshgrid(1:flower_set_number);   %# Create x and y coordinates for the strings
hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                'HorizontalAlignment','center');
midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(confusion_matrix(:) < midValue,1,3);  %# Choose white or black for the
                                             %#   text color of the strings so
                                             %#   they can be easily seen over
                                             %#   the background color
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors

set(gca,'XTick',1:flower_set_number,'YTick',1:flower_set_number,'TickLength',[0 0]);
%}
%{ 
contingency_table = generate_contingency_table( ...
    flower_set_number, decision_values);
roc_matrix = generate_roc_curve(decision_values);
error = generate_error(contingency_table);


% calculate Area Under Curve for ROC curves
area_under_curve = zeros(flower_set_number, 1);
for i = 1 : size(area_under_curve, 1)
    area_under_curve(i) = trapz(roc_matrix(2 * i + 1, :), ...
        roc_matrix(2 * i , :));
end


    
for i = 1 : flower_set_number
    plot(roc_matrix(2 * i + 1, :), roc_matrix(2 * i, :));
    hold on
end
axis([0 1 0 1])  

    
if 0
    generate_app_js(flower_set_number, image_name, decision_values, ...
    training_index_vector, test_index_vector, ...
    training_instance_matrix, test_instance_matrix);
end


%}


        
        
        
        
        
        