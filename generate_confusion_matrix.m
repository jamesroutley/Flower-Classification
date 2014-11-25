function confusionMatrix = generate_confusion_matrix(decision_values)
% classifies a given image, based on the model which gives the least
% nevative decision value. Forms a confusion matrix based on the results.
flower_set_number = size(decision_values, 1);

% find the predicted type of each of the 200 test photos
[~, decision_labels] = max(decision_values);

% generate correct labels of each of the 200 test photos
actual_labels = ones(flower_set_number, 40);
for i = 1:flower_set_number;
    actual_labels(i, :) = i;
end
actual_labels = reshape(actual_labels', 1, []);

% generate confusion matrix comparing predicted results vs actual results
confusionMatrix = zeros(flower_set_number);
for i = 1:size(decision_labels, 2)
    confusionMatrix(actual_labels(i), decision_labels(i)) = ...
        confusionMatrix(actual_labels(i), decision_labels(i)) + 1;
end
end