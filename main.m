clear all
close all
clc

addpath(genpath('Functions'));

skip_Calibration = 0; %Put 1 to skip the calibration step loading previous data 



%% Video Reading and Acquisition

wp = [0 20 272 60];
wb=waitbar(0,'Video Reading and Acquisition','Position',wp);


videoNameDX='Media/Clips/doubleBounceOrangeBallDX.mp4';
videoDX = VideoReader(videoNameDX);
frameDX =readFrame(videoDX);
%figure, imshow(frameDX);


videoNameSX = 'Media/Clips/doubleBounceOrangeBallSX.mp4';
videoSX = VideoReader(videoNameSX);
frameSX =readFrame(videoSX);
%figure, imshow(frameSX);



%% Table Detection

% TABLE DATA
% Specify the input videos for table detection.
% In those videos / frames the entire table must be visible due to reduce computation
% errors, for this reason there is a separate loading procedure

DXvideoReader = VideoReader('Media/Clips/longCrossPlayOrangeBallDX.mp4');
tableFrameDX= im2double(readFrame(DXvideoReader));
figure, imshow(tableFrameDX);
SXvideoReader = VideoReader('Media/Clips/longCrossPlayOrangeBallSX.mp4');
tableFrameSX= im2double(readFrame(SXvideoReader));
figure, imshow(tableFrameSX);
% Specify the world coordinates of the verices of the table (in centimeters)
a_world =[2, 2];
b_world = [2, 150.5];
c_world = [272 , 150.5];
d_world = [272 , 2];

worldPoints = [ a_world; b_world; c_world ; d_world];


% PARAMETERS
% Tune the following parameters to personalize the detection based on your
% recording set-up

% Pixel selection alghoritm
PAR.nearTh       = 3    ; %[pix] Max Dynamic Threshold for near points (it also trys to decrease it)
PAR.farTh        = 20   ; %[pix] Fixed Threshold for far points

% Color detection alghoritm
PAR.HRange      = 0.40 ; %[0-1] H range for the same color
PAR.S4White     = 0.32 ; %[0-1] Max Saturation for White
PAR.V4White     = 0.65 ; %[0-1] Min Brightness for White 
PAR.V4Color     = 0.20 ; %[0-1] Min Brightness for Colors 
PAR.pickingMode = 0    ; %1 for detecting colors by averaging the colors of the four neighbours of the keypoint
                         %0 for detecting colors by picking the color of the nearest pixel to the keypoint 
% Sides Recogniction alghoritm
PAR.yTh        = 250  ; %[pix] Start of ROI along Y axis                                
PAR.thetaTh    = 6  ;   %[deg] Angular threshold for clustering

% Display Options
PAR.showSteps    = 2   ; %1 for showing only figures (recomended)
                         %2 for showing figures and text (complete / debugging mode)
                         %0 for showing nothing (faster)

                                  
% LINES DETECTION
% Using Canny and HougLines it detects the straight lines on the image
waitbar(0.1,wb,'Line Detection DX','Position',wp);
linesDX = lines4Detection(tableFrameDX,PAR);

waitbar(0.15,wb,'Line Detection SX','Position',wp);
linesSX = lines4Detection(tableFrameSX,PAR);  
  
%%
% TABLE DETECTION 
% It computes the vertices of the table filtering and grouping the set of
% lines based on some key features such as their orientation and colors of
% the neighbors pixels

waitbar(0.2,wb,'Table Detection DX','Position',wp);
PAR.camera = 0  ;        %0 Right Camera                           
DXVertices = detectTableFeatures(linesDX,tableFrameDX,PAR);

waitbar(0.25,wb,'Table Detection SX','Position',wp);
PAR.camera = 1  ;        %1 Left Camera                            
SXVertices = detectTableFeatures(linesSX,tableFrameSX,PAR);



%% Ball Tracking and 2D Trajectory Estimation
% It makes the ball detection and traking on the DX and SX videos, then 
% handles the resulting discreete trajectories to prepare them for the next steps.

waitbar(0.3,wb,'Ball Tracking DX','Position',wp);
[trajectoryDX,hsv]=ballTracking(videoNameDX);

