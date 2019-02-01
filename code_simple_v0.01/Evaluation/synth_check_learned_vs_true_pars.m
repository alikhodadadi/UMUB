% Load Data-set
dataset = ['simple_model_synt50_exp_compare_data1'];
load( fullfile(pwd, 'Data', 'synt',[dataset '.mat']) );
true_model = model;
i=10;
n_u = true_model.num_users;
%
mu_qs = zeros(n_u,2);
mu_as = zeros(n_u,2);
rho_qs = zeros(n_u,2);
rho_as = zeros(n_u,2);
r_interests = zeros(n_u,10);
l_interests = zeros(n_u,10);
r_expertises = zeros(n_u, 10);
l_expertises = zeros(n_u,10);
for i =1:n_u
    mu_qs(i,1) = model.time_pars.q_mus(i);
    mu_as(i,1) = model.time_pars.a_mus(i);
    rho_qs(i,1) = model.time_pars.q_b_ims(i);
    rho_as(i,1) = model.time_pars.a_b_ims(i);
    
    r_interests(i,:) = model.tag_pars.alpha(i,:);
    r_expertises(i,:) = model.tag_pars.eta(i,:);
end
% Load Learned Parameters
i=10
file_name = [dataset '_pars_part' num2str(i) '.mat']; 
file_path = fullfile(pwd, 'Results', 'learned_pars','synt', file_name);
load( file_path );
qp = question_pars;
ap = answer_pars;
for i=1:n_u
    mu_qs(i,2) = question_pars.q_mus(i); 
    mu_as(i,2) = answer_pars.a_mus(i);
    rho_qs(i,2) = question_pars.q_b_ims(i);
    rho_as(i,2) = answer_pars.a_b_ims(i);
    
    l_interests(i,:) = question_pars.user_interests(i,:);
    l_expertises(i,:) = answer_pars.user_expertises(i,:);
end
% plots the results
figure;
hold on
scatter(mu_qs(:,1), mu_qs(:,2))
scatter(mu_as(:,1), mu_as(:,2))
scatter(rho_qs(:,1), rho_qs(:,2))
scatter(rho_as(:,1), rho_as(:,2))
scatter(r_interests(:), l_interests(:))
scatter(r_expertises(:), l_expertises(:))