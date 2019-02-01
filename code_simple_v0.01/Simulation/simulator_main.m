%% Initialization
n_u       = 10;
n_qb      = 10;
n_ab      = 5;
max_a_w   = 5;
max_q_w   = 5;
max_a_thr = 2000;
max_q_thr = 2000;
max_a_mu  = 0.06;
max_q_mu  = 0.03;
max_a_ims = 5;
max_q_ims = 5;
%
num_events = 20000;
%% Genrate Badge Model
disp('% +++++++ Generating Model +++++++++%');
[ time_badge_model ] = badge_model_generator( n_u, n_ab, n_qb, ... 
    max_a_w, max_q_w, max_a_thr, max_q_thr, max_a_mu, max_q_mu, max_a_ims, max_q_ims);
%% Generate Topoic Model
topic_pars = struct;
n_t = 3;
n_w = 10;
topic_pars.num_topics = n_t;
topic_pars.a = .1 * ones(1,n_t);
word_pars = struct;
word_pars.num_words = n_w;
word_pars.a = .1 * ones(n_w, 1);
[ topic_model ] = topic_model_generator( n_u, topic_pars, word_pars);

%% Simulate time and Topic of events
disp( '% +++++++ Generating Events +++++++++%' );
g_t = @(x)g(x);
[ events ] = event_generator( time_badge_model, num_events, g_t);
disp( '% +++++++ Events Generated ++++++++++%' );
disp( '% +++++++ Generating Topics +++++++++%' );
[ events ] = topic_generator( topic_model, events );
disp( '% +++++++ Topics Generated ++++++++++%' );
%% Save the results
data                = struct;
data.events         = events;
data.num_users      = n_u   ;
data.num_words      = n_w;
data.num_q_badges   = n_qb;
data.num_a_badges   = n_ab;
data.a_badgeThreshs = time_badge_model.a_badgeThreshs; 
data.q_badgeThreshs = time_badge_model.q_badgeThreshs; 

file_name = 'synt_data.mat';
file_path = fullfile(pwd, 'Data', 'synt', file_name);
save(file_path, 'data', 'topic_model', 'time_badge_model');