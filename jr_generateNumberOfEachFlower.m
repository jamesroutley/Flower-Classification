
function numberOfEachFlower =  jr_generateNumberOfEachFlower(flowerSetNumber, imageLabels)
% jr_generateNumberOfEachFlower generates a vector containing the number of
% each flower image 

    numberOfEachFlower = zeros(flowerSetNumber, 1);
    c = unique(imageLabels, 'stable');

    for i = 1 : size (c, 2);
        numberOfEachFlower(i) = sum(imageLabels(:) == c(i));
    end

end
