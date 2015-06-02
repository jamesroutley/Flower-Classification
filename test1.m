complexity = (0:101) /101; 

acc_increase = zeros(1, num);
for i = 1 : num
    acc_increase(i) = accuracy_rank(i+1) - accuracy_rank(i);
end

figure
plot(accuracy_rank, complexity)