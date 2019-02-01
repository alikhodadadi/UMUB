%This script averages the results
n_tests = 5;
dataset = 'synt';
for part = 1 : 5
    % Temp files
    time_mses_temp        = zeros(n_tests, 3);
    time_rank_corrs_temp  = zeros(n_tests, 3);
    
    topic_acc1_temp       = zeros(n_tests, 1);
    topic_acc2_temp       = zeros(n_tests, 1);
    topic_mses_temp       = zeros(n_tests, 3);
    topic_rank_corrs_temp = zeros(n_tests, 3);
    %
    for i = 1 : n_tests
    %%+++ load the data  +++%%
    file_name = fullfile(pwd, 'Results', 'evaluation_res',...
        ['synt' num2str(i)],[dataset '_data_evals_part' num2str(part) '.mat']);
    %disp(file_name)
    load( file_name );
    %%+++ store the data +++%%
    time_mses_temp       (i, :) = time_mses;
    time_rank_corrs_temp (i, :) = time_rank_corrs;
    topic_acc1_temp      (i, :) = topic_acc1;
    topic_acc2_temp      (i, :) = topic_acc2;
    topic_mses_temp      (i, :) = topic_mses;
    topic_rank_corrs_temp(i, :) = topic_rank_corrs;
    
    end
    % Save the results
    time_mses       = mean(time_mses_temp,        'omitnan');
    time_rank_corrs = mean(time_rank_corrs_temp,  'omitnan');
    topic_acc1      = mean(topic_acc1_temp,       'omitnan'); 
    topic_acc2      = mean(topic_acc2_temp,       'omitnan'); 
    topic_mses      = mean(topic_mses_temp,       'omitnan'); 
    topic_rank_corrs= mean(topic_rank_corrs_temp, 'omitnan'); 
    % save
    out_file = fullfile(pwd, 'Results', 'evaluation_res',...
        'synt',[dataset '_data_evals_part' num2str(part) '.mat']);
    save(out_file, 'time_mses', 'time_rank_corrs', 'topic_acc1', ...
        'topic_acc2', 'topic_mses', 'topic_rank_corrs');
end
