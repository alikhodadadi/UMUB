function [ t_b_pars ] = time_badge_pars_inference_simple( data, pars, g)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
events = data.events;
T = max(events.quests.times(end), events.answrs.times(end));
%% ================= Inference of question parameters ====================%%
q_mus = rand(data.num_users, 1);
q_badgeWeights = ones(data.num_q_badges, 1);
q_badgeThreshs = data.q_badgeThreshs;
q_b_ims = rand(data.num_users, 1);
%q_mult_pis = zeros(length(events.quests.times), data.num_q_badges+1);
%%++++++++++++++++++++++++ EM +++++++++++++++++++++++++++++++++++++++++++++%%
converged = false;
g_t = @(x) g(x);
iter = 0;
while (~converged)
    iter = iter +1;
    %disp(['(iterations so far:', num2str(iter), ')']);
    prev_q_mus = q_mus;
    prev_q_badgeWeights = q_badgeWeights;
    prev_q_b_ims = q_b_ims;
    %%++++++++++++++++ E-Step +++++++++++++++++++++++++++++++++++++++++++%%
    q_count = zeros(data.num_users, 1);
    q_mult_pis = zeros(length(events.quests.times), data.num_q_badges+1);
    for i = 1:length(events.quests.times)
        u = events.quests.users(i);
        q_count(u) = q_count(u) + 1; 
        for b=1:data.num_q_badges
            b_imp = q_badgeWeights(b)*g(q_count(u)- q_badgeThreshs(b));
            q_mult_pis(i, b) = q_b_ims(u)*b_imp;
        end
        q_mult_pis(i, end) = q_mus(u);
        %
        q_mult_pis(i,:) = q_mult_pis(i,:)./sum(q_mult_pis(i,:));     
    end
    %size(q_mult_pis)
    %q_mult_pis
    
    %%+++++++++++++++ M-Step ++++++++++++++++++++++++++++++++++++++++++++%%
    % mus
    for u = 1: data.num_users
        inds = events.quests.users == u;
        q_mus(u) =  sum(q_mult_pis(inds,end))/T;
    end
    %q_mus
    
    % badge weights
%     for b = 1 : data.num_q_badges
%         s = 0;
%         b_thr = q_badgeThreshs(b);
%         for u = 1: data.num_users
%             s = s + q_b_ims(u)*g_int(events, u, 1, b_thr, g_t); 
%         end
%         if( s~= 0)
%             q_badgeWeights(b) = sum(q_mult_pis(:,b))/s;
%         else
%             q_badgeWeights(b) = 0;
%         end 
%     end
%     %q_badgeWeights
    % badge impacts
    for u = 1 : data.num_users
        inds = events.quests.users == u;
        d = 1 - q_mult_pis(inds,end);
        s = 0;
        for b = 1:data.num_q_badges
            b_thr = q_badgeThreshs(b);
            s = s + q_badgeWeights(b)*g_int(events, u, 1, b_thr, g_t); 
        end
        if( s~= 0 )
            q_b_ims(u) = sum(d)/s;
        else
            q_b_ims(u) = 0;
        end
    end
    %q_b_ims
    %return;
    %%+++++++++ Check the convergence +++++++++++++++++++++
    c1 = max(abs(q_mus - prev_q_mus));
    c2 = max(abs(q_badgeWeights - prev_q_badgeWeights));
    c3 = max(abs(q_b_ims - prev_q_b_ims));
%     c1
%     c2
%     c3
    if(max([c1,c2,c3])< pars.em_diff_thresh || iter > pars.em_iter_thresh)
        iter
        converged = true;
    end
end
%% =========== Inference of answer parameters ====================%%
a_mus = rand(data.num_users, 1);
a_badgeWeights = ones(data.num_a_badges, 1);
a_badgeThreshs = data.a_badgeThreshs;
a_b_ims = rand(data.num_users, 1);

%%+++++++++++++++++++ EM +++++++++++++++++++++++++++++++++++++++++++++++%%
converged = false;
g_t = @(x) g(x);
iter = 0;
while (~converged)
    iter = iter +1;
    %disp(['(iterations so far:', num2str(iter), ')']);
    prev_a_mus = a_mus;
    prev_a_badgeWeights = a_badgeWeights;
    prev_a_b_ims = a_b_ims;
    %%++++++++++++++++ E-Step +++++++++++++++++++++++++++++++++++++++++++%%
    a_count = zeros(data.num_users, 1);
    a_mult_pis = zeros(length(events.answrs.times), data.num_a_badges+1);
    for i = 1:length(events.answrs.times)
        u = events.answrs.users(i);
        a_count(u) = a_count(u) + 1; 
        for b=1:data.num_a_badges
            b_imp = a_badgeWeights(b)*g(a_count(u)-a_badgeThreshs(b));
            a_mult_pis(i, b) = a_b_ims(u)*b_imp;
        end
        a_mult_pis(i, end) = a_mus(u);
        %
        a_mult_pis(i,:) = a_mult_pis(i,:)./sum(a_mult_pis(i,:));     
    end
    %a_mult_pis
    %%+++++++++++++++ M-Step ++++++++++++++++++++++++++++++++++++++++++++%%
    % mus
    for u = 1: data.num_users
        inds = events.answrs.users == u;
        a_mus(u) =  sum(a_mult_pis(inds,end))/T;
    end
    %a_mus
%     % badge weights
%     for b = 1 : data.num_a_badges
%         s = 0;
%         b_thr = a_badgeThreshs(b);
%         for u = 1: data.num_users
%             s = s + a_b_ims(u)*g_int(events, u, 2, b_thr, g_t); 
%         end
%         if( s~= 0)        
%             a_badgeWeights(b) = sum(a_mult_pis(:,b))/s; 
%         else
%             a_badgeWeights(b) = 0;
%         end
%     end
    %a_badgeWeights
    % badge impacts
    for u = 1 : data.num_users
        inds = events.answrs.users == u;
        d = 1 - a_mult_pis(inds,end);
        s = 0;
        for b = 1:data.num_a_badges
            b_thr = a_badgeThreshs(b);
            s = s + a_badgeWeights(b)*g_int(events, u, 2, b_thr, g_t); 
        end
        if( s~= 0)
            a_b_ims(u) = sum(d)/s;
        else
            a_b_ims(u) = 0;
        end
    end
    %a_b_ims
    
    %%+++++++++ Check the convergence +++++++++++++++++++++
    c1 = max(abs(a_mus - prev_a_mus));
    c2 = max(abs(a_badgeWeights - prev_a_badgeWeights));
    c3 = max(abs(a_b_ims - prev_a_b_ims));
    %c1
    %c2
    %c3
    if(max([c1,c2,c3])< pars.em_diff_thresh || iter > pars.em_iter_thresh)
        converged = true;
    end
end
%%Constructing outputs
t_b_pars                = struct;
t_b_pars.q_mus          = q_mus;
t_b_pars.q_badgeWeights = q_badgeWeights;
t_b_pars.q_b_ims        = q_b_ims;
t_b_pars.a_mus          = a_mus;
t_b_pars.a_badgeWeights = a_badgeWeights;
t_b_pars.a_b_ims        = a_b_ims;
end