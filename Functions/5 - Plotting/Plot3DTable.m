function Plot3DTable()
% PLOTCUBE - Display a 3D-cube in the current axes
%
%   PLOTCUBE(EDGES,ORIGIN,ALPHA,COLOR) displays a 3D-cube in the current axes
%   with the following properties:
%   * EDGES : 3-elements vector that defines the length of cube edges
%   * ORIGIN: 3-elements vector that defines the start point of the cube
%   * ALPHA : scalar that defines the transparency of the cube faces (from 0
%             to 1)
%   * COLOR : 3-elements vector that defines the faces color of the cube

%table
% EXTERNAL WHITE OF THE TABLE
plotcube([274.0 152.5 4.9],[0  0  -4.95],.9,[1 1 1]);
% GREEN PROPER TABLE
plotcube([270.0 148.5 5],[ 2  2  -5],.9,[0.274 0.329 0.29]);
% NET 
plotcube([1 183 15.25], [136.5 -15.25 0], .8, [1 1 1]);
%GAMBE
plotcube([15 15 71],[20  20  -76],.8,[0 0 0]);
plotcube([15 15 71],[20  117.5  -76],.8,[0 0 0]);
plotcube([15 15 71],[239  117.5  -76],.8,[0 0 0]);
plotcube([15 15 71],[239  20  -76],.8,[0 0 0]);
