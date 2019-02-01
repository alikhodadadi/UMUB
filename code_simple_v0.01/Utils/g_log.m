function [ out ] = g_log( x, sigma )
%The Kernel function of impacts
if nargin < 2
    sigma = 10;
end
%% Gaussian Kernel
% out = -0.5*(x/sigma).^2;
%% Exp Kernel
%out = -sigma*abs(x);
disp('Errrrrrrrrrrrrr')
end