waitbar(0.35,wb,'Ball Tracking SX','Position',wp);
[trajectorySX,hsv2]=ballTracking(videoNameSX,hsv);

figure, imshow(frameDX), hold on, plot(trajectoryDX(:,1),trajectoryDX(:,2),'ow')
figure, imshow(frameSX), hold on, plot(trajectorySX(:,1),trajectorySX(:,2),'ow')


% 2D Trajectories Purging and Fitting

% Stating from the discreete trajectory taken from the ball tracking , it 
% computes the complete and continous trajectory through interpolation
% of the points. Doing that the resulting trajectory starts and ends with 
% real values ( not Nan ).

%Then this is the definition of the interval that starts from the frame
%"start" and ends with the frame "final" with a the chosen step 
intervalStep = 0.1;

waitbar(0.4,wb,'Continous 2D Trajectory Recostruction DX','Position',wp);
completetrajectoryDX = computeTrajectory(videoNameDX,trajectoryDX, intervalStep);

waitbar(0.41,wb,'Continous 2D Trajectory Recostruction SX','Position',wp);
completetrajectorySX = computeTrajectory(videoNameSX,trajectorySX, intervalStep);



%% Trajectory Features Detection and Syncronization
% It detects the Ball Bounces and the Raket Shots in the 2D Trajectories,
% those features, in addition to helping the arbitration of the match,
% can be used to syncronise the two videos if they aren't.


% BOUNCE DETECTION

waitbar(0.42,wb,'Bounce Detection DX','Position',wp);
[bouncePointDX,BounceInstantDX]=foundBounce(completetrajectoryDX);
figure, imshow(frameDX),hold on; plot(bouncePointDX(:,1), bouncePointDX(:,2), 'r*','LineWidth', 24);
plot(completetrajectoryDX(:,1), completetrajectoryDX(:,2),'w','LineWidth',2);
title('Bounce Detection');

waitbar(0.43,wb,'Bounce Detection SX','Position',wp);
[bouncePointSX,BounceInstantSX]=foundBounce(completetrajectorySX);
figure, imshow(frameSX),hold on; plot(bouncePointSX(:,1), bouncePointSX(:,2), 'r*','LineWidth', 24);
plot(completetrajectorySX(:,1), completetrajectorySX(:,2),'w','LineWidth',2);
title('Bounce Detection');

% SHOT DETECTION

waitbar(0.44,wb,'Shot Detection DX','Position',wp);
[ShotPositionDX,ShotInstantDX,ShotFramesDX]=racketShot(completetrajectoryDX);
figure, imshow(frameDX),hold on; plot(ShotPositionDX(:,1), ShotPositionDX(:,2), 'g*','LineWidth', 24);
plot(completetrajectoryDX(:,1), completetrajectoryDX(:,2),'w','LineWidth',2);
title('Shot Detection');

waitbar(0.46,wb,'Shot Detection SX','Position',wp);
[ShotPositionSX,ShotInstantSX,ShotFramesSX]=racketShot(completetrajectorySX);
figure, imshow(frameSX),hold on; plot(ShotPositionSX(:,1), ShotPositionSX(:,2), 'g*','LineWidth', 24);
plot(completetrajectorySX(:,1), completetrajectorySX(:,2),'w','LineWidth',2);
title('Shot Detection');


% VIDEO SYNCRONIZATION
% Compute the length of the longest trajectory and defines:
% FinaltrajectoryDX and FinaltrajectorySX that are the 2 final
% trajectories:
% - Synchronized 
% - Starting with the first non null frame in common 
% - Ending with the last non null frame in common 


% Method 1: Synchronization using the last ball bounce (in common)
% Firstly found the difference 'delta' ( in terms of frames) between the
% last bounce in the DX and in the SX videos
% and Defines the new trajectories Synchronized in the last bounce

%waitbar(0.48,wb,'Syncronization BounceBased','Position',wp);
%[FinaltrajectoryDX,FinaltrajectorySX]= synchronizationBounceBased(BounceInstantDX,BounceInstantSX,completetrajectoryDX,completetrajectorySX);


% Method 2 :Synchronization using the last Shot (in common)

