function [ b_thrs ] = find_badge_threshs( events, action)
%This function finds the threshold of a given badge for a given action
%   
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%%
% Finds the badge among awarded badges
inds = events.badges.types == action;
idx = find(events.badges.indxs == b_idx & events.badges.types == action);
% find the user who won the badge
u = events.badges.users(idx);
% find the time the badge is awarded
t = events.badges.times(idx);
% count the number of events till the badge
if(action == 1)
    inds = events.quests.times <= t;
    b_thr = length(find(events.quests.users(inds)== u));
elseif (action == 2)
    inds = events.answrs.times <= t;
    b_thr = length(find(events.answrs.users(inds)== u));
end
end

