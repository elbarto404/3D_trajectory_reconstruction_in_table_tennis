function T=TDefinition(binROI2,next_predicted_position,x_min_ext,x_min_int,y_min_ext,...
    y_min_int,centre);

%this function returns a binary value:
%       1 if the position of the centroid of the current object is coherent
%         with the predicted location 
%       0 otherwise 

%the inputs are the binary image obtained from the second step of TPT,
%the predicted location of the ball,the two upper left corners of the ROIs 
%in order to express the coordinates of the points wrt the upper left
%corner of the frame and the centre of the OOI.

%the maximum distance is 30 pixels
tT=30;

x=centre.Centroid(1)+x_min_ext+x_min_int;
y=centre.Centroid(2)+y_min_ext+y_min_int;


if(isempty(next_predicted_position))
    %there is no predicted position
    T=false;
else
    xp=next_predicted_position(1);
    yp=next_predicted_position(2);
    distance=sqrt((x-xp)^2+(y-yp)^2);
    
    if(distance<tT)
        T=true;
    else
        T=false;
    end

end

end