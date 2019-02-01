function [ tag_model ] = tag_model_generator( num_users, tag_pars)
%The function which generates a model of topics for simulations
%   This function accepts as the input some parameters and generates a
%   topic model which contains the parameters which is needed for
%   simulating the topic of events
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%%INPUTS:
% |  num_users:               Total number of users
% |  tag_pars:                A struct containing the following fields
% |  |   tag_pars.num_tags:   Total number of tags
% |  |   tag_pars.a:          A 1*K vector which contains the parameter of
% |  |                          Dir. dist. (K is the number of tags)
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%%OUTPUTS:
% | model:
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%% Constructing needed variables
tag_model = struct;
tag_model.num_users  = num_users;
tag_model.num_tags = tag_pars.num_tags;

%% Generate tag based parameters of users
% Tag interests
tag_model.alpha = dirichlet_sample(tag_pars.a, num_users);
% Tag expertise
tag_model.eta   = dirichlet_sample(tag_pars.a, num_users);
end