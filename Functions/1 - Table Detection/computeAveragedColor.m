function color = computeAveragedColor(points,Ihsv,PAR)
%This function takes as input a matrix [points] nx2, where n is the number
%of points having 2 coordinates each.
%For each point that could non correspond to a specific pixel on the input
%image [Ihsv] (becouse it could be not an integer), the function computes
%the coordinates of the 4 neighbours pixels, then it averages its colours.
%
%The function return a matrix [color] nx3 where for each point it gives the
%three components of the averaged color [H S V].

  
   n = length(points(:,1));
   color = zeros(n,3);
   
   for p=1:n
        
       neighbors = [ceil(points(p,1))  ceil(points(p,2));
                    floor(points(p,1)) ceil(points(p,2));
                    ceil(points(p,1))  floor(points(p,2));
                    floor(points(p,1)) floor(points(p,2))];

       for HSVparam=1:3
         val = 0;
         for i=1:4
            val = val + Ihsv(neighbors(i,2),neighbors(i,1),HSVparam);
         end
         
        %color(#point, hsv_color_parameters)
         color(p,HSVparam) = val/4;
       end
       
       
       if(PAR.showSteps==2); plot(neighbors(:,1),neighbors(:,2),'o','LineWidth',2,'Color','k'); end
       
   end
   
end