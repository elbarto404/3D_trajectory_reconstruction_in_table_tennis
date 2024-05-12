function [trajectory,hsv]=ballTracking(VideoName,hsvopt)

%this function defines the 2D trajectory of the ball.
%
%the input are the name of the video and the (optional) colour of the ball.
%the output are a vector NumFrames x 3 with the trajectory of the ball 
% [x,y,numFrame] and the hsv colour of the ball.

v = VideoReader(VideoName);
numFrames=v.NumFrames;

%% Constants and Variables

%%%%%%%%%%% BALL %%%%%%%%%%%
%good orange colour [0.1180,0.8863,1]

%diameter of the ball (12 pixels)
ball_d=12;
trajectory=zeros(numFrames,3);
%trajectory=zeros(50,3);

%%%%%%%%%%% ADAPTIVE ROI %%%%%%%%%%%%%

%initial ROI height and width
roi_dimension=20*ball_d;
%if ball is not found
k=3;
last_position_found=[];
%variable to analyze the first frame of the video
first= true;

visualizer = 15;

%%%%%%%%%%% TWO PASS THRESHOLDING %%%%%%%%%%%%

%first iteration thresholds
first_threshold=10;
second_threshold=20;
%maximum number of iterations for the TPT
max_iterations=5;

%%%%%%%%%%% PREDICTED LOCATION %%%%%%%%%%%%%

previous_position=[];
position=[];
next_predicted_position=[];

%% Main Loop

i=1;

while hasFrame(v)
    
    frame=readFrame(v);
    ball_not_found=false;
        
        %for the first frame
        if first == true
            %the user defines the initial position of the ball
            figure, imshow(frame), title ('Select the ball'),
            [x,y]=getpts;
            h=msgbox('Selection done! Ball Traking is running');
            %if the colour of the ball is an input 
            if(exist('hsvopt'))
                hsv=hsvopt;
            else
                %define the colour of the ball
                hsv=defineBallColour(x,y,frame);
            end
            %define the first ROI based on the initial position
            [square_roi,x_min_ext,y_min_ext]=roiSquareDefinition(x,y,...
                [size(frame,2), size(frame,1)],roi_dimension);
            first=false;
            last_position_found=[x,y];
        end
 
     %%%%%%%%%%%% FIRST PASS THRESHOLDING %%%%%%%%%
     
     roi=imcrop(frame,square_roi);
     [binROI1,first_threshold]=firstPassThreshold(roi,first_threshold,hsv,max_iterations);
     if (visualizer < 15)
     figure, imshow(binROI1), title('Binary image first step');
     visualizer = visualizer +1;
     end
     
     %define connected components of the binary image
     conn_comp = bwconncomp(binROI1, 4); 
     
     %if no object is found
     if(conn_comp.NumObjects==0)
         ball_not_found=true;
     end
     
     if (not(ball_not_found))
         
        %define the centroids of the connected components 
        centroids= regionprops(conn_comp,'Centroid');  
     
        %define the candidate balls (suppression neighborhood)
        candidate_balls=candidateBallsDefinition(centroids,ball_d);
        
        %best ball 
        %min=[Error, x_centre, y_centre, x_min_int, y_min_int]
        min = [Inf, 0, 0, 0, 0];
     
            %apply the following algorithm to all the candidate balls
            for object=1:size(candidate_balls,1)
           
                %%%%%%%%%%%% SECOND PASS THRESHOLDING %%%%%%%%%%%%%
            
                [binROI2_unclean,x_min_int,y_min_int]=secondPassThreshold(roi,second_threshold,...
                     hsv,candidate_balls(object,:),ball_d,max_iterations);
                 if (visualizer < 15)
                     figure, imshow(binROI2_unclean), title('Binary image not clean second step');
                      visualizer = visualizer +1;
                 end
                 
    
                 %clean the binary image
                 binROI2=cleanBinROI(binROI2_unclean);
                 if (visualizer < 15)
                 figure, imshow(binROI2), title('Binary image second step');
                 visualizer = visualizer +1;
                 end
                 
                 %%%%%%%%%%% FIRST STAGE EVALUATION %%%%%%%%%%%%%%%
    
                 centre=regionprops(binROI2,'Centroid');
                 tM=20;
            
                 [RUC,Eruc]=rucDefinition(binROI2,centre);
                 T=TDefinition(binROI2,next_predicted_position,x_min_ext,...
                    x_min_int,y_min_ext,y_min_int,centre);
                 Mc=McDefinition(centre, last_position_found, tM, x_min_ext, ...
                    x_min_int, y_min_ext, y_min_int);
                 Mp=MpDefinition(next_predicted_position, last_position_found, ...
                     tM, x_min_ext, x_min_int, y_min_ext, y_min_int);
                 check=RUC+T+Mc+Mp;
            
                 if(check>=2)
                     
                     %%%%%%%%%%% SECOND STAGE EVALUATION %%%%%%%%%%%%%%%
                     
                     E=errorDefinition(binROI2,Eruc,ball_d,check);
                     
                     %store the minimum error with the relative centre
                     if(E<=min(1))
                         min(1)=E;
                         min(2)=centre.Centroid(1);
                         min(3)=centre.Centroid(2);
                         min(4)=x_min_int;
                         min(5)=y_min_int;
                     end
                 
                 end
                   
            end
            
            %definition of the position of the ball
            if(min(1)==Inf)
                ball_not_found=true;
            else
                x=min(2)+x_min_ext+min(4);
                y=min(3)+y_min_ext+min(5);
                position=[x,y];
            end
          
     end
     
     if(ball_not_found)
         
         position=[];
         next_predicted_position=[];
         trajectory(i,:)= [NaN,NaN,i];
         %increase the threshold to find the ball again
         first_threshold=10;
         %adaptive roi (increase the ROI)
         roi_dimension=k*roi_dimension;
         [square_roi,x_min_ext,y_min_ext]=roiSquareDefinition(last_position_found(1),...
             last_position_found(2),[size(frame,2), size(frame,1)],roi_dimension);
        
     else
         
         last_position_found=position;
         trajectory(i,:)=[position(1),position(2),i];
         next_predicted_position=predictPosition(previous_position,position,frame);
         %adaptive roi (decrease the ROI)
         roi_dimension=20*ball_d;
         %update ball colour
         %hsv=defineBallColour(position(1),position(2),frame);
         if(not(isempty(next_predicted_position)))
            [square_roi,x_min_ext,y_min_ext]=roiSquareDefinition(next_predicted_position(1),...
                next_predicted_position(2),[size(frame,2), size(frame,1)],roi_dimension);
         else
            [square_roi,x_min_ext,y_min_ext]=roiSquareDefinition(x,...
                y,[size(frame,2), size(frame,1)],roi_dimension);
         end
             
     end
     
     previous_position=position;
     i=i+1;

end

%figure(1), imshow(frame), hold on, plot(trajectory(:,1),trajectory(:,2),'ow')

end