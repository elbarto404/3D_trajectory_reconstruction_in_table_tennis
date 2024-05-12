function next_predicted_position=predictPosition(previous_position,position,frame)

%this function applies linear extrapolation in order to predict the
%position of the ball in the next frame.
%the inputs are the previous position, the actual position of the ball and
%the frame (to check if the predicted position is inside). 

if (isempty(previous_position))
    next_predicted_position=[];
else
    x1=previous_position(1);
    y1=previous_position(2);
    x2=position(1);
    y2=position(2);
    %define the slope of the line connecting the previous_position and the
    %actual position
    m=(y2-y1)/(x2-x1);
    theta=atan(m);
    distance=sqrt((x1-x2)^2+(y1-y2)^2);
    x=distance*cos(theta);
    y=distance*sin(theta);
    
    if(x2<x1&&y2<y1)
        next_predicted_position=[x2-x,y2-y];
    elseif (x2<x1)
        next_predicted_position=[x2-x,y2+abs(y)];
    else
        next_predicted_position=[x2+x,y2+y];
    end
    
    %check if the position is inside the frame
    if(next_predicted_position(1)<0|next_predicted_position(1)>size(frame,2)...
            |next_predicted_position(2)<0|next_predicted_position(2)>size(frame,1))
        next_predicted_position=[];
    end
    
end

end
