function [ p ] = sample_type( user_Is )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
u = rand()*sum(user_Is);
sumIs = 0;
for p = 1:length(user_Is)
    sumIs = sumIs + user_Is(p);
    if sumIs >= u
        break;
    end
end
end