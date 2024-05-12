function r = isGreen(color,PAR)
% This function takes as input a color in hsv and decide if it is green or 
% not relaying on the specified parameters [PAR]. 
% It returns a boolean value [1 is green, 0 is not green].
% It uses the custom function isWhite().

    r = isColor(color,PAR) && color(1)<1/3+PAR.HRange/2 && color(1)>1/3-PAR.HRange/2;
    
    if(PAR.showSteps==2)
        if r
            fprintf(' (is Green)');
        else
            fprintf(' (is NOT Green)')
        end
    end
end