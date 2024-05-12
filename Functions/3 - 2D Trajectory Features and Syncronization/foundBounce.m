function [bouncePosition,bounceInstant]=foundBounce(trajectory)
% Given the positions of the ball at every frame compute positions and time(frame) instants
% of each bounce 
% check if between 2 frames there is a bounce 
% in a bounce the y coordinate changes
% in order to check if in the frame i there is a bounce:
% we consider the 3 frames before and the 3 frames after i 
% if -there is a change in the direction of y
%    -there is NO change in the direction of x
% then there is a bounce around the frame i 


BounceFrames = [];
for i= 5:length(trajectory)-10
    %if there is a change of direction of the y coordinate in i 
    if ((trajectory(i-4, 2) < trajectory(i-3, 2))&& (trajectory(i-3, 2) < trajectory(i-2, 2)) && (trajectory(i-2, 2) < trajectory(i-1, 2)) && ...
         (trajectory(i-1, 2) < trajectory(i,2)) && (trajectory(i, 2) > trajectory(i+1, 2)) && ...
         (trajectory(i+1, 2) > trajectory(i+2,2))&& (trajectory(i+2, 2) > trajectory(i+3,2))&& (trajectory(i+3, 2) > trajectory(i+4,2)))
        
        % and if there is no change in the direction of x  
            if((trajectory(i-3, 1) > trajectory(i-2, 1)) && (trajectory(i-2, 1) > trajectory(i-1, 1)) && (trajectory(i-1, 1) > trajectory(i,1)) && ... 
                    (trajectory(i,1) > trajectory(i+1,1)) && (trajectory(i+1, 1) > trajectory(i+2,1))&& (trajectory(i+2, 1) > trajectory(i+3,1)) || ...
                    (trajectory(i-2, 1) < trajectory(i-1, 1)) && (trajectory(i-1, 1) < trajectory(i,1)) && ... 
                    (trajectory(i,1) < trajectory(i+1,1)) && (trajectory(i+1, 1) < trajectory(i+2,1))&& (trajectory(i+2, 1) < trajectory(i+3,1))) 
                % update the array adding in line the new candidate frame of bounce              
                BounceFrames = [BounceFrames; i];
            end
    end
end

% estimate the trajectory inside a defined interval with steps of 0.001

bounceInstant = [];
bouncePosition = [];

% define the interval in which the trajectory must be estimated
% we consider 2 frames after and 2 frames before the bounceframe i,with a step of 0.001
for j = 1:length(BounceFrames)
    interval = trajectory(BounceFrames(j)-2,3):0.001:trajectory(BounceFrames(j)+2,3);
    % inside the interval estimate the trajectory with the interpolation 
    interp_trajectory = interp1(trajectory(:, 3), trajectory(:, 1:2), interval , 'spline');
    
    for i = 4:length(interp_trajectory)-3
        if ((interp_trajectory(i-3, 2) < interp_trajectory(i-2, 2)) && (interp_trajectory(i-2, 2) < interp_trajectory(i-1, 2)) && ...
                (interp_trajectory(i-1, 2) < interp_trajectory(i,2)) && (interp_trajectory(i, 2) > interp_trajectory(i+1, 2)) &&  ...
                (interp_trajectory(i+1, 2) > interp_trajectory(i+2,2)) && (interp_trajectory(i+2, 2) > interp_trajectory(i+3,2)))
            bounceInstant = [bounceInstant ; interval(i)];
            bouncePosition = [bouncePosition; interp_trajectory(i, :)];
            
        end
    end
end
end