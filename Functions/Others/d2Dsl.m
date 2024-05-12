function [d]=d2Dsl(p,a)

% function [d]=d2Dsl(p,a)
% this function calculates the distance of a set of n points from a 2D
% straight line
% input: p, n x 2 matrix, each row containing the [x y] coordinates of a
%        point
%        a, vector [a b c] defining the plane parameters
% output; d, n x 1 vector of the distances

% standardize the a vector

a=a(:)';
a=a/norm(a(1:2));

% calculate distances

d=abs(p*a(1:2)'+a(3));