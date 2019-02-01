function [ res ] = MRE( x, y )
%This function calculates the Mean Relative Error between y for estimating
%x
res = mean(mean(abs((y-x)./x)));
end

