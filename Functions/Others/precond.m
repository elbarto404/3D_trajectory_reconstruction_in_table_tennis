function [XCond, T] = precond(X)
% Giacomo Boracchi
% course Computer Vision and Pattern Recognition, USI Spring 2020
%
% February 2020

%compute the mean of the rows
tx = mean(X(1, :));
ty = mean(X(2, :));

%compute the standard deviation of the rows and then the mean of them
s = mean(std(X, [], 2));

%define the matrix with the structure of a similarity
T = [1/s, 0, -tx/s; 0, 1/s, -ty/s; 0, 0, 1];

%apply the transformation x'=Hx
XCond = T*X;


