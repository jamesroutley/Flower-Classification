function rank_accuracy = gen_rank_accuracy (decision_values, tstid, ...
    image_labels, num_flowers)

ranks = num_flowers;
%ranks = 102;
% get the image labels for the images in the test set
label_vector = zeros(size(tstid, 2), 1);
for i = 1 : size(tstid, 2)
    label_vector(i) = image_labels(tstid(i));
end
label_vector = label_vector';

% get the ranked classifications for all test flowers
[~, classification_labels] = sort(decision_values);
classification_labels = flipud(classification_labels);

rank_matrix = zeros(ranks);


rank_accuracy = zeros(ranks, 1);

for i = 1 : ranks
    correct_classification = label_vector == classification_labels(i,:);
    accuracy_count = correct_classification .* label_vector;
    
    for j = 1 : ranks
        if i == 1
            rank_matrix(i, j) = sum(accuracy_count == j);
        else
            rank_matrix(i, j) = sum(accuracy_count == j) ...
                + rank_matrix(i-1, j);
        end
    end

end

%convert to percentage
for j = 1 : ranks
    rank_matrix(:, j) = 1/sum(label_vector == j) ...
        * rank_matrix(:, j);    
end

%calculate rank accuracy 
for j = 1: ranks
    rank_accuracy(j) = mean(rank_matrix(j, :)) * 100;
end



end