function [ topic_pars ] = topic_pars_inference( data, pars)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
%% 
quests = data.events.quests;
answrs = data.events.answrs;
n_q = length(quests.times );
n_a = length(answrs.times );
n_t = pars.num_topcs;
n_w = data.num_words;
n_u = data.num_users;
%% Initialization
eta   = dirichlet_sample(0.1*ones(1,n_t), n_u);%user_topic_expert
alpha = dirichlet_sample(0.1*ones(1,n_t), n_u);%user_topic_intrst
beta  = dirichlet_sample(0.1*ones(n_w,1), n_t);%topic_word_dists
psi   = rand(n_a,1);%variational parameter of log_sum
phi = zeros(n_q, n_t);%event_topic_probs
%disp('%--- After Init. ---%');
% max( eta )
% max( alpha)
% max(beta)
% max(psi)

%% EM
converged = false;
itr = 0;
while(~converged)
    itr = itr + 1;
    disp(itr);
    
    prev_eta   = eta;
    prev_alpha = alpha;
    prev_beta  = beta;
  %  prev_psi   = psi;
    
    %%+++ E-Step
    nc = 1;
    ir = 0;
    while(nc)
        ir = ir + 1
        prev_phi = phi;
        prev_psi   = psi;
        for i = 1:n_q
            ui = quests.users(i);
            ti = quests.times(i);
            wi = quests.tags(i);
            res = log(alpha(ui,:));
            res = res + log(beta(wi,:));
            ans_inds = find(answrs.parents == i);
            if(~isempty(ans_inds))
                %            disp('salam!!!');
                res = res + sum(log(eta(answrs.users(ans_inds),:)));
                res = res - psi(ans_inds)'*(eta(answrs.users(ans_inds),:)...
                    .*repmat(exp(-(answrs.times(ans_inds))-ti),[1,n_t]));
            end
            % impact of those who are not answer of question i
            t_inds = find(answrs.times>ti & answrs.parents~=i) ;%??
            if(~isempty(t_inds))
                us = answrs.users(t_inds);
                ts = answrs.times(t_inds);
                res = res - psi(us)'*(eta(us,:).*repmat(exp(-(ts-ti)),[1,n_t]));
            end
            phi(i,:) = exp(res)./sum(exp(res));
        end
        %psi
        psi = zeros(n_a, 1);
        for j = 1 : n_a
            tj = answrs.times(j);
            uj = answrs.users(j);
            q_inds = find(quests.times < tj);% May be I only consider the last 20
            f_delt = exp(-(tj- quests.times(q_inds)));
            psi(j) = f_delt'*phi(q_inds,:)*eta(uj,:)';
        end
        %check convevrgence
        cphi = max( max( abs( phi - prev_phi )));
        cpsi = max( max( abs( psi - prev_psi )));
        if(max([cphi,cpsi])< pars.em_diff_thresh || ir > pars.em_iter_thresh)
            nc = 0;
        end
    end
    %break;
    %phi
    %%+++ M-Step
    % alpha & beta
    event_count = zeros(n_u, 1);
    alpha = zeros(n_u, n_t);
    beta  = zeros(n_w, n_t);
    for i = 1:n_q
%          if(mod(i,100))
%             disp(['num_q: ', int2str(i)])
%         end
        ui = quests.users(i);
        wi = quests.tags(i);
        phi_i = phi(i,:);
        %phi_i
        event_count(ui) = event_count(ui) + 1;
        alpha(ui,:) = alpha(ui,:)+ phi(i,:);
        beta(wi,:) = beta(wi,:) + phi_i; 
    end
    %
   % alpha
   % beta
    alpha = alpha./repmat(event_count, [1,n_t]);
    beta  = beta./repmat(sum(beta, 1),[n_w,1]);
   % alpha
   % beta
   % sum(alpha)
   % sum(beta)
    
    %eta
    eta = find_opt_etas(data, pars, phi, psi);
%     %psi
%     psi = zeros(n_a, 1);
%     for j = 1 : n_a
%         tj = answrs.times(j);
%         uj = answrs.users(j);
%         q_inds = find(quests.times < tj);% May be I only consider the last 20
%         f_delt = exp(-(tj- quests.times(q_inds)));
%         psi(j) = f_delt'*phi(q_inds,:)*eta(uj,:)';
%     end
% %     psi
%     break;
    % check the convergence
    c1 = max( max( abs( eta   - prev_eta   )));
    c2 = max( max( abs( alpha - prev_alpha )));
    c3 = max( max( abs( beta  - prev_beta  )));
%     c1
%     c2
%     c3
    if(max([c1,c2,c3])< pars.em_diff_thresh || itr > pars.em_iter_thresh)
        itr
        converged = true;
    end
end
%
topic_pars = struct;
topic_pars.alpha = alpha;
topic_pars.eta   = eta  ;
topic_pars.beta  = beta ;
topic_pars.phi   = phi  ;% topic of each question may be useful
end