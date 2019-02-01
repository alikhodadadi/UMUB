n_samples = 10;
n_intervals = 10;
for sample = 1%:n_samples
    dataset = ['simple_model_synt10000_data' num2str(sample)];
    %% ======================== [Load Data]   ======================== %%
    load( fullfile(pwd, 'Data', 'synt',[dataset '.mat']) );
    bis = zeros(1,n_intervals);
    mus = zeros(1,n_intervals);
    als = zeros(1,n_intervals);
    ets = zeros(1,n_intervals);
    ovs = zeros(1,n_intervals);
    for i=1:n_intervals
        % load metrics
        file_name = [dataset '_pars_part' num2str(i) '.mat'];
        file_path = fullfile(pwd, 'Results', 'learned_pars','synt', file_name);
        load( file_path );
    %% ======================== [Do the Evaluation] ======================== %%
        % Calc_RMSE
        [ time_mres, topic_mres ] = calc_MREs_simple ... 
            ( question_pars, answer_pars, model);
        mus(i) = time_mres(1);
        bis(i) = time_mres(3);
        als(i) = topic_mres(1);
        ets(i) = topic_mres(2);
        ovs(i) = topic_mres(1)+ topic_mres(2);
        ovs(i) = ovs(i)/2;
        disp(['part ' num2str(i) ': MRE calculation is done!']);
    end
    ovs'
    figure;
    plot(mus);
    figure;
    plot(bis);
    figure;
    plot(als);
    figure;
    plot(ets);
    figure;
    plot(ovs);
    title('overal')
end