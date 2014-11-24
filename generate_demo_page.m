function generate_demo_page(image_name, decision_values, ...
    training_index_vector, test_index_vector, ...
    training_instance_matrix, test_instance_matrix)

% open demo.html, read in static html
demo = fopen('demo.html', 'w');
demo_beginning = fileread('demo_beginning.html');
demo_end = fileread('demo_end.html');

% initialise variables
label_vector = ones(5, 40);
for i = 1 : 5
    label_vector(i, :) = i;
end
label_vector = reshape(label_vector', 1, []);
label_vector = label_vector';

difference_matrix = zeros(200, 4096);
sum_of_difference = zeros(200, 1);

comparison_image_name =['image_0001.jpg';
                        'image_0081.jpg';
                        'image_0161.jpg';
                        'image_0241.jpg';
                        'image_0321.jpg'];
                    
index_of_comparison_image = zeros(5, 1);
                    
                    
fprintf(demo, demo_beginning);

% write table to demo.html
fprintf(demo, '<table class="table"> \n' );
for i = 1 : size(test_index_vector, 2)
    [~, ranking, ~] = unique(decision_values(:, i));
    ranking = flipud(ranking);
    
    % TODO sum instance matrices before subtracting them
    for j = 1 : 200
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
    
    if ranking(1) == label_vector(i)
        fprintf(demo, '<tr> \n');
    else
        fprintf(demo, '<tr class="danger"> \n');
    end
    
    % insert photo in question into table
    fprintf(demo, strcat( ... 
            '  <td><img src="img/oxfordflower5/jpg/', ...
            image_name(test_index_vector(i), :), ... 
            '" height="100px" class="img-rounded"></td> \n' ));

    % insert classification photos into table
    for l = 1 : 5
        fprintf(demo, strcat( ... 
            '  <td><img src="img/oxfordflower5/jpg/', ...
            comparison_image_name(ranking(l), :), ... 
            '" height="100px" class="img-rounded"></td> \n' ));
    end
    
    fprintf(demo, '</tr> \n \n');
    
end 
fprintf(demo, '</table>');

fprintf(demo, demo_end);

fclose('all');

end