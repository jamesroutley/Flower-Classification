

if 0
    % generate instance matrix
    totalInstanceMatrix = ones(size(numTotalImages, 2), 4096);
    for i = 1 : size(imageName, 1)
        totalInstanceMatrix(i, :) = jr_cnn(imageName(i, :), imageFolder);
    end
end
    
for i = 1:flowerSetNumber
    
    % generate label Vector
    a = -ones(flowerSetNumber,80);
    a(i, :) = +1;
    a = reshape(a', 1, []);
    totalLabelVector = a';

    j = num2str(i);
    totalInstanceMatrixSparse = sparse(totalInstanceMatrix);
    addpath libsvm-3.18/matlab
    libsvmwrite(strcat('totalData', j) , totalLabelVector, totalInstanceMatrixSparse);
    rmpath libsvm-3.18/matlab
end

%strcat('totalData', j, '.txt')