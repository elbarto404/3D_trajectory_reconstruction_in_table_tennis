function [binROI2,x_min_int,y_min_int]=secondPassThreshold(roi,second_threshold,hsv,...
    centroid,ball_dimension,max_iterations)

%this function applies the second step of the TPT algorithm. The inputs are
%the original ROI, the second threshold, the colour of the ball, the 
%dimension of the ball, the position of the centroid and the maximum number
%of iterations.

%variables 
i=0;
area=false;
roi_dimension=50;   %fixed
ball_area=pi*(ball_dimension/2)^2;

%min=[(Ab-Ao), threshold]
%best threshold found
min=[Inf,0];

%constants for threshold tuning
v2=5*0.01;
g=5;

%crop the roi
[square_roi,x_min_int,y_min_int]=roiSquareDefinition(centroid(1),centroid(2),...
    [size(roi,2), size(roi,1)],roi_dimension);
roi=imcrop(roi,square_roi);

while (not(area)&&i<max_iterations)
    
    %create binary image
    binROI2=createBinImage(roi,hsv,second_threshold);
    area_can= regionprops(binROI2,'Area');
    area_candidate=area_can(1).Area;
    fun=(ball_area-area_candidate)/ball_area;
    
    if(fun<v2&&fun>-v2)
        area=true;
        min=[abs(ball_area-area_candidate),second_threshold];
    elseif(area_candidate>ball_area)
        if(abs(ball_area-area_candidate)<min(1))
            min(1)=abs(ball_area-area_candidate);
            min(2)=second_threshold;
        end
        %reduce threshold
        second_threshold=second_threshold*(100-g)/100;
    else
        if(abs(ball_area-area_candidate)<min(1))
            min(1)=abs(ball_area-area_candidate);
            min(2)=second_threshold;
        end
        %increase threshold
        second_threshold=second_threshold*(100+g)/100;
    end
    
    i=i+1;
    
end

%create binary image
binROI2=createBinImage(roi,hsv,min(2));

end