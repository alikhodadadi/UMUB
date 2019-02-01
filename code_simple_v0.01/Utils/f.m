function [ out ] = f( x, beta )
%The Kernel function of impacts
if nargin < 2
    beta = 10;
end
%% Exp
out = exp(-beta*x);
end