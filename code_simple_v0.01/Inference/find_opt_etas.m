function [ eta ] = find_opt_etas(data, pars, phi, psi)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%%
quests = data.events.quests;
answrs = data.events.answrs;

n_t = pars.num_topcs;
n_u = data.num_users;
eta = zeros(n_u, n_t);
%%
for u = 1:n_u
    %find eta_u
    ans_inds = find(answrs.users == u);
    G_u = sum(phi(answrs.parents(ans_inds), :));
    F_u = zeros(1, n_t);
    for j = 1 : length(ans_inds)
        tj = answrs.times(ans_inds(j));
        q_inds = find(quests.times<tj);% May be I only consider the last 20
        f_delt = exp(-(tj- quests.times(q_inds)));
        F_u = F_u + psi(j)*f_delt'*phi(q_inds,:);
    end
    % Do the Optimization
    cvx_begin
        variable eta_u(n_t)
        minimize(- G_u*log(eta_u)+ F_u * eta_u)
        subject  to
            sum(eta_u) == 1
    cvx_end
    % Save the learned params
     eta(u,:) = eta_u';
end

