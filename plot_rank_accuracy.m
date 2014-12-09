function plot_rank_accuracy (decision_values, tstid, image_labels)

ranks_checked = 102;

label_vector = zeros(size(tstid, 2), 1);

for i = 1 : size(tstid, 2)
    label_vector(i) = image_labels(tstid(i));
end

[~, classification_labels] = sort(decision_values);
classification_labels = flipud(classification_labels);



rank_accuracy = zeros(ranks_checked, 2);

for i = 1 : ranks_checked
    correct_classification = label_vector' == classification_labels(i,:);
    num_correct_classification = sum(correct_classification);
    accuracy = num_correct_classification/size(correct_classification,2);
    
    rank_accuracy(i, 1) = 1;
    if i == 1
        rank_accuracy(i, 2) = accuracy;
    else
        rank_accuracy(i, 2) = accuracy + rank_accuracy(i-1, 2);
    end
end

% convert to percentage
rank_accuracy(:,2) = rank_accuracy(:,2) * 100;

figure 
plot(rank_accuracy);
axis([1 102 82 100]);
xlabel('number of ranks considered')
ylabel('percentage accuracy')

end

