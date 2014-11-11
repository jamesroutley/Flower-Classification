if 0
    % generate instance matrix
    totalInstanceMatrix = ones(size(numTotalImages, 2), 4096);
    for i = 1 : size(imageName, 1)
        totalInstanceMatrix(i, :) = jr_cnn(imageName(i, :), imageFolder);
    end
end

trainingInstanceMatrixNoMirrors = zeros(200, 4096);
for i = 1 : 200
    trainingInstanceMatrixNoMirrors(i, :) = trainingInstanceMatrix(2 * i - 1, :);
end
    
for i = 1:flowerSetNumber
    
    % generate label Vector
    a = -ones(flowerSetNumber,40);
    a(i, :) = +1;
    a = reshape(a', 1, []);
    trainingLabelVector = a';

    j = num2str(i);
    trainingInstanceMatrixNoMirrorsSparse = sparse(trainingInstanceMatrixNoMirrors);
    addpath libsvm-3.18/matlab
    libsvmwrite(strcat('trainingData', j) , trainingLabelVector, trainingInstanceMatrixNoMirrorsSparse);
    rmpath libsvm-3.18/matlab
end

%strcat('totalData', j, '.txt')