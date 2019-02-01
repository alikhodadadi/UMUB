clc;clear;
%% ======================== [Add to path] ============================== %%
addpath(genpath(fullfile(pwd, 'Utils'      )), '-BEGIN');
addpath(genpath(fullfile(pwd, 'Simulation' )), '-BEGIN');
addpath(genpath(fullfile(pwd, 'Results'    )), '-BEGIN');
addpath(genpath(fullfile(pwd, 'Plot'       )), '-BEGIN');
addpath(genpath(fullfile(pwd, 'Inference'  )), '-BEGIN');
addpath(genpath(fullfile(pwd, 'Evaluation' )), '-BEGIN');
addpath(genpath(fullfile(pwd, 'Data      ' )), '-BEGIN');

n_samples = 10;
for sample = 1:1
    dataset = ['simple_model_synt50_exp_compare_data' num2str(sample)];
    %% ======================== [Data Generation]   ======================== %%
    simulator_main_simple
    % pars = struct;
    % pars.em_iter_thresh  = 50;
    % pars.em_diff_thresh  = 0.0001;
    % [ answers_pars ] = answers_pars_inference_simple( data, pars,@g)
    % temp_eval_res
    
    %% ======================== [Do the Evaluation] ======================== %%
    synth_evaluation_main_simple
end
