function imageName = jr_import_flower_file_names()
% JR_FILE_IMPORT_FLOWER_NAMES imports the names of the flower image files 

imageName = importdata('oxfordflower17/jpg/files.txt');

end