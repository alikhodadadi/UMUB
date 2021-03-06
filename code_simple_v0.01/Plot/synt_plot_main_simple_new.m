%%%%%%%%%%%%%
% dataset = 'simple_model_synt_data';
dataset = 'simple_model_synt10000_data';
n_intervals = 10;
X = zeros(1, n_intervals);

n_samples = 10

mu_mses = zeros(n_samples, n_intervals);
mu_ranks = zeros(n_samples, n_intervals);
badge_impacts_mses = zeros(n_samples, n_intervals);
badge_impacts_ranks = zeros(n_samples, n_intervals);
user_interests_mses = zeros(n_samples, n_intervals);
user_interests_ranks = zeros(n_samples, n_intervals);
user_expertise_mses = zeros(n_samples, n_intervals);
user_expertise_ranks = zeros(n_samples, n_intervals);

answer_likelihoods = zeros(n_samples, n_intervals);
question_likelihoods = zeros(n_samples, n_intervals); 
overal_likelihoods = zeros(n_samples, n_intervals);
durations = zeros(n_samples, n_intervals);
for sample=1:n_samples
    % load events
    sample_name = [dataset num2str(sample)];
    load( fullfile(pwd, 'Data', 'synt',[sample_name '.mat']) );
    n_events = length(data.events.quests.times) + length(data.events.answrs.times);
    n_test = length(test_data.events.quests.times)+ length(test_data.events.answrs.times);
    n_a_test = length(test_data.events.answrs.times);
    n_q_test = length(test_data.events.quests.times);
    
    for i = 1 : n_intervals
        % load metrics
        file_name = [sample_name '_evals_part' num2str(i) '.mat'];
        file_path = fullfile(pwd, 'Results_new', 'evaluation_res','synt', file_name);
        load( file_path );
        
        % store metrics
        mu_mses(sample, i) = time_mses(1);
        mu_ranks(sample, i) = time_rank_corrs(1);
        badge_impacts_mses(sample, i) = time_mses(3);
        badge_impacts_ranks(sample, i) = time_rank_corrs(3);
        user_interests_mses(sample, i) = topic_mses(1);
        user_interests_ranks(sample, i) = topic_rank_corrs(1);
        user_expertise_mses(sample, i) = topic_mses(2);
        user_expertise_ranks(sample, i) = topic_rank_corrs(2);
        
        answer_likelihoods(sample, i) = mean(a_log_like)/n_a_test;
        question_likelihoods(sample, i) = q_log_like/n_q_test;
        overal_likelihoods(sample, i) = (q_log_like+ mean(a_log_like))/n_test;
        
        % calc duaration
        file_name = [sample_name '_pars_part' num2str(i) '.mat'];
        file_path = fullfile(pwd, 'Results', 'learned_pars','synt', file_name);
        load( file_path );
        durations(sample, i)= duration;
    end
end
durations
for i = 1 : n_intervals
    X(i) = (i*5000/n_intervals)/data.num_users;
end

