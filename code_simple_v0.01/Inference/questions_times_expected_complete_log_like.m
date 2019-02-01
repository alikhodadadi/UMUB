function [ log_like ] = questions_times_expected_complete_log_like( data, model, q_source_probs)
%This function calculates the expected complete loglikelihood of questions
%in the EM like manner to find the time parameters
%   the events means the questions and answers

tmodel = struct;
tmodel.users          = data.num_users;
tmodel.qBadges        = data.num_q_badges;
tmodel.q_badgeThreshs = data.q_badgeThreshs;
tmodel.q_badgeWeights = model.time_pars.q_badgeWeights;
tmodel.q_b_ims        = model.time_pars.q_b_ims;
tmodel.q_mus          = model.time_pars.q_mus;

events = data.events;
T = max(events.quests.times(end), events.answrs.times(end));
q_counts = zeros(model.num_users,1);
% log likelihood of time of questions
q_clglks = 0;
for i = 1 :  length(events.quests)
    ui = events.quests.users(i);
    si_probs = q_source_probs(i,:);
    
    q_clglks = q_clglks + si_probs(end)* log(tmodel.q_mus(ui));
    q_counts(ui) = q_counts(ui) + 1;
    for b = 1: tmodel.qBadges
       q_clglks = q_clglks + si_probs(b)* ...
           (log(tmodel.q_b_ims(ui))+ g_log(tmodel.q_badgeThreshs(b)-q_counts(ui))); 
    end
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
log_like = q_clglks - lambdas_int;
end