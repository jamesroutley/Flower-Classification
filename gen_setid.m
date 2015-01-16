%{
The object of this function is to produce a set of vectors, trnid, valid
and tstid, which contain the indices of the feature vectors to be used in
training, validating and testing. It does so assuming that each flower has
80 example images. The first 20 are assigned to training, the next 20 to
validation and the final 40 to testing. 

As such, the output of this function should be:
trnid = [1, 2, ..., 20, 81, 82, ..., 100, 161, ...]
valid = [21, 22, ..., 40, 101, 102, 120, 181,  ...]
tstid = [41, 42, ..., 80, 121, 122, ..., 160,  ...]

spaces added for clarity:
trnid = [1:20,            81:100,                161:180,                 ...]
valid = [     21:40,             101:120,                181:200,         ...]
tstid = [           41:80,               121:160,                201:240, ...]

It does so by 
%}

function [setid] = gen_setid( ... 
    flower_set_number, num_flower_vectors)

num_vectors_per_flower = num_flower_vectors / flower_set_number;
num_id_vectors = num_vectors_per_flower / 4;

%{ 
generate vectors:
trnid_help_sample = [1x20, 0x20, 0x20, 0x20]
valid_help_sample = [0x20, 1x20, 0x20, 0x20]
tstid_help_sample = [0x20, 0x20, 1x20, 1x20]
%}

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

%{ 
generate vectors:
trnid_help = [1x20, 0x20, 0x20, 0x20] x 17
valid_help = [0x20, 1x20, 0x20, 0x20] x 17
tstid_help = [0x20, 0x20, 1x20, 1x20] x 17
%}
trnid_help = repmat(trnid_help_sample, flower_set_number, 1);
valid_help = repmat(valid_help_sample, flower_set_number, 1);
tstid_help = repmat(tstid_help_sample, flower_set_number, 1);

%{
multiply each help vector by 1:1380
%}
id = 1 : num_flower_vectors;

trnid_help = id' .* trnid_help; 
valid_help = id' .* valid_help;
tstid_help = id' .* tstid_help;

% remove zeros from help vectors
setid.trnid = trnid_help(trnid_help ~= 0)';
setid.valid = valid_help(valid_help ~= 0)';
setid.tstid = tstid_help(tstid_help ~= 0)';

% TODO: OLD SOLUTION: DELETE WHEN THIS WORKS
%{
% Need to extract only unmirrored, unjittered test images. This is a rough
% solution:
tstid_help = tstid_help(tstid_help ~= 0);


tstid = zeros(680, 1);
num_extra_images_per_flower = size(tstid_help, 1) / (flower_set_number * 40);
if num_extra_images_per_flower ~= 1
    for i = 1 : size(tstid)
        tstid(i) = tstid_help(((i-1) * num_extra_images_per_flower) + 1);
    end
else
    tstid = tstid_help;
end
tstid = tstid';
%}

end