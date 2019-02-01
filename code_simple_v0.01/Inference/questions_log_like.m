function [ log_like ] = questions_log_like( data, model )
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

user_interests = model.tag_pars.alpha;
events = data.events;
T = max(events.quests.times(end), events.answrs.times(end));
event_counts = zeros(model.num_users,2);
% log likelihood of time of questions
q_lgs = 0;
for i = 1 :  length(events.quests)
    ui = events.quests.users(i);
    ti = events.quests.times(i);
    zi = events.quests.tags(i);
    event_counts(ui, 1) = event_counts(ui, 1) + 1;
    [ I ] = intensity ...
        ( model, event_counts, ti,events.quests.times, events.quests.tags,@g);
    q_lgs = q_lgs + log(I(ui, 1)) + log(user_interests(ui,zi));
end
lambdas_int = 0;
for u = 1 : tmodel.users
    lambdas_int = lambdas_int + tmodel.q_mus(u)*T;
    res = 0;
    for b = 1 : tmodel.qBadges
        b_thr = tmodel.q_badgeThreshs(b);
        res = res + g_int(events, u, 1, b_thr, @g);
    end
    lambdas_int = lambdas_int + tmodel.q_b_ims(u)*res;
end
log_like = q_lgs - lambdas_int;
end