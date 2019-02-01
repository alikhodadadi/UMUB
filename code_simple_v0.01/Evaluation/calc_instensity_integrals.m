function [ q_intensity_integrals , a_intensity_integrals] = calc_instensity_integrals( data, model)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
n_q = length(data.events.quests.times);
n_a = length(data.events.answrs.times);
event_counts = zeros(model.num_users,2);% counts the number of q&as for each user
q_intensity_integrals = zeros(1,n_q-1);
a_intensity_integrals = zeros(1,n_a-1);
quests = data.events.quests;
answrs = data.events.answrs;
g_t = @(x) g(x);
user_expertises = model.tag_pars.eta;
% size(user_expertises)
for i=2:n_q
    qt = quests.times(i);
    qu = quests.users(i);
    event_counts(qu,1) = event_counts(qu,1) +1; 
    delta_t = quests.times(i)-quests.times(i-1);
    I = intensity(model, event_counts, qt, [], [], g_t);
    sum_I = sum(I,1);
    q_intensity_integrals(i-1) = sum_I(1)*delta_t;
end
for i=2:n_a
    prev_at = answrs.times(i-1);
    at = answrs.times(i);
    au = answrs.users(i);
    event_counts(au,2) = event_counts(au,2) +1; 
    delta_t = answrs.times(i)-answrs.times(i-1);
    I = intensity(model, event_counts, at, [], [], g_t);
    sum_I = sum(I,1);
    
    
    inds = quests.times<at;
    q_times = quests.times(inds);
    q_tags = quests.tags(inds);
%     size(user_expertises(:,q_tags))
%     size(f_int(max(prev_at, q_times)-q_times,at-q_times))
    a_intensity_integrals(i-1) = sum_I(2)*delta_t+ ...
        sum(user_expertises(:,q_tags)*f_int(max(prev_at, q_times)-q_times,at-q_times));
end

end

