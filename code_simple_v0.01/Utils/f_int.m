function [ out ] = f_int( a,b, beta )
%The Kernel function of impacts
if nargin < 3
    beta = 10;
end
%% Exp
out = (1/beta)*(f(a,beta)-f(b,beta));
end
