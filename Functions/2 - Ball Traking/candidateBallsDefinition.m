function candidate_balls=candidateBallsDefinition(centroids,ball_d)

%This function returns an array with the centroids of the candidates balls.
%The input is the struct with the centroids of all the connected components
%of the binary image. 
%The aim of this function is to discard all the objects which have a
%centroid too near with respect to the others (like suppressing the neighborhood)

i=2;
%the first element of the output is the first centroid
candidate_balls(1,:)=centroids(1).Centroid;

if(size(centroids,1)>1)
    
    %analyze all the centroids of the binary image
    for k=2:size(centroids,1)
        
        %the centroid is ok
        centroid_ok=true;
        
        %analyze all the previous selected centroids
        for j=1:size(candidate_balls,1)
            
            %calculate the distance between the j-th centroid of the
            %candidate_balls vector and the k-th centroid of the input
            %centroids
            distance= pdist([centroids(k).Centroid;candidate_balls(j,:)],'euclidean');
            
            %if the distance is too small 
            if (distance<=ball_d)
                centroid_ok=false;
            end
            
        end 
        
        if(centroid_ok)
            candidate_balls(i,:)=centroids(k).Centroid;
            i=i+1;
        end
    end
end


end
