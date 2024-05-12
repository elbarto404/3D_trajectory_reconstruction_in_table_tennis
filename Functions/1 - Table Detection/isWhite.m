function r = isWhite(color,PAR)
% This function takes as input a color in hsv and decide if it is white or 
% not relaying on the specified parameters [PAR]. 
% It returns a boolean value [1 is white, 0 is not white].
    r = color(2)<PAR.S4White && color(3)>PAR.V4White;
    
    if(PAR.showSteps==2)
        if r
            fprintf(' is White')
        else
            fprintf(' is NOT White')
        end
    end
end




