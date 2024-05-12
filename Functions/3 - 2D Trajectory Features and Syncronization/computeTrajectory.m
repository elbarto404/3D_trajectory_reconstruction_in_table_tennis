function completetrajectory = computeTrajectory(videoName,trajectory,intervalStep)

%this function takes as input the video and the output of the function
%"ball detection" and compute the complete and continous trajectory through
%interpolation of points 

%acquiring the video and the first frame
v = VideoReader(videoName);
Im =readFrame(v);
figure(1), imshow(Im), hold on, plot(trajectory(:,1),trajectory(:,2),'ow')


%The insterpolation function diverges if the trajectory starts or finishes
%with a set of Nan values (so with a set of Null values where the ball was
%not detected) 
%In the following code we compute:
%Start = the first frame with a non-Null value of the detected ball
%final = the last frame with a non-Null value of the detected ball
sent = 0;
for i = 1:length(trajectory)
    if ((trajectory(i,1)>1) && (sent==0))
        start = i;
        sent = 1;   
    end
    if trajectory(i,1)>1
        final=i
    end
end

%Then this is the definition of the interval that starts from the frame
%"start" and ends with the frame "final" with a step of 0.1 
interval = start:intervalStep:final;

% inside the interval estimate the trajectory with the interpolation 
completetrajectory = interp1(trajectory(:, 3), trajectory(:, 1:2), interval , 'spline');
completetrajectory(:,3) = interval(:);
%trajectory plotting
figure,imshow(Im), hold on; plot(completetrajectory(:,1), completetrajectory(:,2),'g','LineWidth',2);
title('Continous 2D Trajectory');
end
