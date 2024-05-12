function [ShotPosition,ShotInstant, ShotFrames]=racketShot(trajectory)

%given the positions of the ball at every frame compute positions and time(frame) instants
%of each shot 

% check if between 2 frames there is a shot 
% in a shot we focus only on the x coordinate, of course the x coordinate
% changes in a shot
% in order to check if in the frame i there is a shot:
% we consider the 2 frames before and the 2 frames after i 
% if there is a change in the direction of x
% then there is a shot around the frame i 


ShotFrames = [];
for i= 5:length(trajectory)- 100
    %if there is a change of direction of the x coordinate in i 
    if ((trajectory(i-4, 1) < trajectory(i-3, 1)) &&(trajectory(i-3, 1) < trajectory(i-2, 1)) && (trajectory(i-2, 1) < trajectory(i-1, 1)) && (trajectory(i-1, 1) < trajectory(i,1)) && ...
            (trajectory(i, 1) > trajectory(i+1, 1)) && (trajectory(i+1, 1) > trajectory(i+2,1))&& (trajectory(i+2, 1) > trajectory(i+3,1)) || ...
            (trajectory(i-3, 1) > trajectory(i-2, 1)) &&(trajectory(i-2, 1) > trajectory(i-1, 1)) && (trajectory(i-1, 1) > trajectory(i,1)) && ...
            (trajectory(i, 1) < trajectory(i+1, 1)) && (trajectory(i+1, 1) < trajectory(i+2,1))&& (trajectory(i+2, 1) < trajectory(i+3,1))&& (trajectory(i+3, 1) < trajectory(i+4,1)))
                % update the array adding in line the new candidate frame of bounce              
                ShotFrames = [ShotFrames; i];
            end
    
end

% estimate the trajectory inside a defined interval with steps of 0.001

ShotInstant = [];
ShotPosition = [];

% define the interval in which the trajectory must be estimated
% we consider 3 frames after and 3 frames before the Shot frame i,with a step of 0.001
for j = 1:length(ShotFrames)
    interval = trajectory(ShotFrames(j)-2,3):0.001:trajectory(ShotFrames(j)+2,3);
    interp = interp1(trajectory(:, 3), trajectory(:, 1:2), interval , 'spline');
    for i = 4:length(interp)- 3
        if (((interp(i-3, 1) < interp(i-2, 1)) && (interp(i-2, 1) < interp(i-1, 1)) && (interp(i-1, 1) < interp(i,1)) && ...
                (interp(i, 1) > interp(i+1, 1)) && (interp(i+1, 1) > interp(i+2,1)) && (interp(i+2, 1) > interp(i+3,1))) || ...
            (interp(i-3, 1) > interp(i-2, 1)) && (interp(i-2, 1) > interp(i-1, 1)) && (interp(i-1, 1) > interp(i,1)) && ...
                (interp(i, 1) < interp(i+1, 1)) && (interp(i+1, 1) < interp(i+2,1)) && (interp(i+2, 1) < interp(i+3,1)))
            ShotInstant = [ShotInstant ; interval(i)];
            ShotPosition = [ShotPosition; interp(i, :)];
            
        end
    end
end
end