function [RUC,Eruc]=rucDefinition(binROI2,centre)

%this function returns a binary value:
%       1 if the object has a rounded upper contour
%       0 otherwise
%and the error ERUC.
%the input is the binary ROI obtained from the second pass threshold and
%the centre of the OOI.

%variables
truc=0.1;
Eruc=0;

%define the pixels in the upper contour and the centre
extrema=regionprops(binROI2,'ConvexHull');
diameter=regionprops(binROI2,'EquivDiameter');

N=size(extrema.ConvexHull,1);
xc=centre.Centroid(1);
yc=centre.Centroid(2);
r=diameter.EquivDiameter/2;

%for every point in the upper contour
for i=1:N
    
    xi=extrema.ConvexHull(i,1);
    yi=extrema.ConvexHull(i,2);
    d=sqrt((xi-xc)^2+(yi-yc)^2);
    
    Eruc=Eruc+abs((d-r)/r);
end

Eruc=Eruc/N;


if(Eruc<truc)
    RUC=true;
else
    RUC=false;

end