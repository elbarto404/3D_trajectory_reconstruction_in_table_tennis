function hsv=defineBallColour(x,y,frame)

%this function receives as inputs the coordinates of the ball and the
%frame. It returns the HSV value of the colour of the ball.

x=round(x);
y=round(y);


I=rgb2hsv(frame);
hsv(1)=I(y,x,1);
hsv(2)=I(y,x,2);
hsv(3)=I(y,x,3);


end