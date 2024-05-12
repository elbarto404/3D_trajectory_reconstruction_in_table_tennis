function [cameraParams] = calibrationApp(loadPath,prefixImm,fromImm,toImm,extentionImm,PAR,saveFilename)
    if(PAR.camera)
        text='Calibration SX - ';
        len = 0.4;
    else
        text='Calibration DX - ';
        len = 0.3;
    end
    
    % Define images to process
    waitbar(len+0.01,PAR.wb,append(text,'Loading images'));
    if(PAR.showSteps); fprintf("\nCAMERA CALIBRATION\n\nImages to process:\n"); end
    
    imageFileNames = strings(toImm-fromImm+1,1);
    for i=fromImm:toImm
       imageFileNames(i) = loadPath + prefixImm + i + extentionImm;   
    end
    imageFileNames = cellstr(imageFileNames);
    if(PAR.showSteps); disp(imageFileNames); end

    
    % Detect checkerboards in images
    waitbar(len+0.02,PAR.wb,append(text,'Checkerboards detection'));
    if(PAR.showSteps); fprintf("\nDetect checkerboards in images..."); end
    
    [imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
    imageFileNames = imageFileNames(imagesUsed);

    
    % Read the first image to obtain image size
    if(PAR.showSteps); fprintf("\nRead the first image to obtain image size..."); end
    
    originalImage = imread(imageFileNames{1});
    [mrows, ncols, ~] = size(originalImage);

    
    % Generate world coordinates of the corners of the squares
    waitbar(len+0.04,PAR.wb,append(text,'Image processing'));
    if(PAR.showSteps); fprintf("\nGenerate world coordinates of the corners of the squares..."); end
    
    squareSize = 20;  % in units of 'millimeters'
    worldPoints = generateCheckerboardPoints(boardSize, squareSize);

    
    % Calibrate the camera
    waitbar(len+0.07,PAR.wb,append(text,'Parameters estimation'));
    if(PAR.showSteps); fprintf("\nCalibrate the camera..."); end
    
    [cameraParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
        'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
        'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
        'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
        'ImageSize', [mrows, ncols]);
    
    
    % Save the camera parameters in a file
    waitbar(len+0.09,PAR.wb,append(text,'Saving Parameters'));
    if(PAR.showSteps); fprintf("\nSaving parameters..."); end
    
    save(saveFilename,'cameraParams');
    
    if(PAR.showSteps)
        % Display parameter estimation errors
        fprintf("\nDisplay parameter estimation errors..."); 
        displayErrors(estimationErrors, cameraParams); 
    end
    
    if(PAR.showSteps==2)
        % View reprojection errors
        fprintf("\nView reprojection errors..."); 
        h1=figure; showReprojectionErrors(cameraParams); 

        % Visualize pattern locations
        fprintf("\nVisualize pattern locations..."); 
        h2=figure; showExtrinsics(cameraParams, 'CameraCentric'); 
    end


    if(PAR.showSteps); fprintf("\n\n  DONE\n"); end
end