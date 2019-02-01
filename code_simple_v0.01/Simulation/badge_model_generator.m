function [ model ] = badge_model_generator( num_users, num_abadges, num_qbadges, ...
    max_a_w, max_q_w, max_a_thresh, max_q_thresh, max_a_mu, max_q_mu, max_a_ims, max_q_ims)
%The function which generates a badge model for simulations
%   This function accepts as the input some parameters and generates a
%   badge model which contains the parameters which is needed for
%   simulating the time of events

model = struct;
model.num_users = num_users;
%% Generate badge based parameters (Thresholds and wieghts)
model.num_qBadges = num_qbadges;
model.num_aBadges = num_abadges;
model.a_badgeWeights = ones(num_abadges, 1);%max_a_w * rand(num_abadges, 1);%a vector of answers badge wieghts in [0,1]
model.q_badgeWeights = ones(num_qbadges, 1);%max_q_w * rand(num_qbadges, 1);%a vector of questions badge wieghts in [0,1]
model.a_badgeThreshs = sort(randi(max_a_thresh,[num_abadges 1]));
model.q_badgeThreshs = sort(randi(max_q_thresh,[num_qbadges 1]));
%% Generate exogeneous intensities for each user
model.a_mus = max_a_mu * rand(num_users, 1);
model.q_mus = max_q_mu * rand(num_users, 1);
%% Generate badge impacts for each user
model.a_b_ims = max_a_ims * rand(num_users, 1);
model.q_b_ims = max_q_ims * rand(num_users, 1);
end

