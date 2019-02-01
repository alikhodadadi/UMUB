function [ question_pars ] = question_pars_inference_simple( data, pars, g)
%This function Infers question parameters using data
%   INPUT:
%   OUTPUT:

events = data.events;
T = max(events.quests.times(end), events.answrs.times(end));
num_users = data.num_users;
num_tags = data.num_tags;

%% ================ Inference of topic parameters ====================%%
user_interests = zeros(num_users, num_tags);
for i = 1:length(events.quests.times)
    u = events.quests.users(i);
    p = events.quests.tags(i);
    user_interests(u,p) = user_interests(u,p) +1;
end
for u = 1:num_users
    user_interests(u,:) = user_interests(u,:)/sum(user_interests(u,:));
end
user_interests(isnan(user_interests)) = 1/num_tags;
%% ================= Inference of Time parameters ====================%%
% Initialization //TODO: I should test differnt initializations
rng(0,'twister')
q_mus = rand(data.num_users, 1);
q_b_ims = rand(data.num_users, 1);

q_badgeWeights = ones(data.num_q_badges, 1);% we leave it here
q_badgeThreshs = data.q_badgeThreshs;
%q_mult_pis = zeros(length(events.quests.times), data.num_q_badges+1);
%%++++++++++++++++++++++++ EM +++++++++++++++++++++++++++++++++++++++++++++%%
converged = false;
g_t = @(x) g(x);
iter = 0;
log_comp_lklhd = [];

% h = animatedline;
% axis([1,pars.em_iter_thresh, -5000,-4000])
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
%     %Plot log likelihood
%     model = struct;
%     t_model = struct;
%     t_model.num_users = num_users;
%     t_model.num_qBadges = data.num_q_badges;
%     t_model.q_badgeThreshs = data.q_badgeThreshs;
%     
%     t_model.q_badgeWeights = q_badgeWeights;
%     t_model.q_mus = q_mus;
%     t_model.q_b_ims = q_b_ims; 
%     model.time_pars = t_model;
%     model.num_users = num_users;
%     [ log_like ] = ...
%         questions_times_expected_complete_log_like( data, model, q_mult_pis);
%     log_comp_lklhd(iter) = log_like;
%     disp(log_like)
%     addpoints(h, iter, log_like);
%     drawnow
    %%+++++++++++++++ M-Step ++++++++++++++++++++++++++++++++++++++++++++%%
    % ---------- Update q_mus ------------------%
    for u = 1: data.num_users
        inds = events.quests.users == u;
        q_mus(u) =  sum(q_mult_pis(inds,end))/T;
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
    %%+++++++++ Check the convergence +++++++++++++++++++++
    c1 = max(abs(q_mus - prev_q_mus));
    c2 = max(abs(q_badgeWeights - prev_q_badgeWeights));
    c3 = max(abs(q_b_ims - prev_q_b_ims));
    if(max([c1,c2,c3])< pars.em_diff_thresh || iter > pars.em_iter_thresh)
%         iter
        converged = true;
    end
end

%% ============ Constructing outputs ==========================%%
question_pars                = struct;
question_pars.q_mus          = q_mus;
question_pars.q_badgeWeights = q_badgeWeights;
question_pars.q_b_ims        = q_b_ims;
question_pars.user_interests = user_interests;
question_pars.q_source_probs = q_mult_pis;
end