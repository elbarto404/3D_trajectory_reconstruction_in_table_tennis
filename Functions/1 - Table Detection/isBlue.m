function r = isBlue(color,PAR)
% This function takes as input a color in hsv and decide if it is blue or 
% not relaying on the specified parameters [PAR]. 
% It returns a boolean value [1 is blue, 0 is not blue].
% It uses the custom function isWhite().

    r = isColor(color,PAR) && color(1)<2/3+PAR.HRange/2 && color(1)>2/3-PAR.HRange/2;
    
    if(PAR.showSteps==2)
        if r
            fprintf(' (is Blue)');
        else
            fprintf(' (is NOT Blue)');
        end
    end
end