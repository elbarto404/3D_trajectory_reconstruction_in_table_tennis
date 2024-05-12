function [vertices] = detectTableFeatures(lines,I,PAR)
% This function takes in input the lines founded using the Hough Algorithm
% [lines] and returns the 4 lines that better approximates the sides of a
% table-tennis table [tableSides]. 
% The sides are sorted by their orientation.
% It makes no diffenece if the table is green or blue.
% The input [I] is the original image. 
% The input PAR contains the parameters for setting the detection alghoritm:
% PAR.nearTh      = [pix] Threshold for near points
% PAR.farTh       = [pix] Threshold for far points
% 
% PAR.HRange      = [0-1] H range for the same color
% PAR.S4Color     = [0-1] Min Saturation to have a color
% PAR.V4White     = [0-1] Min Brightness for White 
% PAR.V4Color     = [0-1] Min Brightness for Colors 
% PAR.pickingMode = 1 for detecting colors by averaging the neighbours of the keypoint
%                   0 fot detecting colors by picking the color of the nearest pixel to the keypoint
%
% PAR.thetaTh     = [Deg] Range of the line direction for grouping same oriented lines
% PAR.yTh         = [pix] Start of ROI along Y axis
%
% PAR.showSteps   = 1 for showing only figures... 
%                   2 for showing figures and text (debugging mode)...
%                   0 for showing nothing
%  



%% Lines Selection

Ihsv = rgb2hsv(I);
if(PAR.showSteps); figure; imshow(Ihsv); title('Table Detection - Selected lines'); hold on; end

% NEIGHBORHOOD's COLOR-BASED SELECTION ALGORITHM with tunable ROI

i=0;
for l = 1:length(lines)
   chosen = 0;
   originalNearTh = PAR.nearTh;
   
   %Extract the line data
   if(PAR.showSteps==2); fprintf('\n\nEvaluating Line #%3.0f',l); end 
   x = [lines(l).point1; lines(l).point2];     %line endpoints
   theta = lines(l).theta*pi/180;              %line direction [rad]
   if(PAR.showSteps==2); plot(x(:,1),x(:,2),'LineWidth',2,'Color','k'); end
   if(PAR.showSteps==2); fprintf(', theta =  %2.4f',theta); end 
   
   %Evaluate the line position wrt the ROI 
   if x(1,2)<PAR.yTh || x(2,2)<PAR.yTh
       if(PAR.showSteps==2); fprintf('\n   The line exceed the table ROI'); end
   else
       %Color evaluation   
       while PAR.nearTh && not(chosen)
          if(PAR.showSteps==2); fprintf('\n   nearTh = %1.0f',PAR.nearTh); end 

          %ONE POINT neighborhood's color evaluation
          if(PAR.showSteps==2); fprintf('\n   Try with one middle point'); end 

          [keyPnt,m] = computeKeyPnt(x,theta,PAR);
          chosen = areGoodIntKeyPnt(keyPnt,Ihsv,PAR);

          if chosen
             %If selected, Plot its keyPoints 
             if(PAR.showSteps) 
                plot(x(:,1),x(:,2),'LineWidth',2,'Color','w')
                plot(m(1),m(2),'x','LineWidth',2,'Color','b')
                plot(keyPnt(:,1),keyPnt(:,2),'o','LineWidth',2,'Color','r')
             end    
             
          else
              
             %TWO POINTS neighborhood's color evaluation
             if(PAR.showSteps==2); fprintf('\n   Try with two middle points'); end

             [keyPnt1,m1] = computeKeyPnt([x(1,:);m],theta,PAR);
             if areGoodIntKeyPnt(keyPnt1,Ihsv,PAR)            
                [keyPnt2,m2] = computeKeyPnt([m;x(2,:)],theta,PAR);
                chosen = areGoodIntKeyPnt(keyPnt2,Ihsv,PAR);            
             end
             
             %If selected, Plot its keyPoints 
             if(PAR.showSteps) && chosen % 
                plot(x(:,1),x(:,2),'LineWidth',2,'Color','w')
                plot(m1(1),m1(2),'x','LineWidth',2,'Color','b')
                plot(m2(1),m2(2),'x','LineWidth',2,'Color','b')
                plot(keyPnt1(:,1),keyPnt1(:,2),'o','LineWidth',2,'Color','y')
                plot(keyPnt2(:,1),keyPnt2(:,2),'o','LineWidth',2,'Color','y')
             end  
             
          end      
              
       %Save the line if chosen, otherwise reduce the neighborhood and
       %repeat the evaluation
       if chosen 
          i=i+1;
          wellColoredLines(i)=lines(l);
       else
          PAR.nearTh = PAR.nearTh-1;
       end
     end
   end 
   %Reset the original neighborhood size and go ahead with next line
   PAR.nearTh = originalNearTh; 
end 

if(PAR.showSteps==2); fprintf('\n\n\nSELECTION DONE\n\n '); end



%% Sides Recogniction
% CLUSTERING ALGORITHM : it search the lines having similar direction and
% store their endpoints in an item of the struct "sidesToFit". Each item of
% the struct represent a side

if(PAR.showSteps==2); fprintf('\nSide recogniction.\n'); end
if(PAR.showSteps); figure, imshow(I), title('Table Detection - Sides Keypoints'), hold on; end
colors = 'rgbcmywkrgbcmywk';

% Lines Clustering

