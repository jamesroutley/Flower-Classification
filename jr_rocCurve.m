function rocMatrixWithBoundaryValues = jr_rocCurve(decValues)
% plot true positives and false positives of each model (separately), as
% the value of the decision boundary changes. 

cutOffVector = -linspace(-2,2,101);

rocMatrix = zeros( (size(decValues, 1) * 2 ) , size(cutOffVector, 2) );
rocMatrixWithBoundaryValues = zeros(size(rocMatrix, 1) + 1, size(rocMatrix, 2));

for i = 1 : size(cutOffVector, 2)
    
    for j = 1 : (size(decValues, 1))
        
        decisions = decValues(j, :) > cutOffVector(i);
        
        % find proportion of true positives and proportion of false positives
        testLabelVector = jr_svm_genTestLabelVector(size(decValues, 1), j);

        numTruePositives = 0;
        numFalsePositives = 0;
        for k = 1 : size(decValues, 2)
            if testLabelVector(k) == 1
                numTruePositives = numTruePositives +  decisions(k);
            else
                numFalsePositives = numFalsePositives +  decisions(k);
            end
        end
        
        rocMatrix( 2 * j - 1, i) = ( numTruePositives / 40 );
        rocMatrix( 2 * j, i) = ( numFalsePositives / 160 );
        
    end

end
rocMatrixWithBoundaryValues(1, :) = cutOffVector(1, :);
rocMatrixWithBoundaryValues(2:end, :) = rocMatrix(:, :);
end

