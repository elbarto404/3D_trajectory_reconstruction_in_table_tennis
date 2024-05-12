function K = calibrationHomographies(PAR)


% NOT COMPLETE


imageFileNames = {
    'Media\Photos\calibrationHomographiesDX\calibrationClipDX001.jpg',...
    'Media\Photos\calibrationHomographiesDX\calibrationClipDX002.jpg',...
    'Media\Photos\calibrationHomographiesDX\calibrationClipDX003.jpg',...
    'Media\Photos\calibrationHomographiesDX\calibrationClipDX004.jpg',...
    'Media\Photos\calibrationHomographiesDX\calibrationClipDX005.jpg',...
    'Media\Photos\calibrationHomographiesDX\calibrationClipDX006.jpg',...
    'Media\Photos\calibrationHomographiesDX\calibrationClipDX007.jpg'
    };

    % Pixel selection parameters
    PAR.nearTh     = 2    ; %[pix] Threshold for near points
    PAR.farTh      = 20   ; %[pix] Threshold for far points

    % Color detection parameters
    PAR.HRange     = 0.33 ; %[0-1] H range for the same color
    PAR.S4Color    = 0.15 ; %[0-1] Min Saturation to have a color
    PAR.V4White    = 0.70 ; %[0-1] Min Brightness for White 
    PAR.V4Color    = 0.25 ; %[0-1] Min Brightness for Colors 

    % Others
    PAR.thetaRange = 6    ; %[Deg] Range of the line direction for grouping same oriented lines
    PAR.showSteps  = 2    ; %1 for showing only figures... 
                                     %2 for showing figures and text (debugging mode)...
                                     %0 for showing nothing
    
good=0;
for i=1:length(imageFileNames)
    imageFileNames{i}
    I = im2double(imread(imageFileNames{i}));
    
    % Lines Detection
    lines = lines4Detection(I,PAR);
                                 
    % Table Sides detection                        
    tableSides = detectTableSides(lines,I,PAR);

    
    if(tableSides ~= 0)
        good = good+1
        goodImageFileNames(good)= imageFileNames(i);
        
        % Table rectification
        H(good).mat(:,:) = tableRectification(tableSides,I,PAR);
    end
end
K=0;
goodImageFileNames
end