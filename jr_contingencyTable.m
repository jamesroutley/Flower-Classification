function contingencyTable = jr_contingencyTable(flowerSetNumber, decValues)
% run each model on full test set, find the true positives, false 
% positives, false negatives, true negatives of each model. Store results
% in, and return contingencyTable. Decision made using +-0 as the decision
% boundary. 
 

contingencyTable = zeros(flowerSetNumber * 2, 2);

for i = 1 : flowerSetNumber
    testLabelVector = jr_svm_genTestLabelVector(flowerSetNumber, i);
    decisions = decValues(i, :) > 0;

    numTruePositives = 0;
    numFalsePositives = 0;
    for j = 1 : size(decValues, 2)
        if testLabelVector(j) == 1
            numTruePositives = numTruePositives +  decisions(j);
        else
            numFalsePositives = numFalsePositives +  decisions(j);
        end
    end

    % store calculated values in contincencyTable
    contingencyTable((2 * i - 1), 1) = numTruePositives;
    contingencyTable((2 * i - 1), 2) = numFalsePositives;
    contingencyTable(2 * i, 1) = 40 - numTruePositives;
    contingencyTable(2 * i, 2) = 200 - 40 - numFalsePositives;
end
end


