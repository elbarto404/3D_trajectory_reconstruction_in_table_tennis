function plotLinesOnImage(lines, linewidth, I)
% This function plot the lines specified in the input [lines] on the image
% [I] in such a way that the lines are entairly contained in the image.
% The [lineswidth] is taken as an input.

    colors = 'rgbcmywkrgbcmywk';

    imgWidth  = length(I(1,:,1));
    imgHeight = length(I(:,1,1));

    MARGINS = [-1  0 0         ; %left
               -1  0 imgWidth  ; %right
                0 -1 0         ; %top
                0 -1 imgHeight]; %bottom
            
    for k=1:length(lines(:,1))
       marginIntersections = 0;
       p = zeros(2,3);
       for i=1:4
       c = cross(lines(k,:),MARGINS(i,:));
       %fprintf('\nIntersection of line # %d with margin # %d. [%d %d]',k,i,c(1)/c(3),c(2)/c(3))
          if c(1)/c(3)>=0 && c(1)/c(3)<=imgWidth+1 && c(2)/c(3)>=0 && c(2)/c(3)<=imgHeight+1 && marginIntersections < 2
              marginIntersections = marginIntersections + 1;
              p(marginIntersections,:) = c;
          end
       end
       %fprintf('\nLine # %d, marginIntersections = %d\n',k,marginIntersections)
       plot(p(:,1)./p(:,3),p(:,2)./p(:,3),'LineWidth',linewidth,'Color',colors(k))      
    end
end