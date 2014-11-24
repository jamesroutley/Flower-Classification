A = [1,1,1;2,2,2;3,3,3];
B = [2,3,1];
C = zeros(size(A, 1), size(A, 2));
S = zeros(size(A, 1), 1);
for i = 1 : size(A, 1)
    C(i, :) = abs( A(i, :) - B ) ;
    S(i) = sum(C(i, :));
end

[M, I] = min(S);