%JR_CNN_SCRIPT Script generates photo file names and passes them to jr_cnn
%and saves the returned feature vector

imageName = jr_import_flower_file_names;


featureVect = jr_cnn('image_0001.jpg')