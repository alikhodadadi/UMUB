function [ res ] = MSE( x, y )
%This function calculates the Mean Squared Error between x and y
res = mean(mean((x-y).^2));
end