s=0;
for k=1:length(wellColoredLines)
   if wellColoredLines(k).rho  %valid line
      s=s+1; %new side creation  
      pnt=0;
      
      % store the direction of the line as an approximated direction for the side
      sidesToFit(s).thetaRef = wellColoredLines(k).theta;
      if(PAR.showSteps==2); fprintf('\n   Side #%2.0f || theta = %4.1f || has ',s,sidesToFit(s).thetaRef); end
      
      % search lines with similar direction of the k-line (+- THDEG) 
      for i=1:length(wellColoredLines(1,:))  
         if wellColoredLines(i).theta>=wellColoredLines(k).theta-PAR.thetaTh...
                 && wellColoredLines(i).theta<=wellColoredLines(k).theta+PAR.thetaTh ...
                 && wellColoredLines(i).rho
             % store all endpoints in a struct grouped by sides
             pnt=pnt+1; sidesToFit(s).point(pnt,:) = wellColoredLines(i).point1; 
             pnt=pnt+1; sidesToFit(s).point(pnt,:) = wellColoredLines(i).point2;
             % line invalidation (this is to consider the line just once) 
             wellColoredLines(i).rho = 0; 
             if(PAR.showSteps==2); fprintf(' Line #%2.0f,',i); end
         end
      end
      if(PAR.showSteps); plot(sidesToFit(s).point(:,1), sidesToFit(s).point(:,2),'*','LineWidth',2,'Color',colors(s)); end
   end
end


if(PAR.showSteps==2); fprintf('\n\n'); end


%% Sides Purging and Sorting
% It computes an approximated middle point for each side by averaging the
% coordinates of the belonging points, then, knowing the table geometry,
% piks just the extreme sides from all detected sides (some times the detected sides 
% can be more then 4 due to color noises).
% The result is a struct conteining points belonging to just 4 sides,
% ordered by parallelism.
% Cluster Centers computation (approximated mid-point of each side)
figure; imshow(I); hold on;
for s=1:length(sidesToFit)
    sidesToFit(s).mid(1) = mean(sidesToFit(s).point(:,1));
    sidesToFit(s).mid(2) = mean(sidesToFit(s).point(:,2));
    plot(sidesToFit(s).mid(1),sidesToFit(s).mid(2),'*','LineWidth',4,'Color','r')
end

 
% Cluster Sorting based on thetaRef 
[~,s] = sort([sidesToFit.thetaRef]','ascend');
for i=1:length(sidesToFit)
    min(i) = sidesToFit(s(i));
end

% Cluster Purging (max 4 Sides)
phi=45; % [Deg] Min Direction difference for Orthogonal Lines in the image.

% 2 Sides along X axis
for s=3:length(sidesToFit)
    if min(s).thetaRef < min(2).thetaRef + phi
        %Too many sides along this direction
        if min(s).thetaRef > min(2).thetaRef 
            min(2).thetaRef = min(s).thetaRef;
        end 
    % 2 Sides along Y axis
    elseif min(s).thetaRef < min(3).thetaRef
        min(3) = min(s).thetaRef;
    elseif min(s).thetaRef > min(4).thetaRef
        min(4) = min(s).thetaRef;    
    end      
end

% Store results
sidesToFit = min;



%% Sides Fitting

tableSides = zeros(4,3);
for k=1:length(sidesToFit)
   poly = polyfit(sidesToFit(k).point(:,1),sidesToFit(k).point(:,2),1); %fitting all points of each side
   
   %the result of poly of order 1 is the vector of parameters [A C] of the explicit line eqn. y = Ax + C                                                       
   tableSides(k,:)= [poly(1) -1 poly(2)]; %here the line is stored in the implicit form [a b c]
end

if not(PAR.camera)
    vertices = [cross(tableSides(2,:),tableSides(4,:));
                cross(tableSides(4,:),tableSides(1,:));
                cross(tableSides(1,:),tableSides(3,:));
                cross(tableSides(3,:),tableSides(2,:))];
else
    vertices = [cross(tableSides(3,:),tableSides(2,:))
                cross(tableSides(2,:),tableSides(4,:));
                cross(tableSides(4,:),tableSides(1,:));
                cross(tableSides(1,:),tableSides(3,:));];
end
vertices = [vertices(1,:)./vertices(1,3);
            vertices(2,:)./vertices(2,3);
            vertices(3,:)./vertices(3,3);
            vertices(4,:)./vertices(4,3)];
vertices = [vertices(1,1) vertices(1,2);
            vertices(2,1) vertices(2,2);
            vertices(3,1) vertices(3,2);
            vertices(4,1) vertices(4,2)];

if(PAR.showSteps)
    figure, imshow(I); title('Table Detection - Sides'); hold on;
    plotLinesOnImage(tableSides, 2, I)
    plot(vertices(:,1),vertices(:,2),'*','LineWidth',2,'Color','y')
    text(vertices(1,1) -10, vertices(1,2) -30,'a','FontSize',20,'Color','y')
    text(vertices(2,1) -10, vertices(2,2) -30,'b','FontSize',20,'Color','y')
    text(vertices(3,1) -10, vertices(3,2) -30,'c','FontSize',20,'Color','y')
    text(vertices(4,1) -10, vertices(4,2) -30,'d','FontSize',20,'Color','y')
    legend('line 1','line 2','line 3','line 4', 'vertices');
end

end
