function [ acc1, acc2 ] = calc_topic_accuracy( q_topics, inferred_phis )
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
[M, I] = max(inferred_phis, [], 2);
acc1 = length(find(q_topics == I))/length(q_topics);
acc2 = sum(M)/length(q_topics);
end

