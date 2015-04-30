% FLOWER_RECOGNITION_SCRIPT 17
% Check mirroring code - looking for ~3%

% TODO tidy up use_mirror + use_jitter. cnn_options struct could be used.

% User specifies whether to use mirroring and jittering (use = 1,
% don't use = 0)
cnn_options.train_mirror = 0;
cnn_options.train_jitter = 0;
cnn_options.test_mirror = 1;
cnn_options.test_jitter = 0;

%c_param_int = [0.00001, 0.0001, 0.001, 0.01, 0.1, 1, 10, 100, 1000, 10000, 100000];
c_param_int = [0.000001, 100000];
num_runs = size(c_param_int, 2);
%c_param = '-c 0.1';

accuracies = zeros(1, num_runs);

% initialise variables
flower_set_number = 17;
image_folder = 'oxfordflower17/';

% import vector of flower file names
image_name = importdata(fullfile(image_folder,'files.txt'));
image_name = cell2mat(image_name);

% generate vector of image categorisation labels
image_labels = load(fullfile(image_folder,'labels.mat'));
image_labels = (cell2mat(struct2cell(image_labels)));

% generate setid
[setid] = gen_setid(flower_set_number, size(image_labels, 2));

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