% plotting the metrics
i=1
figDir = '/home/ali/Dropbox/projects/user-modeling-using-badges/user-modeling-using-badges/code/BPP_code_simple_v0.01/Results/Figs';
xlabel = 'Events per user';
% overal test log-likelihood
ylabel = 'Test Log-likelihood per event';
title = 'Overal Log-likelihood';
figName = 'Overal_likelihood_synt';
markers = {'s', 'o', 'd', '*'};
sum_lglk = mean(overal_likelihoods,1)
std_lglk = std(overal_likelihoods,1)
% fig=figure;
% hold on
% errorbar(X, sum_lglk, std_lglk)
% hold off
% box on
plot_diags(X(i:end),sum_lglk(i:end)',[],xlabel,ylabel,title,figDir,figName,markers )

% Answer test loglikelihood
ylabel = 'Test Log-likelihood per answer';
title = 'Answer Log-likelihood';
figName = 'Answer_likelihood_synt';
sum_a_lglk = mean(answer_likelihoods,1)
std_a_lglk = std(answer_likelihoods,1)
% fig=figure;
% hold on
% errorbar(X, sum_a_lglk, std_a_lglk)
% hold off
% box on
plot_diags(X(i:end),sum_a_lglk(i:end)',[],xlabel,ylabel,title,figDir,figName,markers )
% Question test loglikelihood
ylabel = 'Test Log-likelihood per question';
title = 'Question Log-likelihood';
figName = 'Quest_likelihood_synt';
sum_q_lglk = mean(question_likelihoods,1)
std_q_lglk = std(question_likelihoods,1)
% fig=figure;
% hold on
% errorbar(X, sum_q_lglk, std_q_lglk)
% hold off
% box on
plot_diags(X(i:end),sum_q_lglk(i:end)',[],xlabel,ylabel,title,figDir,figName,markers )

% Mu MSEs
ylabel = 'MSE';
title = 'MSE of estimating \mu';
figName = 'mu_mse_synt';
sum_mu_mse = mean(mu_mses,1)
std_mu_mse = std(mu_mses,1)
plot_diags(X(i:end),sum_mu_mse(1,i:end)',[],xlabel,ylabel,title,figDir,figName,markers )
% Mu Corr
ylabel = 'rank correlation';
title = 'rank correlation for \mu';
figName = 'mu_rank_synt';
sum_mu_rank = mean(mu_ranks,1)
std_mu_rank = std(mu_ranks,1)
plot_diags(X(i:end),sum_mu_rank(i:end)',[],xlabel,ylabel,title,figDir,figName,markers )
% Rho MSE
ylabel = 'MSE';
title = 'MSE for \rho';
figName = 'rho_mse_synt';
sum_bi_mse = mean(badge_impacts_mses,1)
std_bi_mse = std(badge_impacts_mses,1)
plot_diags(X(i:end),sum_bi_mse(i:end)',[],xlabel,ylabel,title,figDir,figName,markers )
% Rho Corr
ylabel = 'rank correlation';
title = 'rank correlation for \rho';
figName = 'rho_rank_synt';
sum_bi_rank = mean(badge_impacts_ranks,1)
std_bi_rank = std(badge_impacts_ranks,1)
plot_diags(X(i:end),sum_bi_rank(i:end)',[],xlabel,ylabel,title,figDir,figName,markers )

% alpha mse
ylabel = 'MSE for \alpha';
title = 'rank correlation for \rho';
figName = 'rho_rank_synt';
sum_alpha = mean(user_interests_mses,1)
std_alpha = std(user_interests_mses,1)
plot_diags(X(i:end),sum_alpha(i:end)',[],xlabel,ylabel,title,figDir,figName,markers )

% alpha rank
ylabel = 'Rank for \alpha';
title = 'rank correlation for \rho';
figName = 'rho_rank_synt';
sum_alpha = mean(user_interests_ranks,1)
std_alpha = std(user_interests_ranks,1)
plot_diags(X(i:end),sum_alpha(i:end)',[],xlabel,ylabel,title,figDir,figName,markers )

% eta mse
ylabel = 'MSE for \eta';
title = 'rank correlation for \rho';
figName = 'rho_rank_synt';
sum_eta = mean(user_expertise_mses,1)
std_eta = std(user_expertise_mses,1)
plot_diags(X(i:end),sum_eta(i:end)',[],xlabel,ylabel,title,figDir,figName,markers )

% eta rank
ylabel = 'Rank for \eta';
title = 'rank correlation for \rho';
figName = 'rho_rank_synt';
sum_eta = mean(user_expertise_ranks,1)
std_eta = std(user_expertise_ranks,1)
plot_diags(X(i:end),sum_eta(i:end)',[],xlabel,ylabel,title,figDir,figName,markers )



% figure;
% errorbar(X(i:end), likelihood_metrics(i:end), likelihood_stds(i:end));
% title('Overal Test Log-Likelihood');
% figure;
% errorbar(X(i:end), a_likelihood_metrics(i:end), a_likelihood_stds(i:end));
% title('Answer Test Log-Likelihood');
% 
% figure;
% errorbar(X(i:end), q_likelihood_metrics(i:end), q_likelihood_stds(i:end));
% title('Question Test Log-Likelihood');
% figure;
% %subplot(3,1,1);
% plot(X(i:end), time_mu_metrics(1,i:end));
% title('\mu MSEs');
% % subplot(3,1,2);
% % plot(X, time_bw_metrics(1,:));
% % title('badge weight MSEs');
% %subplot(3,1,3);
% figure;
% plot(X(i:end), time_bi_metrics(1,i:end));
% title('badge impacts MSEs');
% %
% figure;
% %subplot(3,1,1);
% plot(X, time_mu_metrics(2,:));
% title('\mu Corrs');
% % subplot(3,1,2);
% % plot(X, time_bw_metrics(2,:));
% % title('badge weight Corrs');
% %subplot(3,1,3);
% figure;
% plot(X, time_bi_metrics(2,:));
% title('badge impacts Corrs');
% %
% figure;
% subplot(2,1,1);
% plot(X, topic_alp_metrics(1,:));
% title('\alpha MSEs');
% subplot(2,1,2);
% plot(X, topic_eta_metrics(1,:));
% title('\eta MSEs');
% % subplot(3,1,3);
% % plot(X, topic_bet_metrics(1,:));
% % title('\beta MSEs');
% %
% figure;
% subplot(2,1,1);
% topic_alp_metrics(2,:)
% plot(X, topic_alp_metrics(2,:));
% title('\alpha Corrs');
% subplot(2,1,2);
% plot(X, topic_eta_metrics(2,:));
% title('\eta Corrs');
% % subplot(3,1,3);
% % plot(X, topic_bet_metrics(2,:));
% % title('\beta Corrs');
% %
% % figure;
% % subplot(2,1,1);
% % plot(X, topic_accs(1,:));
% % title('Accuracy 1');
% % 
% % subplot(2,1,2);
% % plot(X, topic_accs(2,:));
% % title('Accuracy 2');
% %%
% over_time_mse = time_mu_metrics(1,:)+ time_bi_metrics(1,:);
% over_time_mse = over_time_mse/2
% figure;
% plot(X(i:end), over_time_mse(i:end));
% title('over-time-mse');
% %
% over_time_corr = time_mu_metrics(2,:)+ time_bi_metrics(2,:);
% over_time_corr = over_time_corr/2
% figure;
% plot(X(i:end), over_time_corr(i:end));
% title('over-time-corr');
% %
% over_topic_mse = topic_alp_metrics(1,:)+ topic_eta_metrics(1,:);
% over_topic_mse =over_topic_mse/2;
% figure;
% plot(X, over_topic_mse);
% title('over-topic-mse');
% %
% over_topic_corr = topic_alp_metrics(2,:)+ topic_eta_metrics(2,:);
% over_topic_corr =over_topic_corr/2;
% figure;
% plot(X, over_topic_corr);
% title('over-topic-corr');
