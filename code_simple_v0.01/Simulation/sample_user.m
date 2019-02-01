function [ d ] = sample_user( Is )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
u_Is = sum(Is,2);    
u = rand()*sum(u_Is);
sumIs = 0;
for d=1:length(u_Is)
    sumIs = sumIs + u_Is(d);
    if sumIs >= u
        break;
    end
end
end

