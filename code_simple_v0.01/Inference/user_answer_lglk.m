function [ lglk ] = user_answer_lglk(u, mu_u, b_im_u, expertise_u, data )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
u_inds = data.events.answrs.users == u;
a_times = data.events.answrs.times(u_inds);
a_pars  = data.events.answrs.parents(u_inds);
a_badgeThreshs = data.a_badgeThreshs;
res = 0;
T = max(data.events.quests.times(end), data.events.answrs.times(end));
for idx =1 : length(a_times)
   t = a_times(idx);
   p = a_pars(idx);
   tmp = mu_u;
   tmp = tmp + b_im_u*sum(g(idx-a_badgeThreshs));
    
   idxs = data.events.quests.times<t;
   q_times = data.events.quests.times(idxs);
   q_tags  = data.events.quests.tags (idxs);
   tmp = tmp + expertise_u(q_tags)*f(t - q_times);
   res = res + log(tmp);
   res = res + calc_parent_log_prob(t, u, p, expertise_u, data.events);
end
lam_int = mu_u * T;
tmp = 0;
for b = 1: data.num_a_badges
    b_thr = data.a_badgeThreshs(b);
    tmp = tmp + g_int(data.events, u, 2, b_thr, @g);
end
lam_int = lam_int + b_im_u*tmp;
times = data.events.quests.times;
tags = data.events.quests.tags;
lam_int = lam_int + expertise_u(tags)*f_int(0,T-times);
res =  res - lam_int;
lglk = res;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lprob = calc_parent_log_prob(t, u, i, u_expertise, events)
ti = events.quests.times(i);
zi = events.quests.tags(i);
lprob = log(f(t-ti)* u_expertise(zi));
idxs = events.quests.times<t;
times = events.quests.times(idxs);
tags  = events.quests.tags (idxs);
res = u_expertise(tags)*f(t - times);
lprob = lprob - log(res);
end

