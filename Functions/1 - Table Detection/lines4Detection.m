function lines = lines4Detection(I,PAR)
%This function gives the lines recognized in the image I using canny and
%hough algorithms.
%It is setted properly for Table Detection and for Strips Detection
%
%It also support 3 plot options specified in PAR:
% PAR.showSteps  = %1 for showing only figures... 
                   %2 for showing figures and text (debugging mode)...
                   %0 for showing nothing


    %Edges detection
    Ig = rgb2gray(I);
    edges = edge(Ig, 'canny',[0.23,0.25]);
    if(PAR.showSteps)
        figure, imshow (edges), title('Edges obtained with Canny'); 
        %saveas(figure(2),'Media/ProjectFigures/2_edges4Detection.jpg');
    end

    %Hough Algorithm
    [H,theta,rho] = hough(edges);

    %houghpeaks function defines the peaks in the Hough space defined by H. The
    %suppression neighborhood is modified in order to detect the external lines
    %of the table.
    P = houghpeaks(H,150,'threshold',ceil(0.15*max(H(:))),'NHoodSize',[3,3]);
    lines = houghlines(edges,theta,rho,P,'FillGap',60,'MinLength',118);

    %Plot lines
    if(PAR.showSteps)
        figure; imshow(I); title('Lines obtained using Hough Transform'); hold on; 
        for k = 1:length(lines)
           x = [lines(k).point1; lines(k).point2];
           plot(x(:,1),x(:,2),'LineWidth',2,'Color','green');

           %Plot beginnings and ends of lines
           plot(x(1,1),x(1,2),'x','LineWidth',2,'Color','yellow');
           plot(x(2,1),x(2,2),'x','LineWidth',2,'Color','red');
        end
        %saveas(figure(3),'Media/ProjectFigures/3_lines4Detection.jpg');
    end                   
                                     
end