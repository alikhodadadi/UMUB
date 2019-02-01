function [ topic_pars ] = match_topics( topic_model, topic_pars )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
topic_model.alpha
topic_model.beta
topic_model.eta

c = corr( topic_pars.beta, topic_model.beta );
[~, I] = max(c);
if(length(unique(I)) == length(I))
    tpc_inds = I;
    topic_pars.alpha = topic_pars.alpha(:, tpc_inds);
    topic_pars.eta   = topic_pars.eta  (:, tpc_inds);
    topic_pars.beta  = topic_pars.beta (:, tpc_inds);
    topic_pars.phi   = topic_pars.phi  (:, tpc_inds);
else
    match_idx = I;
    finished = 0;
    while(finished == 0)
        for i = 1 : length(I)
            % find the best match
            mtchs = find(match_idx == i);
            if(length(mtchs)~= 1)
                %c(i, mtchs)
                [~, ind] = max(c(i, mtchs));
                % selected
                match_idx( mtchs(ind)) = i;
                % reminder
                mtchs(ind) = [];% remove the besst from matches
                %mtchs
                for j = 1 : length(mtchs)
                    %c(:, mtchs(j))
                    [~, j_idxs] = sort(c(:, mtchs(j)), 'descend');
                    id = find(j_idxs == match_idx(mtchs(j)));
%                     mtchs(j)
%                     size(match_idx)
%                     j_idxs
                    match_idx(mtchs(j)) = j_idxs(id + 1);
                end
            end
            % check if finished
            if(length(unique(match_idx)) == length(I))
                disp('salam')
                match_idx
                finished = 1;
                break;
            end
        end
    end
    %
    tpc_inds = match_idx;
    topic_pars.alpha = topic_pars.alpha(:, tpc_inds);
    topic_pars.eta   = topic_pars.eta  (:, tpc_inds);
    topic_pars.beta  = topic_pars.beta (:, tpc_inds);
    topic_pars.phi   = topic_pars.phi  (:, tpc_inds);
end
end

