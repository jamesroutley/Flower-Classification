function generate_app_js_17(flower_set_number, image_name, decision_values, ...
    training_index_vector, test_index_vector, ...
    training_instance_matrix, test_instance_matrix)

% open demo.html, read in static html
app = fopen('app.js', 'w');
app_beginning = fileread('app_beginning.js');
app_end = fileread('app_end.js');

% initialise variables
label_vector = ones(flower_set_number, 40);
for i = 1 : flower_set_number
    label_vector(i, :) = i;
end
label_vector = reshape(label_vector', 1, []);
label_vector = label_vector';

difference_matrix = zeros(680, 4096);
sum_of_difference = zeros(680, 1);

% generate empty matrix
comparison_image_name =['image_0000.jpg';
                        'image_0000.jpg';
                        'image_0000.jpg';
                        'image_0000.jpg';
                        'image_0000.jpg'];
                    
index_of_comparison_image = zeros(5, 1);
                    
                    
fprintf(app, app_beginning);

fprintf(app, '[ \n');

for i = 1 : size(test_index_vector, 2)
    [~, ranking, ~] = unique(decision_values(:, i));
    ranking = flipud(ranking);
    
    % find nearest neighbour, store in comparison_image_name
    for j = 1 : 680
        difference_matrix(j, :) = abs( ...
            training_instance_matrix(j, :) - test_instance_matrix(i, :) );
        sum_of_difference(j) = sum(difference_matrix(j, :));
    end

    
    for k = 1 : 5
        [~, index_of_comparison_image(k)] = min( ... 
            sum_of_difference( ((k * 40) - 40 + 1) : (40 * k) ));
        
        comparison_image_name(k, :) = ...
            image_name(training_index_vector( ...
            index_of_comparison_image(k) + 40 * (k - 1)), :);
    end
    
    
    % print data to app.js
    
    fprintf(app, '{ \n');
    
    % insert photo in question into table
    fprintf(app, strcat('  flower0: "', image_name( ... 
        test_index_vector(i), :),'", \n' ));

    % insert classification photos into table
    for l = 1 : 5
        fprintf(app, strcat('  flower', num2str(l),': "', ...
            comparison_image_name(ranking(l), :),'",  \n' ));
    end
    
    % Give error warning for incorrectly classified images
    if ranking(1) == label_vector(i)
        fprintf(app, '  danger: 0 \n');
    else
        fprintf(app, '  danger: 1 \n');
    end
    
    fprintf(app, '}, \n \n');
    
end 
fprintf(app, '] \n \n');

fprintf(app, app_end);

fclose('all');

end