function [ time_mres, topic_mres ] = calc_MREs_simple( question_pars, answer_pars, model )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%% Define Variables
% first for mus, second for b_weights, third for badge impacts
time_mres = zeros(3, 1);
%first for alphas (interests), second for etas (expertises).
topic_mres = zeros(2, 1);
%% Calc MSE of time-badge parameters
% mu
q_res = MRE(model.time_pars.q_mus, question_pars.q_mus);
a_res = MRE(model.time_pars.a_mus, answer_pars.a_mus  );
time_mres(1) = (q_res + a_res)/2;
% badge weights
q_res = MRE(model.time_pars.q_badgeWeights, question_pars.q_badgeWeights);
a_res = MRE(model.time_pars.a_badgeWeights, answer_pars.a_badgeWeights  );
time_mres(2) = (q_res + a_res)/2;
% badge impacts on users
q_res = MRE(model.time_pars.q_b_ims, question_pars.q_b_ims);
a_res = MRE(model.time_pars.a_b_ims, answer_pars.a_b_ims);
time_mres(3) = (q_res + a_res)/2;

%% Calc MSE of topic parameters
topic_mres(1) = MRE( model.tag_pars.alpha, question_pars.user_interests);
inds = model.tag_pars.eta > 0.05;
topic_mres(2) = MRE( model.tag_pars.eta(inds)  , answer_pars.user_expertises(inds) );
end

