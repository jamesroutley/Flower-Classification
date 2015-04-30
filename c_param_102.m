% FLOWER_RECOGNITION_SCRIPT 17
% Check mirroring code - looking for ~3%

% TODO tidy up use_mirror + use_jitter. cnn_options struct could be used.

% User specifies whether to use mirroring and jittering (use = 1,
% don't use = 0)
cnn_options.train_mirror = 0;
cnn_options.train_jitter = 0;
cnn_options.test_mirror = 0;
cnn_options.test_jitter = 0;



%c_param_int = [0.0001, 0.001, 0.01, 0.1, 1, 10, 100, 1000, 10000];
%c_param_int = [0.000001];

c_param_int = [];
c_param_powers = -6:6;
for i = 1:size(c_param_powers, 2)
    c_param_int = [c_param_int, 10^c_param_powers(i)]
end



num_runs = size(c_param_int, 2);

accuracies = zeros(1, num_runs);

% initialise variables
flower_set_number = 102;
image_folder = 'oxfordflower102/';

% import vector of flower file names
image_name = importdata(fullfile(image_folder,'files.txt'));
image_name = cell2mat(image_name);

% generate vector of image categorisation labels
image_labels = load(fullfile(image_folder,'labels.mat'));
image_labels = (cell2mat(struct2cell(image_labels)));

% load setid
load(fullfile(image_folder, 'setid.mat'));
setid.trnid = trnid;
setid.valid = valid;
setid.tstid = tstid;

for i = 1 : num_runs
    
    c_param = strcat('-c  ',{' '}, num2str(c_param_int(i)));

    % perform CNN on flower images
    [train_instance_matrix, test_instance_matrix, train_label_vector, ...
        test_label_vector] = c_param_cnn(image_name, ...
        image_folder, image_labels, cnn_options, setid);


    % train SVM models
    [weight_matrix, model_labels] = c_param_svm_train( ...
        flower_set_number, train_instance_matrix, train_label_vector, c_param);


    % test SVM models 
    decision_values = ...
        svm_test(flower_set_number, test_instance_matrix, weight_matrix);

    % generate confusion matrix
    confusion_matrix = gen_conf_mat( ...
        decision_values, test_label_vector);

    %plot_confusion_matrix(confusion_matrix)


    accuracies(i) = trace(confusion_matrix) / ...
        flower_set_number;
end

