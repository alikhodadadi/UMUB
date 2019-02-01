function [ I ] = intensity( model, events_count, t, q_times, q_tags, g)
%UNTITLED3 Summary of this function goes here
%   I: a two column vector. The first column specify the intensity of
%   questioning, the second contains the intensity of answering

if nargin <5
    disp('Please specify the kernel function!!');
end
%
num_users = model.num_users;
num_qBadges = model.time_pars.num_qBadges;
num_aBadges = model.time_pars.num_aBadges;

q_weights = model.time_pars.q_badgeWeights;
a_weights = model.time_pars.a_badgeWeights;
q_b_threshs = model.time_pars.q_badgeThreshs;
a_b_threshs = model.time_pars.a_badgeThreshs;
q_b_imps = model.time_pars.q_b_ims;
a_b_imps = model.time_pars.a_b_ims;
q_mus = model.time_pars.q_mus;
a_mus = model.time_pars.a_mus;
u_expertises = model.tag_pars.eta;

q_I = q_mus + q_b_imps.*sum(g(repmat(events_count(:,1),[1, num_qBadges]) - ...
    repmat(q_b_threshs,[1, num_users])'), 2);
% disp('q_ints:')
% q_I
% 
% for i= 1:model.qBadges
%     q_I = q_I + q_b_imps.*(q_weights(i)* g(events_count(:,1) - q_b_threshs(i)));
% end
% for i= 1:model.aBadges
%     a_I = a_I + a_b_imps.*(a_weights(i)* g(events_count(:,2) - a_b_threshs(i)));
% end
a_I = a_mus + a_b_imps.*sum(g(repmat(events_count(:,2),[1, num_aBadges]) - ...
    repmat(a_b_threshs,[1, num_users])'), 2);

if(~isempty(q_times))
    inds = find(q_times <= t);
    times = q_times(inds);
    tags  = q_tags (inds);
    f_t = f(t - times);
    exps = u_expertises(:,tags);
    % Considering the impact of previous questions in each tag
%     disp(['pure:']);
%     a_I
%     disp(['prev:']);
%     exps*f_t
    a_I = a_I + exps*f_t;
end
I = [q_I, a_I];
end
