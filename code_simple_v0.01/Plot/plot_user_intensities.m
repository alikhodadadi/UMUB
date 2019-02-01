function  plot_user_intensities( model, events, u )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
q_idx = events.quests.users == u;
a_idx = events.answrs.users == u;
b_idx = events.badges.users == u;
qtimes = events.quests.times(q_idx);
qtags  = events.quests.tags(q_idx);
atimes = events.answrs.times(a_idx);
btimes = events.badges.times(b_idx);

t_beg = 0;
t_end = floor(max(qtimes(end),atimes(end)));
event_counts = zeros(model.num_users,2);
intensities = zeros(t_end, 2);
g_t = @(x)g(x);
for t = 1:1:t_end
    if(mod(t,1001)==0)
        disp(t);
    end
    q_inds = find( qtimes < t );
    a_inds = find( atimes < t );
    b_inds = find( btimes < t );
    event_counts(u,1) = length( q_inds );
    event_counts(u,2) = length( a_inds );
    % Calc Intensity at t
    [ I ] = intensity( model, event_counts, t, ...
        qtimes(1:length( q_inds )),qtags(1:length( q_inds )), g_t);
    intensities(t,:) = I(u,:);
end
figure;
plot(intensities);
legend('Q', 'A');
end