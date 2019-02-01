function [ out ] = k( x, beta )
%The Kernel function of impacts
if nargin < 2
    beta = 0.001;
end
%% Exp
out = exp(-beta*x);
end