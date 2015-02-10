% FLOWER_RECOGNITION_SCRIPT 102

% User specifies whether to use mirroring and jittering (use = 1, 
% don't use = 0)
use_mirror = 0;
use_jitter = 0;
do_svm = 1;

% initialise variables
flower_set_number = 102;
image_folder = 'oxfordflower102/';

% import vector of flower file names
image_name = importdata(strcat(image_folder,'files.txt'));
image_name = cell2mat(image_name);

% load setid
load(strcat(image_folder, 'setid.mat'));
setid.trnid = trnid;
setid.valid = valid;
setid.tstid = tstid;

% generate vector of image categorisation labels
image_labels = load(strcat(image_folder,'labels.mat'));
image_labels = (cell2mat(struct2cell(image_labels)));

% perform CNN on flower images
[train_instance_matrix, test_instance_matrix, train_label_vector, ...
    test_label_vector] = cnn_gen_test_train_matrix(image_name, ...
    image_folder, image_labels, use_mirror, use_jitter, setid);

% train SVM models 
if do_svm
[weight_matrix, model_labels] = svm_train( ... 
    flower_set_number, train_instance_matrix, train_label_vector);
end

% test SVM models
if do_svm
decision_values = ...
    svm_test(flower_set_number, test_instance_matrix, weight_matrix);
end


% generate confusion matrix
confusion_matrix = gen_conf_mat( ... 
    decision_values, test_label_vector);


% find average accuracy = 85.3% for non mirror; 85.7% mirror
confusion_matrix_accuracy = trace(confusion_matrix) / ...
    flower_set_number;

% plot confusion matrix
%ImshowAxesVisible = true;
imshow(confusion_matrix, 'InitialMagnification',400) 
colormap(jet)

% plot rank accuracy
plot_rank_accuracy(decision_values, tstid, image_labels)

