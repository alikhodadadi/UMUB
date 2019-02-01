function [ a_I ] = answer_intensity( model, events_count, t, q_times, q_tags, g)
%UNTITLED3 Summary of this function goes here
%   I: a one column vector. The first column specify the intensity of
%   answering

if nargin <5
    disp('Please specify the kernel function!!');
end
%
num_users = model.num_users;
num_aBadges = model.time_pars.num_aBadges;
a_weights = model.time_pars.a_badgeWeights;
a_b_threshs = model.time_pars.a_badgeThreshs;
a_b_imps = model.time_pars.a_b_ims;
a_mus = model.time_pars.a_mus;
u_expertises = model.tag_pars.eta;
a_I = a_mus + a_b_imps.*sum(g(repmat(events_count(:,2),[1, num_aBadges]) - ...
    repmat(a_b_threshs,[1, num_users])'), 2);

if(~isempty(q_times))
    inds = find(q_times <= t);
    times = q_times(inds);
    tags  = q_tags (inds);
    f_t = f(t-times);
    exps = u_expertises(:,tags);
    % Considering the impact of previous questions in each tag
    a_I = a_I + exps*f_t;
end
end
