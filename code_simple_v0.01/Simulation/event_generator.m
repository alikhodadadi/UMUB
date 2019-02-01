function [ events ] = event_generator( model, num_events, g)
%This function only generates the time of events, not content!
%   
%% Initializations
t0 = 0;
n = 0;%num of generated events
nq = 0;%num of generated questions
na = 0;%num of generated answers
nb = 0;%num of awarded badges
init_size = 10000;
%
qtimes = zeros(init_size, 1);
qusers = zeros(init_size, 1);
qtags =  zeros(init_size, 1);
%
atimes   = zeros(init_size, 1);
ausers   = zeros(init_size, 1);
aparents = zeros(init_size, 1);
%
btimes = zeros(init_size, 1);
busers = zeros(init_size, 1);
btypes = zeros(init_size, 1);% question or answer
bindxs = zeros(init_size, 1);
event_counts = zeros(model.num_users,2);% counts the number of q&as for each user
% 
user_interests  = model.tag_pars.alpha;
user_expertises = model.tag_pars.eta;
t = t0;
iter = 0;

g_t = @(x) g(x);
%% ===================== Generating Events ==============================%%
while n < num_events
    
    I = intensity( model, event_counts, t, qtimes(1:nq), qtags(1:nq), g_t);
    % sample the time of next event
    t = sample_time( t, I);
    
    iter = iter + 1;
    if( mod(iter,100) == 0 ) 
        disp(['(events so far:', num2str(n),', time so far:', num2str(t), ')']);
    end
    
    I_new = intensity( model, event_counts, t, qtimes(1:nq), qtags(1:nq), g_t);
    
    frac = sum(sum(I_new))/sum(sum(I));
    prob = rand();
    if(prob> frac)% If rejection
        continue;
    end
    
    % sample the user of event
    u = sample_user( I_new );
    
    % sample the type of event
    p = sample_type( I_new(u,:) );
    %???????????????
    if( n == 0)% The first action should be asking question
        p = 1;
    end
    n = n + 1;
    event_counts(u,p) = event_counts(u,p) + 1;
    if p == 1 %question 
        if( nq == length(qtimes) )
            tmp    = qtimes;
            qtimes = zeros(2*nq, 1);
            qtimes(1:nq) = tmp;
            %
            tmp    = qusers;
            qusers = zeros(2*nq, 1);
            qusers(1:nq) = tmp;
            %
            tmp    = qtags;
            qtags = zeros(2*nq, 1);
            qtags(1:nq) = tmp;
        end
        nq = nq + 1;
        % sample tag of question
        tag_idx = mnrnd(1,user_interests(u,:));
        q_tag = find(tag_idx);
        qtimes(nq) = t;
        qusers(nq) = u;
        qtags (nq) = q_tag; 
        % check for winning a new badge by the user
        idx = find( model.time_pars.q_badgeThreshs == event_counts(u,p), 1 );
        if(~isempty(idx))
            if nb == length(btimes)
                tmp    = btimes;
                btimes = zeros(2*nb, 1);
                btimes(1:nb) = tmp;
                %
                tmp    = busers;
                busers = zeros(2*nb, 1);
                busers(1:nb) = tmp;
                %
                tmp    = btypes;
                btypes = zeros(2*nb, 1);
                btypes(1:nb) = tmp;
                %
                tmp    = bindxs;
                bindxs = zeros(2*nb, 1);
                bindxs(1:nb) = tmp;
            end
            nb = nb + 1;
            btimes(nb) = t;
            busers(nb) = u;
            btypes(nb) = p;
            bindxs(nb) = idx;
        end
    else %answer
        if( na == length(atimes) )
            tmp    = atimes;
            atimes = zeros(2*na, 1);
            atimes(1:na) = tmp;
            %
            tmp    = ausers;
            ausers = zeros(2*na, 1);
            ausers(1:na) = tmp;
            %
            tmp    = aparents;
            aparents = zeros(2*na, 1);
            aparents(1:na) = tmp;
        end
        na = na + 1;
        % determine what question he will answered
%         disp(['last q time:' num2str(qtimes(nq))])
%         disp(['current time:' num2str(t)])
        parent = sample_parent( t, u, user_expertises(u,:), qtimes(1:nq), qtags(1:nq) );
        atimes  (na) = t;
        ausers  (na) = u;
        aparents(na) = parent;
        % check for winning a new badge by the user
        idx = find( model.time_pars.a_badgeThreshs == event_counts(u,p), 1 );
        if(~isempty(idx))
            if nb == length(btimes)
                tmp    = btimes;
                btimes = zeros(2*nb, 1);
                btimes(1:nb) = tmp;
                %
                tmp    = busers;
                busers = zeros(2*nb, 1);
                busers(1:nb) = tmp;
                %
                tmp    = btypes;
                btypes = zeros(2*nb, 1);
                btypes(1:nb) = tmp;
                %
                tmp    = bindxs;
                bindxs = zeros(2*nb, 1);
                bindxs(1:nb) = tmp;
            end
            nb = nb + 1;
            btimes(nb) = t;
            busers(nb) = u;
            btypes(nb) = p;
            bindxs(nb) = idx;
        end
    end
end
% resizing arrays
qtimes = qtimes(1:nq);
qusers = qusers(1:nq);
qtags  = qtags (1:nq);
%
atimes   = atimes(  1:na);
ausers   = ausers  (1:na);
aparents = aparents(1:na);
%
btimes = btimes(1:nb);
busers = busers(1:nb);
btypes = btypes(1:nb);
bindxs = bindxs(1:nb);
% Preparing the output
quests       = struct;
quests.times = qtimes;
quests.users = qusers;
quests.tags  = qtags ;
%
answrs         = struct  ;
answrs.times   = atimes  ;
answrs.users   = ausers  ;
answrs.parents = aparents;
%
badges       = struct;
badges.times = btimes;
badges.users = busers;
badges.types = btypes;
badges.indxs = bindxs;
% 
events        = struct;
events.quests = quests;
events.answrs = answrs;
events.badges = badges;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ time ] = sample_time( t, intensities)
%calculate the overal intensity of each node
    u_Is = sum(intensities,2);
    sumI = sum(u_Is);
    time = t + exprnd(1./sumI);
end