function Mc=McDefinition(centre, previous_position, tM, x_min_ext, ...
    x_min_int, y_min_ext, y_min_int)

%this function returns a binary value:
%       1 if the position of the centroid of the centre of the object had some motion 
%           wrt to the previous position of the ball
%       0 otherwise 
%
%the inputs are the centre of the object analyzed, the previous position
%of the ball, the threshold and the two upper left corners of the ROIs 
%in order to express the coordinates of the points wrt the upper left
%corner of the frame.

if(isempty(previous_position))
    Mc=false;
else
    xc=centre.Centroid(1)+x_min_ext+x_min_int;
    yc=centre.Centroid(2)+y_min_ext+y_min_int;

    x=previous_position(1);
    y=previous_position(2);

    distance=sqrt((xc-x)^2+(yc-y)^2);

    if(distance>=tM)
        Mc=true;
    else
        Mc=false;
    end
end

end