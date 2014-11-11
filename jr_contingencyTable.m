function contingencyTable = jr_contingencyTable(flowerSetNumber, decValues)
    % boundary at 0:
    boundary = zeros(1, size(decValues, 2));

    % find proportion of true positives and proportion of false positives,
    % store values in contingencyTable

    contingencyTable = zeros(flowerSetNumber * 2, 2);

    for i = 1 : flowerSetNumber
        testLabelVector = jr_svm_genTestLabelVector(flowerSetNumber, i);

        %{
        decisions = zeros(1, size(decValues, 2));
        for k = 1 : size(decValues, 2)
            if decValues(i, k) > boundary(k)
                decisions(k) = 1;
            end
        end
        %}
        
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


