function [ log_like ] = answers_log_like( data, model )
%This function calculates the log-likelihood of time of events
%   the events means the questions and answers

tmodel = struct;
tmodel.users          = data.num_users;
tmodel.aBadges        = data.num_a_badges;
tmodel.a_badgeThreshs = data.a_badgeThreshs;
tmodel.a_badgeWeights = model.time_pars.a_badgeWeights;
tmodel.a_b_ims        = model.time_pars.a_b_ims;
tmodel.a_mus          = model.time_pars.a_mus;
tmodel.qBadges        = data.num_q_badges;
tmodel.q_badgeThreshs = data.q_badgeThreshs;
tmodel.q_badgeWeights = model.time_pars.q_badgeWeights;
tmodel.q_b_ims        = model.time_pars.q_b_ims;
tmodel.q_mus          = model.time_pars.q_mus;

user_expertises = model.tag_pars.eta;

events = data.events;
T = max(events.quests.times(end), events.answrs.times(end));

event_counts = zeros(model.num_users,2);
% log likelihood of time of questions
q_lgs = 0;
for i = 1 :  length(events.answrs)
    ui = events.answrs.users(i);
    ti = events.answrs.times(i);
    pi = events.answrs.parents(i);
    event_counts(ui, 2) = event_counts(ui, 2) + 1;
    [ I ] = intensity ...
        ( model, event_counts, ti,events.quests.times, events.quests.tags,@g);
    q_lgs = q_lgs + log(I(ui, 2)) + ...
        calc_parent_log_prob(ti, ui, pi, user_expertises(ui,:), events);
end



lambdas_int = 0;
times = events.quests.times;
tags = events.quests.tags;
for u = 1 : tmodel.users
    lambdas_int = lambdas_int + tmodel.a_mus(u)*T;
    res = 0;
    for b = 1 : tmodel.aBadges
        b_thr = tmodel.a_badgeThreshs(b);
        res = res + g_int(events, u, 2, b_thr, @g);
    end
%     lambdas_int = lambdas_int + tmodel.a_b_ims(u)*res ...
%         + user_expertises(u,tags)*(1-f(T-times));
lambdas_int = lambdas_int + tmodel.a_b_ims(u)*res ...
        + user_expertises(u,tags)*(f_int(0,T-times));
end

log_like = q_lgs - lambdas_int;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lprob = calc_parent_log_prob(t, u, i, u_expertise, events)
ti = events.quests.times(i);
zi = events.quests.tags(i);
lprob = log(k(t-ti)* u_expertise(zi));
idxs = events.quests.times<t;
times = events.quests.times(idxs);
tags  = events.quests.tags (idxs);
res = u_expertise(tags)*k(t - times);
lprob = lprob - log(res);
end