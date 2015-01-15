% FLOWER_RECOGNITION_SCRIPT 17 
% Check mirroring code - looking for ~3% 

% use mirrors?
use_mirror = 0;
use_jitter = 0;

% initialise variables
flower_set_number = 17;
% number_of_images_per_flower = 80;
image_folder = 'oxfordflower17/';
% num_total_images = flower_set_number * number_of_images_per_flower;


% import vector of flower file names
image_name = importdata(strcat(image_folder,'files.txt'));
image_name = cell2mat(image_name);

% generate vector of image categorisation labels
image_labels = load(strcat(image_folder,'labels.mat'));
image_labels = (cell2mat(struct2cell(image_labels)));


%{ 
    generates the full instance matrix, including mirrored and / or 
    jittered images if specified above.
    generates new_image_labels, the vector of image labels for the new
    instance matrix
%}
[instance_matrix, new_image_labels] = cnn_generate_instance_matrix ...
    (image_name, image_folder, image_labels, use_mirror, use_jitter);


%{
    generates the trnid, valid, tstid, vectors containing the index of the
    images used for training, validation and testing in the instance
    matrix. 
%}
[trnid, valid, tstid] = generate_setid(flower_set_number, size(instance_matrix, 1));

%{
    uses the setid to split the instance_matrix into training and test
    matrices, and the new_image_labels into test and training labels
%}
[train_instance_matrix, test_instance_matrix, ...
    train_label_vector, test_label_vector] = ...
    generate_train_test_matrices ( ... 
    instance_matrix, trnid, valid, tstid, new_image_labels);

% train models 
[weight_matrix, model_labels] = svm_train_102(flower_set_number, train_instance_matrix, train_label_vector);


% test models
decision_values = ...
    svm_test_102(flower_set_number, test_instance_matrix, weight_matrix);

if 0
    generate_app_js(flower_set_number, image_name, decision_values, ...
    sort(cat(1, trnid, valid)), tstid, ...
    train_instance_matrix, test_instance_matrix);
end

% measure quality of results; confusion matrix, contingency table, ROC,
% and error (sum of false positives and false negatives)
confusion_matrix = generate_confusion_matrix(decision_values);

% plot confusion matrix
plot_confusion_matrix(confusion_matrix)

% find confusion_matrix_accuracy
confusion_matrix_accuracy = trace(confusion_matrix) / ...
    flower_set_number;

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


% plot roc curves
for i = 1 : flower_set_number
    plot(roc_matrix(2 * i + 1, :), roc_matrix(2 * i, :));
    hold on
end
axis([0 1 0 1])  
%}

    
    