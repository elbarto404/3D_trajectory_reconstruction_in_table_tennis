function [P,K]=calibration6Pnt(u,X)

% This funcion return the Projection matrix [P] and the Calibration matrix
% [K] given the projective coordinates of six points in the image plane [u]
% and their relatives projective coordinates in the world reference [X]
%
% [u] is a 3x6 matrix containing the coordinates of the six points in the
% image plane. 
% [X] is a 4x6 matrix containing the coordinates of the six points in the
% world reference.

% Since each point in [u] is like: |ax| and each point in [X] is like: |X|
%                                  |ay|                                |Y|
%                                  |a |                                |Z|
%                                                                      |1|
% and since |ax|          |X|
%           |ay|  =  P *  |Y|
%           |a |          |Z|
%                         |1|
%
% Substituting the equation of the parameter a in the first two equations,
% Each point gives the following two constrains on the Projection matrix:
%
% XxP31 + YxP32 + ZxP33 + xP34 -XP11 -YP12 -ZP13 -P14 = 0
% XyP31 + YyP32 + ZyP33 + yP34 -XP21 -YP22 -ZP23 -P24 = 0
%
% In order to solve the system with the SDV algorithm the coefficients of
% the all 2x6=12 constrains are collected in the matrix A.

%    p11      p12      p13      p14      p21       p22      p23      p24      p31             p32             p33             p34
A = [-X(1,1), -X(2,1), -X(3,1), -X(4,1), 0,        0,       0,       0,       X(1,1)*u(1,1),  X(2,1)*u(1,1),  X(3,1)*u(1,1),  X(4,1)*u(1,1);
     0,       0,       0,       0,       -X(1,1), -X(2,1), -X(3,1), -X(4,1),  X(1,1)*u(2,1),  X(2,1)*u(2,1),  X(3,1)*u(2,1),  X(4,1)*u(2,1);
     -X(1,2), -X(2,2), -X(3,2), -X(4,2), 0,        0,       0,       0,       X(1,2)*u(1,2),  X(2,2)*u(1,2),  X(3,2)*u(1,2),  X(4,2)*u(1,2);
     0,       0,       0,       0,       -X(1,2), -X(2,2), -X(3,2), -X(4,2),  X(1,2)*u(2,2),  X(2,2)*u(2,2),  X(3,2)*u(2,2),  X(4,2)*u(2,2);
     -X(1,3), -X(2,3), -X(3,3), -X(4,3), 0,        0,       0,       0,       X(1,3)*u(1,3),  X(2,3)*u(1,3),  X(3,3)*u(1,3),  X(4,3)*u(1,3);
     0,       0,       0,       0,       -X(1,3), -X(2,3), -X(3,3), -X(4,3),  X(1,3)*u(2,3),  X(2,3)*u(2,3),  X(3,3)*u(2,3),  X(4,3)*u(2,3);
     -X(1,4), -X(2,4), -X(3,4), -X(4,4), 0,        0,       0,       0,       X(1,4)*u(1,4),  X(2,4)*u(1,4),  X(3,4)*u(1,4),  X(4,4)*u(1,4);
     0,       0,       0,       0,       -X(1,4), -X(2,4), -X(3,4), -X(4,4),  X(1,4)*u(2,4),  X(2,4)*u(2,4),  X(3,4)*u(2,4),  X(4,4)*u(2,4);
     -X(1,5), -X(2,5), -X(3,5), -X(4,5), 0,        0,       0,       0,       X(1,5)*u(1,5),  X(2,5)*u(1,5),  X(3,5)*u(1,5),  X(4,5)*u(1,5);
     0,       0,       0,       0,       -X(1,5), -X(2,5), -X(3,5), -X(4,5),  X(1,5)*u(2,5),  X(2,5)*u(2,5),  X(3,5)*u(2,5),  X(4,5)*u(2,5);
     -X(1,6), -X(2,6), -X(3,6), -X(4,6), 0,        0,       0,       0,       X(1,6)*u(1,6),  X(2,6)*u(1,6),  X(3,6)*u(1,6),  X(4,6)*u(1,6);
     0,       0,       0,       0,       -X(1,6), -X(2,6), -X(3,6), -X(4,6),  X(1,6)*u(2,6),  X(2,6)*u(2,6),  X(3,6)*u(2,6),  X(4,6)*u(2,6)];

[~,~,v] = svd(A); 
sol = v(:,end);   % sol = (p11 p12 p13 p14 p21 p22 p23 p24 p31 p32 p33 p34)  

P = [sol(1),   sol(2),   sol(3),   sol(4);
     sol(5),   sol(6),   sol(7),   sol(8);
     sol(9),   sol(10),  sol(11),  sol(12)];

% P = K [R t]
% First 3 x 3 matrix of P is KR
% “QR” decomposition: decomposes an n x n matrix into the product of a
% rotation matrix and an upper triangular matrix so we need to pass to the
% function the inverse of [KR]

[R,K] = qr(inv(P(:,1:3)));

t = K\P(:,4)

K = K./K(3,3);

% K = [ fx   skew U0
%       0    fy   V0
%       0    0    1  ]

% The matrix K contains 5 intrinsic parameters of the specific camera model. 
% These parameters encompass focal length, image sensor format, and principal point. 
% The parameters fx = f*m_x  and fy = f*m_y represent focal length in terms
% of pixels, where m_x and m_y are the inverses of the width and height of
% a pixel on the projection plane and f is the focal length in terms of distance.
% skew represents the skew coefficient between the x and the y axis, and is often 0.
% U0 and V0 represent the principal point, which would be ideally in the center of the image.

end