function trainingInstanceMatrix = jr_cnn_genTrainingMatrix(imageName, imageFolder, trainingIndexVector)

trainImageFolder = strcat(imageFolder, 'jpg/');
mirrorImageFolder = strcat(imageFolder, 'jpgtest/');

trainingInstanceMatrix = ones( (size(trainingIndexVector, 2) * 2) , 4096 );
    for i = 1 : size(trainingIndexVector, 2)
        trainingInstanceMatrix((2*i - 1), :) = jr_cnn(imageName(trainingIndexVector(i), :), trainImageFolder);
        trainingInstanceMatrix(2*i, :) = jr_cnn(imageName(trainingIndexVector(i), :), mirrorImageFolder);
    end
    save(strcat(imageFolder,'trainingInstanceMatrix.mat'), 'trainingInstanceMatrix');
end