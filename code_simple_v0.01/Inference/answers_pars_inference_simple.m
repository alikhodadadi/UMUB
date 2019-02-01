function [ answers_pars ] = answers_pars_inference_simple( data, pars, g)
%This function Infers question parameters using data
%   INPUT:
%   OUTPUT:

events = data.events;
T = max(events.quests.times(end), events.answrs.times(end));
num_users = data.num_users;
num_tags = data.num_tags;
num_answrs = length(data.events.answrs.times);
prev_qs_to_consider = 50;
%% ================= Inference of Time parameters ====================%%
% Initialization //TODO: I should test differnt initializations
rng(0,'twister')
a_mus = rand(data.num_users, 1);
a_b_ims = rand(data.num_users, 1);
user_expertises = (1/num_tags)*ones(num_users, num_tags);

a_badgeWeights = ones(data.num_a_badges, 1);% we leave it here
a_badgeThreshs = data.a_badgeThreshs;

% we only consider the 20 latest questions for detecting the source of
% event
%%++++++++++++++++++++++++ EM +++++++++++++++++++++++++++++++++++++++++++++%%
converged = false;
g_t = @(x) g(x);
iter = 0;
log_comp_lklhd = [];

h = animatedline;
axis([1,pars.em_iter_thresh, -2,-0.2])
while (~converged)
    iter = iter +1;
    %disp(['(iterations so far:', num2str(iter), ')']);
    prev_a_mus = a_mus;
    prev_a_badgeWeights = a_badgeWeights;
    prev_a_b_ims = a_b_ims;
    prev_expertises = user_expertises;
    
    %%++++++++++++++++ E-Step +++++++++++++++++++++++++++++++++++++++++++%%
    a_count = zeros(data.num_users, 1);
    a_source_probs = zeros(num_answrs, prev_qs_to_consider+2); 
    a_var_weights = zeros(num_answrs, 1);
    
    for i = 1:length(events.answrs.times)
        u = events.answrs.users(i);
        t = events.answrs.times(i);
        a_count(u) = a_count(u) + 1;
        res = 0;
        for b=1:data.num_a_badges
            b_imp = a_badgeWeights(b)*g(a_count(u)- a_badgeThreshs(b));
            res = res + a_b_ims(u)*b_imp;
        end
        % impact of badges
        a_source_probs(i,   end) = res;
        % exogeneous impact
        a_source_probs(i, end-1) = a_mus(u);
        %impact of previous questions
        inds = find(events.quests.times < t, prev_qs_to_consider, 'last');
        for l =1 : length(inds)
            idx = inds(l);
            qtime = events.quests.times(idx);
            qtag  = events.quests.tags(idx);
%             disp('--------------')
%             user_expertises(u,qtag)
%             f(t-qtime)
            a_source_probs(i, l) = user_expertises(u,qtag)*f(t-qtime);
        end
        %%%%%%%%%%%%% new k function %%%%%%%%%%%
        q_idxs = find(events.quests.times < t);
        qtimes = events.quests.times(q_idxs);
        qtags = events.quests.tags(q_idxs);
        a_var_weights(i) = 1/(user_expertises(u,qtags)*k(t-qtimes));
        
       
        %a_var_weights(i) = 1/sum(a_source_probs(i,1:end-2));
        
        a_source_probs(i,:) = a_source_probs(i,:)/sum(a_source_probs(i,:));
        if(length(find(isnan(a_source_probs(i,:))))>0)
            disp('----------------source NAN ----------------------------')
            a_mus(u)
           % user_expertises(u,qtags)
           % k(t-qtimes)
        end
        if(isnan(a_var_weights(i)))
            disp('------------ var_Weight -------------')
           % (user_expertises(u,qtags)*k(t-qtimes))
        end
    end
    
%     %+++++++++Plot log likelihood
    model = struct;
    t_model = struct;
    t_model.num_users = num_users;
    t_model.num_aBadges = data.num_a_badges;
    t_model.a_badgeThreshs = data.a_badgeThreshs;
    
    t_model.a_badgeWeights = a_badgeWeights;
    t_model.a_mus = a_mus;
    t_model.a_b_ims = a_b_ims;
    
    model.var_pars.a_epsilons = a_var_weights;
    model.tag_pars.eta = user_expertises;
    model.time_pars = t_model;
    model.num_users = num_users;
    
    n_e = length(data.events.answrs.users);
    [ log_like ] = ...
        answers_pseudo_log_like(data,model);
    log_comp_lklhd(iter) = log_like/n_e;
    disp(log_like/n_e)
    addpoints(h, iter, log_like/n_e);
    drawnow
    %%+++++++++++++++ M-Step ++++++++++++++++++++++++++++++++++++++++++++%%
    % ---------- Update a_mus ------------------%
    for u = 1: data.num_users
        inds = events.answrs.users == u;
        a_mus(u) =  sum(a_source_probs(inds, end-1))/T;
    end
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
    % ---------- Updatee badge impacts ---------------%
    for u = 1 : data.num_users
        inds = events.answrs.users == u;
        res = sum(a_source_probs(inds, end));
        s = 0;
        for b = 1:data.num_a_badges
            b_thr = a_badgeThreshs(b);
            s = s + a_badgeWeights(b)*g_int(events, u, 2, b_thr, g_t); 
        end
        if( s~= 0 )
            a_b_ims(u) = res/s;
        else
            a_b_ims(u) = 0;
        end
    end
    
    % ---------- Updatee user expertises ---------------%
    user_expertises = find_opt_expertises ...
        (data, a_var_weights,a_source_probs, prev_qs_to_consider, num_tags);
    %%+++++++++ Check the convergence +++++++++++++++++++++
    c1 = max(abs(a_mus - prev_a_mus));
    c2 = max(abs(a_badgeWeights - prev_a_badgeWeights));
    c3 = max(abs(a_b_ims - prev_a_b_ims));
    c4 = max(abs(user_expertises - prev_expertises));
    if(max([c1,c2,c3,c4])< pars.em_diff_thresh || iter > pars.em_iter_thresh)
%        iter
        converged = true;
    end
end
file = fullfile(pwd, 'Results', 'learned_pars','log_like_per_iteration'); 
log_comp_lklhd
dlmwrite(file, log_comp_lklhd, '-append','delimiter','\t')



%% ============ Constructing outputs ==========================%%
answers_pars                = struct;
answers_pars.a_mus          = a_mus;
answers_pars.a_badgeWeights = a_badgeWeights;
answers_pars.a_b_ims        = a_b_ims;
answers_pars.user_expertises = user_expertises;
answers_pars.a_source_probs = a_source_probs;
end