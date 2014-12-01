%FLOWER_RECOGNITION_SCRIPT 5

% initialise variables
 flower_set_number = 102;
% number_of_images_per_flower = 80;
image_folder = 'oxfordflower102/';
% num_total_images = flower_set_number * number_of_images_per_flower;
% num_training_images = num_total_images/2;
% num_test_images = num_total_images/2;


% import vector of flower file names
image_name = importdata(strcat(image_folder,'files.txt'));
image_name = cell2mat(image_name);

load(strcat(image_folder, 'setid.mat'));


% TODO load setid.mat
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
    for i = 1 : size(labels, 2)
        instance_matrix(i, :) = cnn_feature_extractor( ... 
            image_name(i, :), images_folder);
    end
    
    save(strcat(image_folder,'instance_matrix.mat'), ...
        'instance_matrix');
end





% train models 
if 0
[weight_matrix, model_labels] = ...
    svm_train_102(flower_set_number, trnid, valid, instance_matrix, image_labels);
end

% test models
if 0
decision_values = ...
    svm_test_102(flower_set_number, instance_matrix, tstid, weight_matrix);
end


% measure quality of results; confusion matrix, contingency table, ROC,
% and error (sum of false positives and false negatives)
confusion_matrix = generate_confusion_matrix_102( ... 
    decision_values, tstid, image_labels);



ave_confustion_matrix_accuracy = trace(confusion_matrix_accuracy) / ...
    flower_set_number;



%{
confusion_matrix_accuracy = trace(confusion_matrix) / ...
    sum(sum(confusion_matrix));
%}

%{ 
contingency_table = generate_contingency_table( ...
    flower_set_number, decision_values);
roc_matrix = generate_roc_curve(decision_values);
error = generate_error(contingency_table);


%{
% generate image of confusion matrix
ImshowAxesVisible = true;
imshow(confusion_matrix ./ 40, 'InitialMagnification',10000)  
% # you want your cells to be larger than single pixels
 colormap(jet) % # to change the default grayscale colormap 
figure 
%}

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


        
        
        
        
        
        