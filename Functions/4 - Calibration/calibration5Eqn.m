function imAC = calibration5Eqn(Hr,tableSides,verticalLines,I)

h1=Hr(:,1);
h2=Hr(:,2);
h3=Hr(:,3);


% Vanishing points of table plane
v1=cross(tableSides(1,:),tableSides(2,:));
v1=v1./v1(3);
v2=cross(tableSides(3,:),tableSides(4,:));
v2=v2./v2(3);

linf=cross(v1,v2);
linf=linf./linf(3);

% figure, imshow(I), title('Vanishing points and line at infinity'), hold on
% plot([v1(1); v2(1)],[v1(2); v2(2)],'LineWidth',2,'Color','green');
% plot(v1(1),v1(2),'.','MarkerSize',20);
% plot(v2(1),v2(2),'.','MarkerSize',20);

% % Vanishing point of vertical direction
% n=0;
% for i=1:length(verticalLines(:,1))
%     for k=1:length(verticalLines(:,1))
%         if i~=k
%             n=n+1;
%             vvs(n,:)=cross(verticalLines(i,:),verticalLines(k,:));
%             vvs(n,:)=vvs(n,:)./vvs(n,3);
%         end
%     end
% end
% 
% vh = [mean(vvs(:,1)), mean(vvs(:,2)), 1];
% 
% figure, imshow(I), title('Vanishing points for vertical direction'), hold on
% plot(vvs(:,1), vvs(:,2),'*','LineWidth',2,'Color','r');
% plot(vh(1), vh(2),'*','LineWidth',2,'Color','g');

figure, imshow(I), title('Vanishing points for vertical direction'), hold on
colors = 'rgbcmywkrgbcmywkrgbcmywkrgbcmywkrgbcmywkrgbcmywkrgbcmywkrgbcmywk';
i=0;
imAC=zeros(3,3);
while(not(all(eig(imAC)>0)) && i<length(verticalLines(:,1))-1)
    i=i+1
    j=i;
    while(not(all(eig(imAC)>0)) && j<length(verticalLines(:,1))-1)
        j=j+1
    vv1 = verticalLines(i,:);
    vv2 = verticalLines(j,:);
    vv = cross(vv1,vv2);
    vv = vv./vv(3);
    
    
    %   Constrains
    
    %   v1'*omega*v2=0
    %   v1'*omega*vh=0
    %   v2'*omega*vh=0
    %   h2'*omega*h1=0
    %   h1'*omega*h1-h2'*omega*h2=0
    
    

    B=zeros(5,6);
    B(1,:)= [v1(1)*v2(1),
            (v1(2)*v2(1)+v1(1)*v2(2)),
            (v1(3)*v2(1)+v1(1)*v2(3)),
             v1(2)*v2(2),
            (v1(3)*v2(2)+v1(2)*v2(3)),
             v1(3)*v2(3)];
    B(2,:)= [v1(1)*vv(1),
            (v1(2)*vv(1)+v1(1)*vv(2)),
            (v1(3)*vv(1)+v1(1)*vv(3)),
             v1(2)*vv(2),
            (v1(3)*vv(2)+v1(2)*vv(3)),
             v1(3)*vv(3)];
    B(3,:)= [v2(1)*vv(1),
            (v2(2)*vv(1)+v2(1)*vv(2)),
            (v2(3)*vv(1)+v2(1)*vv(3)),
             v2(2)*vv(2),
            (v2(3)*vv(2)+v2(2)*vv(3)),
             v2(3)*vv(3)];
    B(4,:)= [h2(1)*h1(1),
            (h2(2)*h1(1)+h2(1)*h1(2)),
            (h2(3)*h1(1)+h2(1)*h1(3)),
             h2(2)*h1(2),
            (h2(3)*h1(2)+h2(2)*h1(3)),
             h2(3)*h1(3)];
    B(5,:)= [h1(1)*h1(1)-h2(1)*h2(1),
            (h1(2)*h1(1)+h1(1)*h1(2))-(h2(2)*h2(1)+h2(1)*h2(2)),
            (h1(3)*h1(1)+h1(3)*h1(1))-(h2(3)*h2(1)+h2(3)*h2(1)),
             h1(2)*h1(2)-h2(2)*h2(2),
            (h1(3)*h1(2)+h1(2)*h1(3))-(h2(3)*h2(2)+h2(2)*h2(3)),
             h1(3)*h1(3)-h2(3)*h2(3)];

    [~,~,v] = svd(B); 
    sol = v(:,end); %sol = (ome11,ome21,ome31,ome22,ome32,ome33)  

    %           IMAGE OF THE ABSOLUTE CONIC
    %           omega= [ome11       ome21         ome31
    %                   ome21       ome22         ome32
    %                   ome31       ome32         ome33]

    imAC = [sol(1),      sol(2),        sol(3);
            sol(2),      sol(4),        sol(5);
            sol(3),      sol(5),        sol(6)]
        
    not(all(eig(imAC)>0))
    i<length(verticalLines(:,1))-2

    plot(vv(1), vv(2),'*','LineWidth',2,'Color',colors(i));
    
    end
end

if(i<length(verticalLines(:,1))-1 && j<length(verticalLines(:,1))-1)
    %the Cholesky factorization function returns a matrix R which satisfies imAC=R'*R
    R=chol(imAC);
    %since imAC=K^(-T)*K^(-1), it follows that K=R^(-1)
    K=inv(R);
    %normalization
    K=K./K(3,3);
else
    error('imAC is not positive definite');
end

end