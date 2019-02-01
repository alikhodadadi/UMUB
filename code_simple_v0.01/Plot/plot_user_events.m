function plot_user_events( events, u )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
q_idx = events.quests.users == u;
a_idx = events.answrs.users == u;
b_idx = events.badges.users == u;
qtimes = events.quests.times(q_idx);
atimes = events.answrs.times(a_idx);
btimes = events.badges.times(b_idx);

t_beg = 0;
t_end = max(qtimes(end),atimes(end));
bin = 10/2;

num_intvs = floor((ceil((t_end - t_beg)/bin)));
intensities  = zeros(num_intvs,   3);
event_counts = zeros(num_intvs+1, 3);
for i = 1:num_intvs
   % i
    t = t_beg + i * bin;
    q_inds = find(qtimes < t);
    a_inds = find(atimes < t);
    b_inds = find(btimes < t);
    %
    event_counts(i+1,1) = length( q_inds );
    event_counts(i+1,2) = length( a_inds );
    event_counts(i+1,3) = length( b_inds );
    %
    intensities( i, 1) = event_counts( i+1, 1) - event_counts( i, 1);
    intensities( i, 2) = event_counts( i+1, 2) - event_counts( i, 2);
    intensities( i, 3) = 100*(event_counts( i+1, 3) - event_counts( i, 3));
end
%%%%%%%%%%%%%%
figure;
X = (1:num_intvs);
plot(X,intensities);
figure;
plot(0:num_intvs, event_counts);
end

