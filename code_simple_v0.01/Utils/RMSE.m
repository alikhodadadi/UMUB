function [ res ] = RMSE( x, y )
%This function calculates the Root Mean Squared Error between x and y
res = sqrt(mean(mean((x-y).^2)));
end

