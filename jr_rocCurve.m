function rocMatrix = jr_rocCurve(decValues)

cutOffVector = linspace(-2,2,101);

rocMatrix = zeros( (size(decValues, 1) * 2 ) , size(cutOffVector, 2) );

for i = 1 : size(cutOffVector, 2)
    
    for j = 1 : (size(decValues, 1))
        
        decisions = decValues(j, :) > cutOffVector(i);
        
        % find proportion of true positives and proportion of false positives
        testLabelVector = jr_svm_genTestLabelVector(5, 1);

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
end

