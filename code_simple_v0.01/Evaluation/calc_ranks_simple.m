function [ time_rank_corrs, topic_rank_corrs ] = calc_ranks_simple ...
    ( question_pars, answer_pars, model )
%%%summary ..................................
%% Define Variables
% first for mus, second for b_weights, third for badge impacts
time_rank_corrs = zeros(3, 1);
%first for alphas, second for etas, third for betas
topic_rank_corrs = zeros(2, 1);
%% Calc rank correlation of time-badge parameters
% mu
q_res = tau_rank(model.time_pars.q_mus, question_pars.q_mus, 1);
a_res = tau_rank(model.time_pars.a_mus, answer_pars.a_mus, 1);
time_rank_corrs(1) = (q_res + a_res)/2;
% badge weights
q_res = tau_rank(model.time_pars.q_badgeWeights, ...
    question_pars.q_badgeWeights, 1);
a_res = tau_rank(model.time_pars.a_badgeWeights, ...
    answer_pars.a_badgeWeights, 1);
time_rank_corrs(2) = (q_res + a_res)/2;
% badge impacts on users
q_res = tau_rank(model.time_pars.q_b_ims, question_pars.q_b_ims, 1);
a_res = tau_rank(model.time_pars.a_b_ims, answer_pars.a_b_ims, 1);
time_rank_corrs(3) = (q_res + a_res)/2;

%% Calc rank correlation of topic parameters
topic_rank_corrs(1) = tau_rank( model.tag_pars.alpha, ...
    question_pars.user_interests, 2);
topic_rank_corrs(2) = tau_rank( model.tag_pars.eta, ...
    answer_pars.user_expertises, 2);
end
