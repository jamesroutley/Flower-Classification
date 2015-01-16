function confusion_matrix = gen_conf_mat( ... 
    decision_values, test_label_vector)
% classifies a given image, based on the model which gives the least
% nevative decision value. Forms a confusion matrix based on the results.
flower_set_number = size(decision_values, 1);

% find the predicted type of each of the test photos
[~, decision_labels] = max(decision_values);

%{
% generate correct labels of each of the test photos
test_label_vector = zeros(size(tstid, 2), 1);

for i = 1 : size(tstid, 2)
    test_label_vector(i) = image_labels(tstid(i));
end
%}


% generate confusion matrix comparing predicted results vs actual results
confusion_matrix = zeros(flower_set_number);
for i = 1 : size(decision_labels, 2)
    confusion_matrix(test_label_vector(i), decision_labels(i)) = ...
        confusion_matrix(test_label_vector(i), decision_labels(i)) + 1;
end

for i = 1 : size(confusion_matrix, 1)
    confusion_matrix(i, :) = ...
        confusion_matrix(i, :) / sum(confusion_matrix(i, :));

end