%waitbar(0.48,wb,'Syncronization ShotBased','Position',wp);
%[FinaltrajectoryDX,FinaltrajectorySX]= synchronizationBounceBased(ShotInstantDX,ShotInstantSX,completetrajectoryDX,completetrajectorySX);


% Method 3: Synchronization on time

waitbar(0.48,wb,'Syncronization','Position',wp);
[FinaltrajectoryDX,FinaltrajectorySX]= synchronizationTimeBased(completetrajectoryDX,completetrajectorySX);



% PLOT the final 2D Trajectories reconstructed and synchronized
  
figure, imshow(frameDX), hold on; plot(FinaltrajectoryDX(:,1), FinaltrajectoryDX(:,2),'g','LineWidth',2); 
figure, imshow(frameSX), hold on; plot(FinaltrajectorySX(:,1), FinaltrajectorySX(:,2),'g','LineWidth',2);     



%% Calibration
% The calibration phase is done using the calibrationApp tool provided from
% Matlab and customized on our needs.

if(skip_Calibration)
    
    waitbar(0.5,wb,'Calibration - Loading Parameters','Position',wp);
    DXcameraParams = load("Variables/calibrationParamDX.mat",'cameraParams').cameraParams;
    SXcameraParams = load("Variables/calibrationParamDX.mat",'cameraParams').cameraParams;
    
else

    PAR.showSteps  = 2;   %1 for showing only text
                                   %2 for showing figures and text 
                                   %0 for showing nothing

    PAR.camera = 0  ;        %0 Right Camera  
    PAR.wb = waitbar(0.5,wb,'Calibration DX','Position',wp);
    DXcameraParams = calibrationApp("Media\Photos\calibrationDX","\IMG_",1,24,".JPG",PAR,"Variables/calibrationParamDX.mat");

    PAR.camera = 1  ;        %1 Left Camera
    PAR.wb = waitbar(0.6,wb,'Calibration SX','Position',wp);
    SXcameraParams = calibrationApp("Media\Photos\calibrationSX","\IMG_",1,24,".JPG",PAR,"Variables/calibrationParamSX.mat");

end

% There are other methods to calibrate the cameras, such as:
% - calibration5Eqn
% - calibration6Pnt
% - calibrationHomographies
% but they are less precise and less reliable so they produce execution errors 


% Extrapolate intrinsic matrix K for each camera

waitbar(0.7,wb,'3D Recostruction - Intrinsics DX','Position',wp);
KDx = DXcameraParams.IntrinsicMatrix';

waitbar(0.71,wb,'3D Recostruction - Intrinsics SX','Position',wp);
KSx = SXcameraParams.IntrinsicMatrix';


% Compute extrinsics parameters:

% For each camera we have: - Table Vertices in poxel coordinates
%                          - Table Vertices in world coordinates
%                          - Camera Intrinsic matrix

% Starting from those we can compute the Location and the Orientation of each
% camera in World Coordinates

waitbar(0.72,wb,'3D Recostruction - Extrinsics DX','Position',wp);
[DXrotationMatrix,DXtranslationVector] = extrinsics(DXVertices,worldPoints,DXcameraParams);
[DXorientation, DXlocation] = extrinsicsToCameraPose(DXrotationMatrix,DXtranslationVector);

waitbar(0.74,wb,'3D Recostruction - Extrinsics SX','Position',wp);
[SXrotationMatrix,SXtranslationVector] = extrinsics(SXVertices,worldPoints,SXcameraParams);
[SXorientation, SXlocation] = extrinsicsToCameraPose(SXrotationMatrix,SXtranslationVector);


% Showing results:
% DX Camera
figure; hold on; 
plotCamera('Location',DXlocation,'Orientation',DXorientation,'Size',20); 
pcshow([worldPoints,zeros(size(worldPoints,1),1)],'VerticalAxisDir','down','MarkerSize',40);

% SX Camera
figure; hold on; 
plotCamera('Location',SXlocation,'Orientation',SXorientation,'Size',20); 
pcshow([worldPoints,zeros(size(worldPoints,1),1)],'VerticalAxisDir','down','MarkerSize',40);

