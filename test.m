figure 
num = 101;
new_val = zeros(1, num);
for i = 1 : num
    new_val(i) = accuracy_rank(i+1) - accuracy_rank(i);
end
plot(1:num, new_val)
axis([1 11  0 10]);
xlabel('number of extra ranks considered')
ylabel('percentage point change in accuracy')


