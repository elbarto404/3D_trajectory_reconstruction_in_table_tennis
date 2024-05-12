function [keyPnt,m] = computeKeyPnt(x,theta,PAR)
%This function takes as input the endpoints of a line from a 2x2 matrix 
%[x]=[points,coo] and the orientation in degree of the line
%and gives the coordinates of the 4 key points relying on the specified
%parameters [PAR].
%The key points are returned in the 4x2 matrix [keyPnt] and they are sorted
%in this way:
%
% Far superior  (3)       o    |Distance for far points [PAR.farTh]
%                              |  
% Near superior (1)       o    |   |Distance for near points [PAR.nearTh]   
% Line  ------------------x------------------------
% Near inferior (2)       o     
%                             Points are taken on the orthogonal direction
% Far inferior  (4)       o   starting from the midpoint of the segment.
%
%Note: The coordinates in [keyCoo] are not rounded so they don't
%correspond to a specific pixel on the image yet.


   m = [(x(1,1)+x(2,1))/2, (x(1,2)+x(2,2))/2];         %midpoint 

   if(PAR.showSteps==2)
      fprintf('\n      start[%4.0f %4.0f], end[%4.0f %4.0f], mid[%4.0f %4.0f] :',x(1,1),x(1,2),x(2,1),x(2,2),m(1),m(2)); 
   end 

   keyPnt = [m(1)-PAR.nearTh*cos(theta) m(2)-PAR.nearTh*sin(theta);   
             m(1)+PAR.nearTh*cos(theta) m(2)+PAR.nearTh*sin(theta);   
             m(1)-PAR.farTh*cos(theta)  m(2)-PAR.farTh*sin(theta);     
             m(1)+PAR.farTh*cos(theta)  m(2)+PAR.farTh*sin(theta)];    

   if sin(theta)<0
      swap = keyPnt(2,:);
      keyPnt(2,:) = keyPnt(1,:);
      keyPnt(1,:) = swap;

      swap = keyPnt(4,:);
      keyPnt(4,:) = keyPnt(3,:);
      keyPnt(3,:) = swap;
   end

   if(PAR.showSteps==2) % Standard keypnt color palette
      plot(m(1),m(2),'x','LineWidth',2,'Color','c')
      plot(keyPnt(:,1),keyPnt(:,2),'*','LineWidth',2,'Color','m')
   end

end