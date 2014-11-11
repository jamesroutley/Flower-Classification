function confusionMatrix = jr_confMatrix(decValues)
% classifies a given image, based on the model which gives the least
% nevative decision value. Forms a confusion matrix based on the results.

    % find the predicted type of each of the 200 test photos
    [Y, decLabels] = max(decValues);

    % generate correct labels of each of the 200 test photos
    actualLabels = ones(5, 40);
    for i = 1:5;
        actualLabels(i, :) = i;
    end
    actualLabels = reshape(actualLabels', 1, []);

    % generate confusion matrix comparing predicted results vs actual results
    confusionMatrix = zeros(5);
    for i = 1:size(decLabels, 2)
        confusionMatrix(actualLabels(i), decLabels(i)) = confusionMatrix(actualLabels(i), decLabels(i)) + 1;
    end
end