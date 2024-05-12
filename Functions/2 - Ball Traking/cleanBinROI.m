function binROI2=cleanBinROI(binROI2_unclean)

%this function clears a binary image removing all the small objects around
%the principal one.

comp = bwconncomp(binROI2_unclean, 4);
max=0;
vect_max=[];

%define the component with the maximum area
for k=1:comp.NumObjects
    
    if (size(comp.PixelIdxList{1,k},1)>max)
        max = size(comp.PixelIdxList{1,k},1);
        vect_max = comp.PixelIdxList{1,k};
    end
    
end

%define an image all black
binROI2=zeros(size(binROI2_unclean,1),size(binROI2_unclean,2));

%turn white only the pixels of the vect_max object
for pixel=1:size(vect_max,1)
    j=vect_max(pixel);
    binROI2(j)=1;
end

end