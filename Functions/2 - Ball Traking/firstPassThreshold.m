function [binROI,first_threshold]=firstPassThreshold(roi,first_threshold,hsv,max_iterations)

%this function applies the first pass of the TPT algorithm.
%the inputs are the Region of Interest, the first threshold that will be
%tuned at every iteration, the colour of the ball and the maximum number of
%iterations.
%the function returns a binarized image and the tuned first threshold


%variables 
i=0;
candidate=0;
%min=[objects found, minimum threshold]
%best threshold found 
min=[Inf,4];

%constant for threshold tuning
m=5;

while(not(candidate)&&i<max_iterations)
    
    %create binary image
    binROI=createBinImage(roi,hsv,first_threshold);
    %bwconncomp returns the connected components found in the binary image
    candidateBalls = bwconncomp(binROI, 4);
    
    %if multiple objects are found in the binary image
    if (candidateBalls.NumObjects > 1)
        %if the number of candidates balls is less than the ones obtained
        %in the previous iterations
        if(min(1)>candidateBalls.NumObjects)
            min=[candidateBalls.NumObjects,first_threshold];
        end
        %define a minimum value for the threshold
        if(first_threshold>=4)
            first_threshold=first_threshold*(100-m)/100;
        end
    
    %if only one object is found
    elseif (candidateBalls.NumObjects == 1)
        candidate=1;
        min=[candidateBalls.NumObjects,first_threshold];
        
    %if no object is found
    else
      first_threshold=first_threshold*(100+m)/100;
    end   
        
    i=i+1;
end

%apply the best threshold to the roi

first_threshold=min(2);
binROI=createBinImage(roi,hsv,first_threshold);

end