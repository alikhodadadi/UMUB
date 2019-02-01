% This script integrate the result of different runs  
n_repeats = 10;
n=9
n_intervals = 10;
base_file =  'simple_model_synt10000_data';
for i = 1 : n_intervals
    disp(['interval :' num2str(i)])
    % initialize the variables
    a_loglike_aggr  = NaN(1, n_repeats);
    q_loglike_aggr  = NaN(1, n_repeats);
    time_mses_aggr  = NaN(3,n_repeats);
    time_cors_aggr  = NaN(3,n_repeats);
    topic_mses_aggr = NaN(2,n_repeats);
    topic_cors_aggr = NaN(2,n_repeats);
    for sample = 1:n_repeats
        if(sample~=4)
            result_file = [base_file num2str(sample) '_evals_part' num2str(i) '.mat'];
            file_path = fullfile(pwd, 'Results', 'evaluation_res','synt', result_file); 
            load(file_path)
            % ad the results
            a_loglike_aggr(sample) = a_log_like;
            q_loglike_aggr(sample) = q_log_like;
            
            time_mses_aggr(:,sample) = time_mses;
            time_cors_aggr(:,sample) = time_rank_corrs;

            topic_mses_aggr(:,sample) = topic_mses;
            topic_cors_aggr(:,sample) = topic_rank_corrs;
        end
    end
    
    % reset the variables to be saved
    a_log_like = mean(a_loglike_aggr, 'omitnan');
    a_log_like_std = std(a_loglike_aggr, 'omitnan');
    q_log_like = mean(q_loglike_aggr, 'omitnan');
    q_log_like_std = std(q_loglike_aggr, 'omitnan');
    
    time_mses = mean(time_mses_aggr, 2, 'omitnan');
    time_mses_std = std(time_mses_aggr,0, 2, 'omitnan');
    
    time_rank_corrs = mean(time_cors_aggr, 2, 'omitnan');
    time_rank_corrs_std = std(time_cors_aggr,0, 2, 'omitnan');
    
    topic_mses = mean(topic_mses_aggr,2, 'omitnan');
    topic_mses_std = std(topic_mses_aggr,0,2, 'omitnan');
    
    topic_rank_corrs = mean(topic_cors_aggr,2, 'omitnan');
    topic_rank_corrs_std = std(topic_cors_aggr,0,2, 'omitnan');
    
    % save results
    file_to_save = [base_file '_evals_part' num2str(i) '.mat'];
    file_path = fullfile(pwd, 'Results', 'evaluation_res','synt', file_to_save);
    save(file_path, 'time_mses','time_mses_std', 'topic_mses','topic_mses_std', 'time_rank_corrs', 'time_rank_corrs_std', ...
        'topic_rank_corrs','topic_rank_corrs_std', 'q_log_like','q_log_like_std', 'a_log_like','a_log_like_std');
end