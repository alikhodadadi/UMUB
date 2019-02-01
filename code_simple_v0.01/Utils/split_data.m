function [ s_data ] = split_data( data, t )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
q_inds = find(data.events.quests.times < t);
a_inds = find(data.events.answrs.times < t);
b_inds = find(data.events.badges.times < t);
% 
quests = struct;
quests.times = data.events.quests.times( q_inds );
quests.users = data.events.quests.users( q_inds );
quests.tags  = data.events.quests.tags ( q_inds );
if(isfield(data.events.quests, 'topics'))
    quests.topics  = data.events.quests.topics( q_inds );
end
%
answrs = struct;
answrs.times   = data.events.answrs.times  ( a_inds );
answrs.users   = data.events.answrs.users  ( a_inds );
answrs.parents = data.events.answrs.parents( a_inds );
%
badges = struct;
badges.times = data.events.badges.times( b_inds );
badges.users = data.events.badges.users( b_inds );
badges.indxs = data.events.badges.indxs( b_inds );
badges.types = data.events.badges.types( b_inds );
%
events = struct;
events.quests = quests;
events.answrs = answrs;
events.badges = badges;
%
s_data = struct;
s_data.events         = events             ;
s_data.num_users      = data.num_users     ;
s_data.num_tags      = data.num_tags     ;
s_data.num_a_badges   = data.num_a_badges  ;
s_data.num_q_badges   = data.num_q_badges  ;
s_data.a_badgeThreshs = data.a_badgeThreshs;
s_data.q_badgeThreshs = data.q_badgeThreshs;
end

