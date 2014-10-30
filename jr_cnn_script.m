%JR_CNN_SCRIPT Script generates photo file names and passes them to jr_cnn
%and saves the returned feature vector

% initialise variables
flowerSetNumber = 3;
numberOfImagesPerFlower = 80;
numTotalImages = flowerSetNumber * numberOfImagesPerFlower;
numTrainingImages = numTotalImages/2;
numTestImages = numTotalImages/2;


% import vector of flower file names
imageName = importdata('oxfordflower3/jpg/files.txt');
imageName = cell2mat(imageName);

% generate vector of image categorisation labels
imageLabels = load('oxfordflower3/labels.mat');
imageLabels = (cell2mat(struct2cell(imageLabels)));

% for simplified 3 flower case only:
if flowerSetNumber == 3
    imageLabels = imageLabels(1:numTotalImages);
end


% generate vectors containing the indeces of training and testing data
trainingIndexVector = ones(1, numTrainingImages);
testIndexVector = ones(1, numTestImages);
trainingCount = 0;
testCount = 0;
flag = 1;
for i = 1:numTotalImages %size(imageLabels, 2)
   
   if flag == 1 
       trainingCount = trainingCount + 1;
       trainingIndexVector(trainingCount) = i;
   end
   
   if flag == -1 
       testCount = testCount + 1;
       testIndexVector(testCount) = i;
   end
   
   if mod(i, 40) == 0
       flag = flag * -1;
   end
   
end



% load / generate trainingInstanceMatrix storing training flower feature data
if exist('trainingInstanceMatrix.mat')
    trainingInstanceMatrix = load('trainingInstanceMatrix.mat');
    trainingInstanceMatrix = (cell2mat(struct2cell(trainingInstanceMatrix)));
else
    trainingInstanceMatrix = ones(size(trainingIndexVector, 2), 1000);
    for i = 1 : size(trainingIndexVector, 2)
        trainingInstanceMatrix(i, :) = jr_cnn(imageName(trainingIndexVector(i), :));
    end
    save('trainingInstanceMatrix.mat', 'trainingInstanceMatrix');
end

% load / generate testInstanceMatrix storing test flower feature data
if  exist('testInstanceMatrix.mat')
    testInstanceMatrix = load('testInstanceMatrix.mat');
    testInstanceMatrix = (cell2mat(struct2cell(testInstanceMatrix)));
else
    testInstanceMatrix = ones(size(trainingIndexVector, 2), 1000);
    for i = 1 : size(trainingIndexVector, 2)
        testInstanceMatrix(i, :) = jr_cnn(imageName(testIndexVector(i), :));
    end
    save('testInstanceMatrix.mat', 'testInstanceMatrix')
end



% train and test models 
[predictLabels, accuracies, decValues] = jr_svm(flowerSetNumber, trainingInstanceMatrix, testInstanceMatrix);



