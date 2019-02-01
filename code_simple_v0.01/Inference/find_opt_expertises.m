function [ eta ] = find_opt_expertises ...
    (data, answrs_var_pars, answrs_source_probs,prev_qs_to_consider, num_tags)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%%
quests = data.events.quests;
answrs = data.events.answrs;

n_t = num_tags;
n_u = data.num_users;
eta = zeros(n_u, n_t);
T = max(data.events.quests.times(end), data.events.answrs.times(end));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f_ints = zeros(1,n_t);
    for r = 1 : length(quests.times)
        tag = quests.tags(r);
        tr = quests.times(r); 
%         f_ints(tag) = f_ints(tag)+(1-f(T-tr)); 
        f_ints(tag) = f_ints(tag)+f_int(0,T-tr); %changed 
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for u = 1:n_u
    %find eta_u
    disp(['user: ',num2str(u)])
    ans_inds = find(answrs.users == u);
    disp(['number of answers:',num2str(length(ans_inds))])
    F_u = zeros(1, n_t);
    H_u = zeros(1, n_t);
    for j = 1 : length(ans_inds)
        tj = answrs.times(ans_inds(j));
        pj = answrs.parents(ans_inds(j));
        F_u(quests.tags(pj)) = F_u(quests.tags(pj)) + 1;
        
%         q_inds = find(quests.times<tj);% May be I only consider the last 20
        q_inds = find(quests.times<tj, prev_qs_to_consider, 'last');
        q_tags = quests.tags(q_inds);
        for q = 1: length(q_inds)
            F_u(q_tags(q)) = F_u(q_tags(q)) +answrs_source_probs(ans_inds(j),q);%check
        end
        
        q_inds = find(quests.times<tj);
        q_tags = quests.tags(q_inds);
        k_delt = k(tj- quests.times(q_inds));
        for q=1:length(q_inds)
            H_u(q_tags(q)) = H_u(q_tags(q)) +...
                answrs_var_pars(ans_inds(j))*k_delt(q);
        end
    end
    H_u = H_u + f_ints;
%     % Do the Optimization
%     n_repeats = 10;
%     eta_u=0;
%     for rep = 1:n_repeats
%         x0 = dirichlet_sample(0.1*ones(n_t,1));
%         myfun = @(x) -G_u*log(x)+F_u*x;
%         constraint = @(x) deal([], ones(1,n_t)*x-1);
%         lb = zeros(n_t,1);
%         ub = ones (n_t,1);
%         [e_u, fval] = fmincon(myfun, x0, [],[],[],[],lb,ub,constraint);
%         fval
%         eta_u = eta_u + e_u;
%     end
%     x = eta_u./n_repeats;
%    n_t
   H_u
   F_u
   x = solve_cvx_problem(F_u, H_u, n_t);
%    cvx_begin sdp
%         variable x(n_t) nonnegative;
%         minimize -F_u*log(x)+ H_u*x + 0.0001* norm(x, 1);
%         subject  to
%             sum(x) == 1;
%    cvx_end
%    
%   if(~isempty(find(isnan(x), 1)))
%       disp('********* dobare *********')
%       cvx_begin 
%            cvx_solver sedumi
%            variable x(n_t) nonnegative;
%            minimize -F_u*log(x)+ H_u*x + 0.0001* norm(x, 1);
%            subject  to
%                sum(x) == 1;
%        cvx_end
%   end
%     % Save the learned params
    x'
     eta(u,:) = x';
end
end

