function Mp=MpDefinition(next_predicted_position, previous_position, tM, x_min_ext, ...
    x_min_int, y_min_ext, y_min_int)

%this function returns a binary value:
%       1 if the position of the centroid of the predicted object had some motion 
%           wrt to the previous position of the ball
%       0 otherwise 
%
%the inputs are the centre of the object analyzed, the previous position
%of the ball, the threshold and the two upper left corners of the ROIs 
%in order to express the coordinates of the points wrt the upper left
%corner of the frame.

if(isempty(next_predicted_position))
    Mp=false;
else
    xc=next_predicted_position(1);
    yc=next_predicted_position(2);

    x=previous_position(1);
    y=previous_position(2);

    distance=sqrt((xc-x)^2+(yc-y)^2);

    if(distance>=tM)
        Mp=true;
    else
        Mp=false;
    end
end

end