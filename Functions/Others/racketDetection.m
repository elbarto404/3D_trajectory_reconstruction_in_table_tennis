function racket=racketDetection(VideoName)

%this function defines the 2D position of the racket.
%
%the input is the name of the video. 
%the output is a vector with the perimeter of the found racket and the
%number of the frame.

v = VideoReader(VideoName);
numFrames=v.NumFrames;

%% Constants and Variables

%%%%%%%%%%% RACKET %%%%%%%%%%%

%diameter of the racket (approx 50 pixels)
rack_d=50;
racket=zeros(numFrames,2);
%fixed colour of the rackets(there are one side black and one side red)
hsv_b=[0.5417,0.1026,0.1529];
hsv_r=[0.9915,0.8405,0.6392];

%%%%%%%%%%% ROI %%%%%%%%%%%%%

roi_dimension=5*rack_d;
last_position_found=[];
%variable to analyze the first frame of the video
first= true;

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

while hasFrame(v)&i<2
    
    frame=readFrame(v);
    rack_not_found=false;
        
        %for the first frame
        if first == true
            %the user defines the initial position of the racket
            figure, imshow(frame), title ('Select the racket to track'),
            [x,y]=getpts;
            %define the first ROI based on the initial position
            [square_roi,x_min_ext,y_min_ext]=roiSquareDefinition(x,y,...
                [size(frame,2), size(frame,1)],roi_dimension);
            first=false;
            last_position_found=[x,y];
        end
        
        %%%%%%%%%%%% FIRST PASS THRESHOLDING %%%%%%%%%
     
     roi=imcrop(frame,square_roi);
     [binROI1_r,first_threshold_r]=firstPassThreshold(roi,first_threshold,hsv_r,max_iterations);
     [binROI1_b,first_threshold_b]=firstPassThreshold(roi,first_threshold,hsv_b,max_iterations);
     binROI1=binROI1_r|binROI1_b;
     %figure, imshow(binROI1), title('Binary image first step')
     
     %define connected components of the binary image
     conn_comp = bwconncomp(binROI1, 4);
     
     %if no object is found
     if(conn_comp.NumObjects==0)
         rack_not_found=true;
     end
        
        i=i+1;
end

end