function drawshape(shape,Colour)
% Plot the coordinates of the shape

% Extracting x values
xValues=shape(1,:);
% Extracting y values
yValues=shape(2,:);
% Plotting shape
plot(xValues,yValues,'Color',Colour)
end
