

A = [1,1;2,2];
B = [1;0];
C = zeros (size(A));

for i = 1 : size(B, 1)
    C(i, :) = A(i, :) * B(i);
end
    