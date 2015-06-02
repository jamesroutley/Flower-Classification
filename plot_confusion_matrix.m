function plot_confusion_matrix(confusion_matrix)

imagesc(confusion_matrix); 
colormap(jet)
flower_set_number = size(confusion_matrix, 1);

textStrings = num2str(confusion_matrix(:),'%0.2f');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space padding


idx = find(strcmp(textStrings(:), '0.00'));
textStrings(idx) = {'   '};



[x,y] = meshgrid(1:flower_set_number);   %# Create x and y coordinates for the strings
hStrings = text(x(:),y(:),textStrings(:),...      %# Plot the strings
                'HorizontalAlignment','center');
midValue = 0.3; % mean(get(gca,'CLim'));  %# Get the middle value of the color range
textColors = repmat(confusion_matrix(:) < midValue,1,3);  %# Choose white or black for the
                                             %#   text color of the strings so
                                             %#   they can be easily seen over
                                             %#   the background color
set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors

set(gca,'XTick',1:flower_set_number,'YTick',1:flower_set_number,'TickLength',[0 0]);
end