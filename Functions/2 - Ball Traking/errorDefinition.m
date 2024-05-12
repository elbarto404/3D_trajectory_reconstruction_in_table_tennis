function E=errorDefinition(binROI2,Eruc,ball_d,nc)

%this function defines the error for a candidate ball.
%the inputs are the binary cleaned image, the error defined in the Rounded
%Upper Contour function, the diameter of the ball and the number of
%conditions that the ball satisfied in the first stage evaluation.

%weights
wa=0.2;
ww=0.2;
wh=0.2;
wp=0.2;
wr=0.2;
np=5;

candidate=regionprops(binROI2,'Area','BoundingBox','Perimeter');

%Area
Ab=pi*(ball_d/2)^2;
Ac=candidate.Area;
Area=abs(Ac-Ab)/Ab;

%Maximum width
Wb=ball_d;
Wc=candidate.BoundingBox(3);
Width=abs(Wc-Wb)/Wb;

%Maximum height
Hb=ball_d;
Hc=candidate.BoundingBox(4);
Height=abs(Hc-Hb)/Hb;

%Perimeter
Pb=2*pi*ball_d/2;
Pc=candidate.Perimeter;
Perimeter=abs(Pc-Pb)/Pb;

%Roundness
Rb=(4*pi*Ab)/Pb^2;
Rc=(4*pi*Ac)/Pc^2;
Roundness=abs(Rc-Rb)/Rb;

E=(Eruc+wa*Area+ww*Width+wh*Height+wp*Perimeter+wr*Roundness)/(np+1)*nc;

end