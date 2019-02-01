function [ time_mses, topic_mses ] = calc_MSEs_simple( question_pars, answer_pars, model )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%% Define Variables
% first for mus, second for b_weights, third for badge impacts
time_mses = zeros(3, 1);
%first for alphas (interests), second for etas (expertises).
topic_mses = zeros(2, 1);
%% Calc MSE of time-badge parameters
% mu
q_res = MSE(model.time_pars.q_mus, question_pars.q_mus);
a_res = MSE(model.time_pars.a_mus, answer_pars.a_mus  );
time_mses(1) = (q_res + a_res)/2;
% badge weights
q_res = MSE(model.time_pars.q_badgeWeights, question_pars.q_badgeWeights);
a_res = MSE(model.time_pars.a_badgeWeights, answer_pars.a_badgeWeights  );
time_mses(2) = (q_res + a_res)/2;
% badge impacts on users
q_res = MSE(model.time_pars.q_b_ims, question_pars.q_b_ims);
a_res = MSE(model.time_pars.a_b_ims, answer_pars.a_b_ims);
time_mses(3) = (q_res + a_res)/2;

%% Calc MSE of topic parameters
topic_mses(1) = MSE( model.tag_pars.alpha, question_pars.user_interests);
topic_mses(2) = MSE( model.tag_pars.eta  , answer_pars.user_expertises );
end