% DX and SX Camera in the same scene
figure; hold on; 
plotCamera('Location',SXlocation,'Orientation',SXorientation,'Size',20);
plotCamera('Location',DXlocation,'Orientation',DXorientation,'Size',20);
pcshow([worldPoints,zeros(size(worldPoints,1),1)], 'VerticalAxisDir','down','MarkerSize',40);



%% 3D Trajectory Recostruction
% Having the intrinsic and the estrinsic parameters of the cameras and 
% finding the projectionmatrix of each camera and triangulating the trajectories, 
% it recontruct the 3D trajectory.


% Extrapolate projection matrix 4x3 for each camera  
% We can use this matrix to project 3-D world points in homogeneous 
% coordinates into an image.

waitbar(0.76,wb,'3D Recostruction - Projection Matrix DX','Position',wp);
DXcamMatrix = cameraMatrix(DXcameraParams,DXrotationMatrix,DXtranslationVector);

waitbar(0.77,wb,'3D Recostruction - Projection Matrix SX','Position',wp);
SXcamMatrix = cameraMatrix(SXcameraParams,SXrotationMatrix,SXtranslationVector);


% It use the triangulation alghorithm to merge DX and SX Trajectories 
% into the final 3D Trajectory in World coordinates.
% It returns the 3D locations of the matching pairs in a world coordinate system. 
% These locations are defined by camera projection matrices.

waitbar(0.78,wb,'3D Recostruction - Triangulation','Position',wp);
Final_3DTrajectory = triangulate(FinaltrajectoryDX(:, 1:2), FinaltrajectorySX(:, 1:2), DXcamMatrix, SXcamMatrix);

% Plot ball's final 3D Trajectory in space
figure,plot3(Final_3DTrajectory(:,1),Final_3DTrajectory(:,2),(Final_3DTrajectory(:,3)));
xlabel( 'X' ); ylabel('Y'); zlabel('Z');



%% Final 3D Animation 1 (without cameras)
% 1st animation in the environment in world reference frame With the
% reconstructed table

waitbar(0.8,wb,'Final 3D Animation without cameras','Position',wp);

figure; grid on; view(43, 24); hold on; 
xlabel('x [cm]'); ylabel('y [cm]'); zlabel('z [cm]');
curve = animatedline('lineWidth', 2, 'color','m');
set(gca, 'XLim', [-10 290], 'YLim', [-80 220], 'ZLim', [-120 180]);

% Plot Table
Plot3DTable();

% Animated Trajectory
for i=1:length(Final_3DTrajectory)
  addpoints(curve, Final_3DTrajectory(i, 1), Final_3DTrajectory(i, 2), Final_3DTrajectory(i, 3));
  head = scatter3(Final_3DTrajectory(i, 1), Final_3DTrajectory(i, 2), Final_3DTrajectory(i, 3),'filled', 'MarkerFaceColor', 'm', 'MarkerEdgeColor', 'm');
  drawnow;
  delete(head);
end



%% Final 3D Animation 2 ( with cameras)
% 2nd Animation in the environment in world reference frame With the
% reconstructed table and Cameras

waitbar(0.9,wb,'Final 3D Animation with cameras','Position',wp);

figure; grid on; view(43, 24); hold on;
xlabel('x [cm]'); ylabel('y [cm]'); zlabel('z [cm]');
curve = animatedline('lineWidth', 2, 'color',[1 0.69 0.09]);
set(gca, 'XLim', [-160 400], 'YLim', [-260 300], 'ZLim', [-76 484]);

% Plot Table 
Plot3DTable();

% Plot Cameras
plotCamera('Location',SXlocation,'Orientation',SXorientation,'Size',20);
plotCamera('Location',DXlocation,'Orientation',DXorientation,'Size',20);

% Animated Trajectory
for i=1:length(Final_3DTrajectory)
  addpoints(curve, Final_3DTrajectory(i, 1), Final_3DTrajectory(i, 2), Final_3DTrajectory(i, 3));
  head = scatter3(Final_3DTrajectory(i, 1), Final_3DTrajectory(i, 2), Final_3DTrajectory(i, 3),'filled', 'MarkerFaceColor', [1 0.69 0.09], 'MarkerEdgeColor', [1 0.69 0.09]);
  drawnow;
  delete(head);
end



waitbar(1,wb,'Done!','Position',wp);

