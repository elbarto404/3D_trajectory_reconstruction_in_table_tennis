function r = isBlack(color,PAR)
% This function takes as input a color in hsv and decide if it is black or 
% not relaying on the specified parameters [PAR]. 
% It returns a boolean value [1 is black, 0 is not black].

    r = color(3)<PAR.V4Color;
    
    if(PAR.showSteps==2)
        if r
            fprintf(', is Black')
        else
            fprintf(', is NOT Black')
        end
    end
end