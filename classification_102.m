% FLOWER_RECOGNITION_SCRIPT 102

% User specifies whether to use mirroring and jittering (use = 1,
% don't use = 0)
cnn_options.train_mirror = 0;
cnn_options.train_jitter = 0;
cnn_options.test_mirror = 0;
cnn_options.test_jitter = 0;
do_svm = 0;

% initialise variables
flower_set_number = 102;
image_folder = 'oxfordflower102/';

% import vector of flower file names
image_name = importdata(fullfile(image_folder,'files.txt'));
image_name = cell2mat(image_name);

% load setid
load(fullfile(image_folder, 'setid.mat'));
setid.trnid = trnid;
setid.valid = valid;
setid.tstid = tstid;

% generate vector of image categorisation labels
image_labels = load(fullfile(image_folder,'labels.mat'));
image_labels = (cell2mat(struct2cell(image_labels)));

% perform CNN on flower images
[train_instance_matrix, test_instance_matrix, train_label_vector, ...
    test_label_vector] = cnn_gen_test_train_matrix(image_name, ...
    image_folder, image_labels, cnn_options, setid);

% Can you do a sanity check here.
% E.g. checking the number of zeros in your train_instance_matrix and
% test_instance_matrix. sum(sum(train_instance_matrix == 0)) should be around 0
% since you don't expect many 0 values in your matrix.
% Same goes to the labels. None of them should have the default value too.

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


% find average accuracy
confusion_matrix_accuracy = trace(confusion_matrix) / ...
    flower_set_number;

% plot confusion matrix
%ImshowAxesVisible = true;
imshow(confusion_matrix, 'InitialMagnification',400)
colormap(jet)

% plot rank accuracy
plot_rank_accuracy(decision_values, tstid, image_labels)

