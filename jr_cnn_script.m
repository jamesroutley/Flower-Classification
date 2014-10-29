%JR_CNN_SCRIPT Script generates photo file names and passes them to jr_cnn
%and saves the returned feature vector

% flowerSetNumber allows easy switching of flower sets. 3, 17 or 102
flowerSetNumber = 3;

% import vector of flower file names, change format from cell to matrix
imageName = jr_import_flower_file_names;
imageName = cell2mat(imageName);

% find max index of flowers
maxFlowerIndex = size(imageName, 1);

% generate vector of image categorisation labels
if flowerSetNumber == 3
    imageLabels = labels(1:maxFlowerIndex);
else
    imageLabels = labels;
end

% define vectors containing the indeces of training and testing data
trainingIndexVector = [1:40, 81:120, 161:200];
testIndexVector = [41:80, 121:160, 201:240];




% generate trainingInstanceMatrix storing training flower feature data
if 0
    trainingInstanceMatrix = ones(size(trainingIndexVector, 2), 1000);
    for i = 1 : size(trainingIndexVector, 2)
        trainingInstanceMatrix(i, :) = jr_cnn(imageName(trainingIndexVector(i), :));
    end
end
    
% generate testInstanceMatrix storing training flower feature data
if 0
    testInstanceMatrix = ones(size(trainingIndexVector, 2), 1000);
    for i = 1 : size(trainingIndexVector, 2)
        testInstanceMatrix(i, :) = jr_cnn(imageName(testIndexVector(i), :));
    end
end

% generate labelVectors
if 0
   lableVectorOne = -ones(120, 1);
   lableVectorOne(1:40) = 1;
   
   lableVectorTwo = -ones(120,1);
   lableVectorTwo(41:80) = 1;
   
   lableVectorThree = -ones(120,1);
   lableVectorThree(81:120) = 1;
end




