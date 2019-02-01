%%%%%%%%%%%%%
% dataset = 'simple_model_synt_data';
dataset = 'simple_model_synt10000_data1';
% load events
load( fullfile(pwd, 'Data', 'synt',[dataset '.mat']) );
n_events = length(data.events.quests.times) + length(data.events.answrs.times); 
n_intervals = 10;
X = zeros(1, n_intervals);
% for each paramter we consider a 2* n_intervals matrix, the first row for
% mses and the second for rank correlations
time_mu_metrics = zeros(2, n_intervals);
time_mu_stds    = zeros(2, n_intervals);
time_bw_metrics = zeros(2, n_intervals);
time_bw_stds = zeros(2, n_intervals);
time_bi_metrics = zeros(2, n_intervals);
time_bi_stds = zeros(2, n_intervals);

a_likelihood_metrics = zeros(1, n_intervals);
a_likelihood_stds = zeros(1, n_intervals);
q_likelihood_metrics = zeros(1, n_intervals);
q_likelihood_stds = zeros(1, n_intervals);
likelihood_metrics = zeros(1, n_intervals);
likelihood_stds = zeros(1, n_intervals);
%
topic_alp_metrics = zeros(2, n_intervals);
topic_alp_stds = zeros(2, n_intervals);
topic_eta_metrics = zeros(2, n_intervals);
topic_eta_stds = zeros(2, n_intervals);

n_test = length(test_data.events.quests.times)+ length(test_data.events.answrs.times)
n_a_test = length(test_data.events.answrs.times);
n_q_test = length(test_data.events.quests.times);

for i = 1 : n_intervals
    X(i) = (i*n_events/n_intervals)/data.num_users;
    % load metrics
    file_name = [dataset '_evals_part' num2str(i) '.mat'];
    file_path = fullfile(pwd, 'Results', 'evaluation_res','synt', file_name);
    load( file_path );
    % store metrics
    time_mu_metrics( 1, i) = time_mses    (1);
    time_mu_stds   ( 1, i) = time_mses_std(1);

    time_mu_metrics( 2, i) = time_rank_corrs    (1);
    time_mu_stds   ( 2, i) = time_rank_corrs_std(1);
    time_bw_metrics( 1, i) = time_mses    (2);
    time_bw_stds   ( 1, i) = time_mses_std(2);
    time_bw_metrics( 2, i) = time_rank_corrs    (2);
    time_bw_stds   ( 2, i) = time_rank_corrs_std(2);
    time_bi_metrics( 1, i) = time_mses    (3);
    time_bi_stds   ( 1, i) = time_mses_std(3);
    time_bi_metrics( 2, i) = time_rank_corrs    (3);
    time_bi_stds   ( 2, i) = time_rank_corrs_std(3);
    %
    topic_alp_metrics( 1, i) = topic_mses    (1);
    topic_alp_stds   ( 1, i) = topic_mses_std(1);
    topic_alp_metrics( 2, i) = topic_rank_corrs    (1);
    topic_alp_stds   ( 2, i) = topic_rank_corrs_std(1);
    topic_eta_metrics( 1, i) = topic_mses    (2);
    topic_eta_stds   ( 1, i) = topic_mses_std(2);
    topic_eta_metrics( 2, i) = topic_rank_corrs    (2);
    topic_eta_stds   ( 2, i) = topic_rank_corrs_std(2);
    %
    a_likelihood_metrics(i) = a_log_like/n_a_test;
    a_likelihood_stds   (i) = a_log_like_std;
    q_likelihood_metrics(i) = q_log_like/n_q_test;
    q_likelihood_stds   (i) = q_log_like_std;
    likelihood_metrics(i) = (q_log_like+a_log_like)/n_test;
    likelihood_stds(i) = (q_log_like_std+a_log_like_std)/n_test;
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
plot_diags(X(i:end),likelihood_metrics(i:end)',[],xlabel,ylabel,title,figDir,figName,markers )
% Answer test loglikelihood
ylabel = 'Test Log-likelihood per answer';
title = 'Answer Log-likelihood';
figName = 'Answer_likelihood_synt';
plot_diags(X(i:end),a_likelihood_metrics(i:end)',[],xlabel,ylabel,title,figDir,figName,markers )
% Question test loglikelihood
ylabel = 'Test Log-likelihood per question';
title = 'Question Log-likelihood';
figName = 'Quest_likelihood_synt';
plot_diags(X(i:end),q_likelihood_metrics(i:end)',[],xlabel,ylabel,title,figDir,figName,markers )

% Mu MSEs
ylabel = 'MSE';
title = 'MSE of estimating \mu';
figName = 'mu_mse_synt';
plot_diags(X(i:end),time_mu_metrics(1,i:end)',[],xlabel,ylabel,title,figDir,figName,markers )
% Mu Corr
ylabel = 'rank correlation';
title = 'rank correlation for \mu';
figName = 'mu_rank_synt';
plot_diags(X(i:end),time_mu_metrics(2,i:end)',[],xlabel,ylabel,title,figDir,figName,markers )
% Rho MSE
ylabel = 'MSE';
title = 'MSE for \rho';
figName = 'rho_mse_synt';
plot_diags(X(i:end),time_bi_metrics(1,i:end)',[],xlabel,ylabel,title,figDir,figName,markers )
% Rho Corr
ylabel = 'rank correlation';
title = 'rank correlation for \rho';
figName = 'rho_rank_synt';
plot_diags(X(i:end),time_bi_metrics(2,i:end)',[],xlabel,ylabel,title,figDir,figName,markers )

% Rho Corr
ylabel = 'rank correlation';
title = 'rank correlation for \rho';
figName = 'rho_rank_synt';
plot_diags(X(i:end),time_bi_metrics(2,i:end)',[],xlabel,ylabel,title,figDir,figName,markers )

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