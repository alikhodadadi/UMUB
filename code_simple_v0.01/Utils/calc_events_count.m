function [ event_counts, question_tag_counts, answer_tag_counts ] = ...
    calc_events_count( events, num_users, num_tags )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
event_counts = zeros(num_users,2);
question_tag_counts = zeros(num_users, num_tags);
answer_tag_counts = zeros(num_users, num_tags);
for i = 1 : length(events.quests.users)
    usr = events.quests.users(i);
    tag = events.quests.tags(i);
    event_counts(usr,1)=event_counts(usr,1)+1;
    question_tag_counts(usr,tag) = question_tag_counts(usr,tag)+1; 
end
for i = 1 : length(events.answrs.users)
    usr = events.answrs.users(i);
    par = events.answrs.parents(i);
    tag = events.quests.tags(par);
    event_counts(usr,2)=event_counts(usr,2)+1;
    answer_tag_counts(usr,tag) = answer_tag_counts(usr,tag)+1;
end
end

