function [FinaltrajectoryDX,FinaltrajectorySX]= synchronizationBounceBased(BounceInstantDX,BounceInstantSX,completetrajectoryDX,completetrajectorySX)
% Firstly found the difference 'delta' ( in terms of frames) between the
% first bounce in the DX and in the SX videos
% and Defines the new trajectories Synchronized in the first bounce
% Compute the length of the longest trajectory and Defines:
% FinaltrajectoryDX and FinaltrajectorySX that are the 2 final
% trajectories:
% - Synchronized 
% - starting with the first non null frame in common 
% - ending with the last non null frame in common 

% First Bounce synchronization
% if BounceInstantDX(1)< BounceInstantSX(1)
%     delta = BounceInstantSX(1) - BounceInstantDX(1);
%     completetrajectorySX(:,3) = completetrajectorySX(:,3) - delta;
% else delta = BounceInstantDX(1) - BounceInstantSX(1);
%     completetrajectoryDX(:,3) = completetrajectoryDX(:,3) - delta;
% end

%Last Bounce synchronization
BounceLengthDX=length(BounceInstantDX);
BounceLengthSX=length(BounceInstantSX);
if BounceInstantDX(BounceLengthDX)< BounceInstantSX(BounceLengthSX)
    delta = BounceInstantSX(BounceLengthSX) - BounceInstantDX(BounceLengthDX);
    completetrajectorySX(:,3) = completetrajectorySX(:,3) - delta;
else delta = BounceInstantDX(BounceLengthDX) - BounceInstantSX(BounceLengthSX);
    completetrajectoryDX(:,3) = completetrajectoryDX(:,3) - delta;
end

% Compute the Length of the longest trajectory
% and the first frame in common ( initialframe ) between DX and SX video
% Define the new trajectories ( DeftrajectoryDX and DeftrajectorySX )
% synchronized and Starting with the first frame in common

Length = 0;
initialframe = 0;

if completetrajectoryDX(1,3) > completetrajectorySX(1,3)
    initialframe = completetrajectoryDX(1,3);
    j=1;
while completetrajectorySX(j,3)< initialframe 
    j=j+1;
end
DeftrajectoryDX = completetrajectoryDX(1:end,:);
DeftrajectorySX = completetrajectorySX(j:end,:);

else initialframe = completetrajectorySX(1,3);
    j=1;
while completetrajectoryDX(j,3)< initialframe 
    j=j+1;
end
DeftrajectoryDX = completetrajectoryDX(j:end,:);
DeftrajectorySX = completetrajectorySX(1:end,:);
end

% Compute the length of the longest trajectory and Defines:
% FinaltrajectoryDX and FinaltrajectorySX that are the 2 final
% trajectories:
% - Synchronized 
% - starting with the first non null frame in common 
% - ending with the last non null frame in common 
      
if length(DeftrajectoryDX(:,3)) > length(DeftrajectorySX(:,3))
    Length = length(DeftrajectorySX(:,3));
else Length = length(DeftrajectoryDX(:,3));
end

FinaltrajectoryDX = DeftrajectoryDX(1:Length,:);
FinaltrajectorySX = DeftrajectorySX(1:Length,:);