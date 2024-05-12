function r = isColor(color,PAR)
% This function takes as input a color in hsv and decide if it is a color or 
% not relaying on the specified parameters [PAR]. 
% It returns a boolean value [1 is a color, 0 is not a color].

    r = color(3)>PAR.V4Color;
    
    if(PAR.showSteps==2)
        if r
            fprintf(' is a Color')
        else
            fprintf(' is NOT a Color')
        end
    end
end
