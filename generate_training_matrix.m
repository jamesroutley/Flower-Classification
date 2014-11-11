function trainingInstanceMatrix = jr_cnn_gen_training_matrix(image_name, image_folder, training_index_vector)

trainImageFolder = strcat(image_folder, 'jpg/');
mirrorImageFolder = strcat(image_folder, 'jpgtest/');

trainingInstanceMatrix = ones( (size(training_index_vector, 2) * 2) , 4096 );
    for i = 1 : size(training_index_vector, 2)
        trainingInstanceMatrix((2*i - 1), :) = jr_cnn(image_name(training_index_vector(i), :), trainImageFolder);
        trainingInstanceMatrix(2*i, :) = jr_cnn(image_name(training_index_vector(i), :), mirrorImageFolder);
    end
    save(strcat(image_folder,'trainingInstanceMatrix.mat'), 'trainingInstanceMatrix');
end