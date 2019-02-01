MSE_res = zeros(n_u,1);
corr_res = zeros(n_u,1);
for u = 1:n_u
    real_eta = model.tag_pars.eta(u,:)';
    inferred_eta = answers_pars.user_expertises(u,:)';
    [real_eta, inferred_eta]
    MSE_res(u) = mean((real_eta-inferred_eta).^2);
    corr_res(u) = corr(real_eta, inferred_eta);
end
disp('---------------------------')
disp(['* avg. MSE: ', num2str(mean(MSE_res)),' *']);
disp(['* avg. Corr: ', num2str(mean(corr_res)), '  *']);
disp('---------------------------')

