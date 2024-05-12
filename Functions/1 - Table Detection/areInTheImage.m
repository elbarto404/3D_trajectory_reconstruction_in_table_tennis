function r = areInTheImage(p,I)
% this function gives 1 if all the point p are contained in the image, 0
% otherwise.
% p=[nx2] vector containing the n points to evaluate
% I = image
    
    n = length(p(:,1));
    imgWidth  = length(I(1,:,1));
    imgHeight = length(I(:,1,1));
    
    r = all(p>zeros(n,2),'all');
    for i=1:n
        r = r && p(i,1)<imgWidth && p(i,2)<imgHeight;
    end
    
    
    
end