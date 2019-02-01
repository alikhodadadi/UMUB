function [ res ] = g_int(events, u, action, b_thr, g)
%%
%This function calculates the integral impact of a badge with threshold
%b_thr on the activity of user u
%   
%%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%%
T = max(events.quests.times(end), events.answrs.times(end));
if action == 1 % question
    inds = events.quests.users == u;
    times = events.quests.times(inds);
elseif action ==2 %answer
    inds = events.answrs.users == u;
    times = events.answrs.times(inds);
end
times = [0;times;T];
res = 0;
for i = 2:length(times)
    res = res + (times(i) - times(i-1))*g(i-1-b_thr);
end
end

