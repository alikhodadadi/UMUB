function [ out ] = g( x, sigma )
%The Kernel function of impacts
if nargin < 2
    sigma = 0.1;
end
%% Gaussian Kernel
% out = exp(-sigma*x.^2);
%% Exp Kernel
% if(x < 0)
%     out = 0;
% else
%     out = exp(-sigma*x); 
%     
%out =
out = exp(-sigma*abs(x));
out(x>0)=0;
end

