% FLOWER_RECOGNITION_SCRIPT 102
% TODO resplit data, run tests again, average accuracy increase, standard
% deviation, 

use_mirror = 0;
use_jitter = 0;
do_svm = 1;

% initialise variables
flower_set_number = 102;
image_folder = 'oxfordflower102/';

% import vector of flower file names
image_name = importdata(strcat(image_folder,'files.txt'));
image_name = cell2mat(image_name);

load(strcat(image_folder, 'setid.mat'));
setid.trnid = trnid;
setid.valid = valid;
setid.tstid = tstid;


% generate vector of image categorisation labels
image_labels = load(strcat(image_folder,'labels.mat'));
image_labels = (cell2mat(struct2cell(image_labels)));


[train_instance_matrix, test_instance_matrix, train_label_vector, ...
    test_label_vector] = cnn_gen_test_train_matrix(image_name, ...
    image_folder, image_labels, use_mirror, use_jitter, setid);


% train models 
if do_svm
[weight_matrix, model_labels] = svm_train( ... 
    flower_set_number, train_instance_matrix, train_label_vector);
end

% test models
if do_svm
decision_values = ...
    svm_test(flower_set_number, test_instance_matrix, weight_matrix);
end


% measure quality of results; confusion matrix, contingency table, ROC,
% and error (sum of false positives and false negatives)
% TODO export confusion matrices
confusion_matrix = gen_conf_mat( ... 
    decision_values, test_label_vector);


% find average accuracy = 85.3% for non mirror; 85.7% mirror
confusion_matrix_accuracy = trace(confusion_matrix) / ...
    flower_set_number;

% generate confusion matrix diagram
ImshowAxesVisible = true;
imshow(confusion_matrix, 'InitialMagnification',400) 
colormap(jet)


plot_rank_accuracy(decision_values, tstid, image_labels)

