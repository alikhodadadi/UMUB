%% ===========================[ Load Data ]==============================%%
% rng(0, 'twister');
% dataset = 'simple_model_synt_data1';
load( fullfile(pwd, 'Data', 'synt',[dataset '.mat']) );
disp('%% +++++++++++++++++++++ data loaded ++++++++++++++++++++++++++++%%')
T_end = max(data.events.quests.times(end), data.events.answrs.times(end));
n_intervals = 10;
em_diff_thresh = 0.0001;
em_iter_thresh =  6;
pars = struct;
pars.num_tags = data.num_tags;
pars.em_diff_thresh = em_diff_thresh;
pars.em_iter_thresh = em_iter_thresh;
g_t = @(x)g(x);
% duration = zeros(n_intervals, 1);
for i = 10 : n_intervals
    
    disp(['%% ------------ Doing Part: ' num2str(i) '----------------%%'])
    t = i*T_end/n_intervals;
    
    %%++++++++++++++++++++++( Tokenize data )++++++++++++++++++++++++++++%%
    [ s_data ] = split_data( data, t );
    
    %%++++++++++++++++++++++(   Inference   )++++++++++++++++++++++++++++%%
    tic
    [ question_pars ] = question_pars_inference_simple( s_data, pars, g_t);
    [ answer_pars ] = answers_pars_inference_simple( s_data, pars, g_t);
    duration = toc;
    
    %[ topic_pars ] = match_topics( topic_model, topic_pars );
    inferred_model = struct;
    inferred_model.num_users = model.num_users;
   
    time_pars = struct;
    time_pars.q_mus = question_pars.q_mus;
    time_pars.a_mus = answer_pars.a_mus;
    time_pars.q_b_ims = question_pars.q_b_ims;
    time_pars.a_b_ims = answer_pars.a_b_ims;
    time_pars.q_badgeWeights = question_pars.q_badgeWeights;
    time_pars.a_badgeWeights = answer_pars.a_badgeWeights;
    time_pars.q_badgeThreshs = s_data.q_badgeThreshs;
    time_pars.a_badgeThreshs = s_data.a_badgeThreshs;
    time_pars.num_users = model.num_users;
    time_pars.num_qBadges = s_data.num_q_badges;
    time_pars.num_aBadges = s_data.num_a_badges;
    tag_pars = struct;
    tag_pars.num_users = model.num_users;
    tag_pars.num_tags = model.tag_pars.num_tags;
    tag_pars.alpha = question_pars.user_interests;
    tag_pars.eta   = answer_pars.user_expertises;
    
    inferred_model.time_pars = time_pars;
    inferred_model.tag_pars = tag_pars;
    disp(['(part ' num2str(i) ': Inference is done!)']);
    %%++++++++++++++++++++++(  Calc Errors  )++++++++++++++++++++++++++++%%
    % Calc_RMSE
    [ time_mses, topic_mses ] = calc_MSEs_simple ... 
        ( question_pars, answer_pars, model);
    disp(['part ' num2str(i) ': MSE calculation is done!']);
    % Calc_tau_Rank
    [ time_rank_corrs, topic_rank_corrs ] = calc_ranks_simple ...
        ( question_pars, answer_pars, model);
    disp(['(part ' num2str(i) ': Rank correlation is done!)']);
    % Calc likelihood
    [ q_log_like ] = questions_log_like( test_data, inferred_model );
    [ a_log_like ] = answers_log_like( test_data, inferred_model );
    log_like = q_log_like + a_log_like;
%     % Calc Accuracy
%     [ topic_acc1, topic_acc2 ] = calc_topic_accuracy ...
%         ( s_data.events.quests.topics, topic_pars.phi );
%     disp(['(part ' num2str(i) ': Accuracy calulation is done!)']);
    
    %%++++++++++++++++++++++(  Save Results )++++++++++++++++++++++++++++%%
    % save learned parameters
    file_name = [dataset '_pars_part' num2str(i) '.mat'];
    file_path = fullfile(pwd, 'Results', 'learned_pars','synt', file_name);
    save(file_path, 'question_pars', 'answer_pars','duration');
    disp(['(part ' num2str(i) ': Learned parameters saved!)']);
    % save errors
    file_name = [dataset '_evals_part' num2str(i) '.mat'];
    file_path = fullfile(pwd, 'Results', 'evaluation_res','synt', file_name);
    save(file_path, 'time_mses', 'topic_mses', 'time_rank_corrs', ...
        'topic_rank_corrs', 'q_log_like', 'a_log_like');
    disp(['(part ' num2str(i) ': Evaluation metrics saved!)']);
end
