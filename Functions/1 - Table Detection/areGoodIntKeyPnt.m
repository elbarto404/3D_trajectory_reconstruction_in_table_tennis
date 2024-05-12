function chosen = areGoodIntKeyPnt(keyPnt,Ihsv,PAR)
   
   chosen=0;
   if areInTheImage(keyPnt,Ihsv)    

       %Color Picker Algorithm
       if(PAR.pickingMode==1); keyColor = computeAveragedColor(keyPnt,Ihsv,PAR); end
       if(PAR.pickingMode==0); keyColor = computeColor(keyPnt,Ihsv,PAR); end


       %Selection Algorithm
       if(PAR.showSteps==2); fprintf('\n         Near Superior [%2.3f %2.3f %2.3f]', keyColor(1,1),keyColor(1,2),keyColor(1,3)); end
       if isWhite(keyColor(1,:),PAR)  
           if(PAR.showSteps==2); fprintf('\n         Near Inferior [%2.3f %2.3f %2.3f]', keyColor(2,1),keyColor(2,2),keyColor(2,3)); end
           if isGreen(keyColor(2,:),PAR) || isBlue(keyColor(2,:),PAR)
               if(PAR.showSteps==2); fprintf('\n         Far Inferior  [%2.3f %2.3f %2.3f]', keyColor(4,1),keyColor(4,2),keyColor(4,3)); end
               if isGreen(keyColor(4,:),PAR) || isBlue(keyColor(4,:),PAR)
                   if(PAR.showSteps==2); fprintf('\n         Far Superior  [%2.3f %2.3f %2.3f]', keyColor(3,1),keyColor(3,2),keyColor(3,3)); end
                   if not(isGreen(keyColor(3,:),PAR) || isBlue(keyColor(3,:),PAR))
                       if(PAR.showSteps==2); fprintf('\n      --> CHOSEN by 1'); end
                       chosen=1;
                   end
               end
           end
       end

       if not(chosen)
       if(PAR.showSteps==2); fprintf('\n         Near Inferior [%2.3f %2.3f %2.3f]', keyColor(2,1),keyColor(2,2),keyColor(2,3)); end
       if isWhite(keyColor(2,:),PAR)
           if(PAR.showSteps==2); fprintf('\n         Near Superior [%2.3f %2.3f %2.3f]', keyColor(1,1),keyColor(1,2),keyColor(1,3)); end
           if isGreen(keyColor(1,:),PAR) || isBlue(keyColor(1,:),PAR)
               if(PAR.showSteps==2); fprintf('\n         Far Superior  [%2.3f %2.3f %2.3f]', keyColor(3,1),keyColor(3,2),keyColor(3,3)); end
               if isGreen(keyColor(3,:),PAR) || isBlue(keyColor(3,:),PAR)
                   if(PAR.showSteps==2); fprintf('\n         Far Inferior  [%2.3f %2.3f %2.3f]', keyColor(4,1),keyColor(4,2),keyColor(4,3)); end
                   if not(isGreen(keyColor(4,:),PAR) || isBlue(keyColor(4,:),PAR))
                       if(PAR.showSteps==2); fprintf('\n      --> CHOSEN by 2'); end
                       chosen=1;
                   end
               end
           end
       end
       end
       
   else
       if(PAR.showSteps==2); fprintf('   The line is too close to the margin. It cannot be chosen. '); end
   end
   
end