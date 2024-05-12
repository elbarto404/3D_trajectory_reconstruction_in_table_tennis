function Hr = tableRectification(v,w,I,PAR)
% Table rectification

%The table rectitification is computed using the DLT algorithm and the
%knowledge of the legth of the sides of the table 

X = [v(1,:),v(2,:),v(3,:),v(4,:)];
XP = [w(1,:),w(2,:),w(3,:),w(4,:)];


% apply preconditioning to ease DLT algorithm
% Tp and TP are similarity trasformations
[pCond, Tp] = precond(X);
[PCond, TP] = precond(Xp);

% estimate the homography among transformed points
Hc = homographyEstimation(pCond, PCond);

% adjust the homography taking into account the similarities
Hr = inv(TP) * Hc * Tp; 


if(PAR.showSteps)
    % Apply the trasformation to the image
    tform = projective2d(Hr');
    J = imwarp(I,tform);
    
    figure(11), imshow(J), title('Table Rectification'), hold on;
    saveas(figure(11),'Media/ProjectFigures/11_tableRectification.jpg'); 
end

end