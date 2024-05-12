function binROI=createBinImage(roi,hsv,threshold)

%this function creates a binary image where all pixels with a colour
%difference smaller than the threshold are turned white and all the pixels
%with a colour difference greater than the threshold are turned black

roi_hsv=rgb2hsv(roi);
hue=roi_hsv(:,:,1);
sat=roi_hsv(:,:,2);
val=roi_hsv(:,:,3);

if (hsv(3)<0.2)      %black
    binROI=(val<0.2);
    
else  
    binHue= (hue>=hsv(1)-threshold/360)&(hue<=hsv(1)+threshold/360);
    binSat= (sat>=hsv(2)-threshold/50)&(sat<=hsv(2)+threshold/50);
    binVal= (val>=hsv(3)-threshold/100)&(val<=hsv(3)+threshold/100);

    binROI= binHue&binSat&binVal;
end
    
end