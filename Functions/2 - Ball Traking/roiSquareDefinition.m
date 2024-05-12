function [square_roi,x_min,y_min]=roiSquareDefinition(x,y,frame_size,roi_dimension)

%this function generates a square centered in (x,y) with dimension
%roi_dimension.

x_min = x - (roi_dimension / 2);
if x_min < 0
    x_min = 0;
end

x_max = x + (roi_dimension / 2);
if x_max > frame_size(1) - 1
    x_max = frame_size(1) - 1;
end

y_min = y - (roi_dimension /2);
if y_min < 0
    y_min = 0;
end

y_max = y + (roi_dimension / 2);
if y_max > frame_size(2) - 1
    y_max = frame_size(2) - 1;
end

%smallest acceptable area
width = x_max - x_min;
if width < 50
    width = 50;
end

height = y_max - y_min;
if height < 50
    height = 50;
end

square_roi = [x_min, y_min, width , height ];

end