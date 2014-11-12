function roc_matrix_with_boundary_values = ...
    generate_roc_curve(decision_values)
% plot true positives and false positives of each model (separately), as
% the value of the decision boundary changes. 

cut_off_vector = -linspace(-2,2,101);

roc_matrix = zeros( (size(decision_values, 1) * 2 ) , size(cut_off_vector, 2) );
roc_matrix_with_boundary_values = zeros( ...
    size(roc_matrix, 1) + 1, size(roc_matrix, 2));

for i = 1 : size(cut_off_vector, 2)
    
    for j = 1 : (size(decision_values, 1))
        
        decisions = decision_values(j, :) > cut_off_vector(i);
        
        % find proportion of true positives and proportion of false
        % positives
        test_label_vector = ...
            generate_label_vector(size(decision_values, 1), j, 40);

        num_true_positives = 0;
        num_false_positives = 0;
        for k = 1 : size(decision_values, 2)
            if test_label_vector(k) == 1
                num_true_positives = num_true_positives +  decisions(k);
            else
                num_false_positives = num_false_positives +  decisions(k);
            end
        end
        
        roc_matrix( 2 * j - 1, i) = ( num_true_positives / 40 );
        roc_matrix( 2 * j, i) = ( num_false_positives / 160 );
        
    end

end
roc_matrix_with_boundary_values(1, :) = cut_off_vector(1, :);
roc_matrix_with_boundary_values(2:end, :) = roc_matrix(:, :);
end

