function color = computeColor(points,Ihsv,PAR)
%This function takes as input a matrix [points] nx2, where n is the number
%of points having 2 coordinates each.
%The function rounds the coordinates of each point to find the pixel on 
%the [Ihsv] image that better approximate that point
%
%The function return a matrix [color] nx3 where for each point it gives the
%three components of the color [H S V] of its associated pixel.


   n = length(points(:,1));
   color = zeros(n,3);
   
   for p=1:n
        
       neighbor = round([points(p,1) points(p,2)]);
       
       for HSVparam=1:3
        %color(#point, hsv_color_parameters)
         color(p,HSVparam) = Ihsv(neighbor(2),neighbor(1),HSVparam);
       end

       if(PAR.showSteps==2); plot(neighbor(1),neighbor(2),'o','LineWidth',2,'Color','k'); end

   end
   
end