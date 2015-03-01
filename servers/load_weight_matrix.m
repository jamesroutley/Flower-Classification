function weight_matrix = load_weight_matrix()

weight_matrix = cell2mat(struct2cell(load('weight_matrix.mat')));

