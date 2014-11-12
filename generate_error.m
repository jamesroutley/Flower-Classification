function error = generate_error(contingency_table)

error = zeros( size(contingency_table, 1) / 2 , 1);

for i = 1 : size(contingency_table, 1) / 2
    error(i) = contingency_table(2 * i - 1, 2) + contingency_table(2 * i, 1);
end