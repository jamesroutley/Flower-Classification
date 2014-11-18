function generate_demo_page(image_name, decision_values, test_index_vector)

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

fprintf(demo, demo_beginning);

% write table to demo.html
fprintf(demo, '<table class="table"> \n' );
for i = 1 : size(test_index_vector, 2)
    fprintf(demo, '<tr> \n');
    
    % insert photo in question into table
    fprintf(demo, strcat( ... 
            '  <td><img src="img/oxfordflower5/jpg/', ...
            image_name(test_index_vector(i), :), ... 
            '" height="100px" class="img-rounded"></td> \n' ));
    
    [~, ranking, ~] = unique(decision_values(:, i));
    
    ranking = flipud(ranking);
    
    comparison_image_name =['image_0001.jpg';
                            'image_0081.jpg';
                            'image_0161.jpg';
                            'image_0241.jpg';
                            'image_0321.jpg'];
    
    if ranking(1) == label_vector(i)
        fprintf(demo, strcat( ... 
            '  <td><img src="img/oxfordflower5/jpg/', ...
            comparison_image_name(ranking(1), :), ... 
            '" height="100px" class="img-rounded"></td> \n' ));
    else
        fprintf(demo, strcat( ... 
            '  <td class="danger"><img src="img/oxfordflower5/jpg/', ...
            comparison_image_name(ranking(1), :), ... 
            '" height="100px" class="img-rounded"></td> \n' ));
    end
    
    
    for j = 2 : 5
        fprintf(demo, strcat( ... 
            '  <td><img src="img/oxfordflower5/jpg/', ...
            comparison_image_name(ranking(j), :), ... 
            '" height="100px" class="img-rounded"></td> \n' ));
    end
    
    fprintf(demo, '</tr> \n \n');
    
end 
fprintf(demo, '</table>');

fprintf(demo, demo_end);

fclose('all');

end