function [ events ] = topic_generator( topic_model, events)
%This function only generates the time of events, not content!
%   
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%% Initializations
nq = length(events.quests.times);%num of generated questions
na = length(events.answrs.times);%num of generated answers

%
q_tpcs = zeros(nq, 1);% topic of questions
q_tags = zeros(nq, 1);% tag of questions
%
a_pars = zeros(na, 1);% parent of answers
%
n = 0;
%% ===================== Generating Topics ==============================%%
%%+++++++++++++ Generate topics and tags of questions +++++++++++++++++++%%
while n < nq
    n = n + 1;
    %
    q_u = events.quests.users(n);
    % Determine the topic of question
    tp_idx = mnrnd(1, topic_model.alpha(q_u,:));
    q_tp = find(tp_idx);
    tg_idx = mnrnd(1,tp_idx*topic_model.beta');
    q_tg = find(tg_idx);
    %
    q_tpcs(n) = q_tp;
    q_tags(n) = q_tg;
end
%%++++++++++++++++++ Generate parents of answers ++++++++++++++++++++++++%%
n = 0;
while n < na
    n = n + 1;
    t = events.answrs.times(n);
    u = events.answrs.users(n);
    u_eta = topic_model.eta(u,:);
    % Determine the parent
    inds = find(events.quests.times < t);
    q_times = events.quests.times(inds);
    q_topcs = q_tpcs(inds);
    f_t = exp(-(t - q_times));
    psi = f_t' .* u_eta(q_topcs);
    prob = exp(psi)./sum(exp(psi));
    parent = find(mnrnd(1,prob));
    a_pars(n) = parent;
end
% Preparing the output
events.quests.topics  = q_tpcs;
events.quests.tags    = q_tags;
%
events.answrs.parents = a_pars;
end