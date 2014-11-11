function contingency_table = generate_contingency_table( ...
    flower_set_number, decision_values)
% run each model on full test set, find the true positives, false 
% positives, false negatives, true negatives of each model. Store results
% in, and return contingencyTable. Decision made using +-0 as the decision
% boundary. 
 

contingency_table = zeros(flower_set_number * 2, 2);

for i = 1 : flower_set_number
    testLabelVector = generate_test_label_vector(flower_set_number, i);
    decisions = decision_values(i, :) > 0;

    num_true_positives = 0;
    num_false_positives = 0;
    for j = 1 : size(decision_values, 2)
        if testLabelVector(j) == 1
            num_true_positives = num_true_positives +  decisions(j);
        else
            num_false_positives = num_false_positives +  decisions(j);
        end
    end

    % store calculated values in contincencyTable
    contingency_table((2 * i - 1), 1) = num_true_positives;
    contingency_table((2 * i - 1), 2) = num_false_positives;
    contingency_table(2 * i, 1) = 40 - num_true_positives;
    contingency_table(2 * i, 2) = 200 - 40 - num_false_positives;
end
end


