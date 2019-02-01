function [ parent ] = sample_parent( t, u, u_eta, q_times, q_tags )
%This function samples the question that user u will answer at time t
%   Detailed explanation goes here

% Determine the parent
inds = find(q_times < t);
times = q_times(inds);
tags  = q_tags (inds);
beta = 0.01;
delt_ts = t - times; 
% disp('+++++++++++++++')
%%%%%%%%%%%%%%%%%%%%%%%
% new_tar = -beta*delt_ts' + log(u_eta(tags));
% y = max(new_tar);
% log_prob = new_tar - y - log(sum(exp(new_tar - y)));
% parent =  find(mnrnd(1, exp(log_prob)));
% max(exp(log_prob))
res = u_eta(tags)'.*k(delt_ts);
res = res./sum(res);
parent = find(mnrnd(1, res));

%%%%%%%%%%%%%%%%%%%%%%%

% % min(t - times)
% disp('---------------')
% f_t = f(t - times);
% psi = f_t' .* u_eta(tags);
% % prob = exp(psi)./sum(exp(psi));
% prob = psi./sum(psi);
% max(prob)
% % mnrnd(1,prob)
% parent = find(mnrnd(1,prob));
end

