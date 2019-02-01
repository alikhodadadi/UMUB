%% Initialization
n_u       = 2;
n_qb      = 50;
n_ab      = 50;
max_a_w   = 5;
max_q_w   = 5;
max_a_thr = 1000;
max_q_thr = 1000;
max_a_mu  = 0.01;
max_q_mu  = 0.01;
max_a_ims = 3;
max_q_ims = 3;
%
num_events = 1000;
test_events = 1000;
%% Genrate Badge Model
disp('% +++++++ Generating Model +++++++++%');
[ time_badge_model ] = badge_model_generator( n_u, n_ab, n_qb, ... 
    max_a_w, max_q_w, max_a_thr, max_q_thr, max_a_mu, max_q_mu, max_a_ims, max_q_ims);
%% Generate Tag Model
tag_pars = struct;
n_t = 10;

tag_pars.num_tags = n_t;
tag_pars.a = .1 * ones(1,n_t);
[ tag_model ] = tag_model_generator( n_u, tag_pars);

%% Simulate time and Topic of events
disp( '% +++++++ Generating Events +++++++++%' );
g_t = @(x)g(x);
model = struct;
model.time_pars = time_badge_model;
model.tag_pars = tag_model;
model.num_users = n_u;
[ events     ] = event_generator( model, num_events,  g_t );
[ test_events] = event_generator( model, test_events, g_t );
disp( '% +++++++ Events Generated ++++++++++%' );
%% Save the results
data                = struct;
data.events         = events;
data.num_users      = n_u   ;
data.num_tags       = n_t;
data.num_q_badges   = n_qb;
data.num_a_badges   = n_ab;
data.a_badgeThreshs = time_badge_model.a_badgeThreshs; 
data.q_badgeThreshs = time_badge_model.q_badgeThreshs; 

test_data                = struct;
test_data.events         = test_events;
test_data.num_users      = n_u   ;
test_data.num_tags       = n_t;
test_data.num_q_badges   = n_qb;
test_data.num_a_badges   = n_ab;
test_data.a_badgeThreshs = time_badge_model.a_badgeThreshs; 
test_data.q_badgeThreshs = time_badge_model.q_badgeThreshs; 


% dataset = 'simple_model_synt_data';
file_path = fullfile(pwd, 'Data', 'synt', [dataset '.mat']);
save(file_path, 'data', 'test_data', 'model');
