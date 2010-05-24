%% Solve a simple quadratic program
%PMTKneedsOptimToolbox quadprog
requireOptimToolbox
H = 2*eye(2);
g = -[3,0.25];
A = [1 1; 1 -1; -1 1; -1 -1];
b = ones(4,1);
soln = quadprog(H, g, A, b)