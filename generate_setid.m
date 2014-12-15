function [trnid, valid, tstid] = generate_setid( ... 
    flower_set_number, num_flower_vectors)

num_vectors_per_flower = num_flower_vectors / flower_set_number;
num_id_vectors = num_vectors_per_flower / 4;

% generate vectors which define which photo vectors in the instance matrix
% belong to the training set, the validation set and the test set. 
trnid_help_sample = zeros(4, num_id_vectors);
trnid_help_sample(1, :) = 1;
trnid_help_sample = reshape(trnid_help_sample', 1, []);
trnid_help_sample = trnid_help_sample';

valid_help_sample = zeros(4, num_id_vectors);
valid_help_sample(2, :) = 1;
valid_help_sample = reshape(valid_help_sample', 1, []);
valid_help_sample = valid_help_sample';

tstid_help_sample = zeros(4, num_id_vectors);
tstid_help_sample(3:4, :) = 1;
tstid_help_sample = reshape(tstid_help_sample', 1, []);
tstid_help_sample = tstid_help_sample';

trnid_help = repmat(trnid_help_sample, flower_set_number, 1);
valid_help = repmat(valid_help_sample, flower_set_number, 1);
tstid_help = repmat(tstid_help_sample, flower_set_number, 1);

id = 1 : num_flower_vectors;

trnid_help = id' .* trnid_help; 
valid_help = id' .* valid_help;
tstid_help = id' .* tstid_help;

trnid = trnid_help(trnid_help ~= 0);
valid = valid_help(valid_help ~= 0);
tstid = tstid_help(tstid_help ~= 0);

end