function [ answers_pars ] = answers_pars_inference_simple_cvx( data, pars, g);
%This function infers the parameters using cvx
n_u = data.num_users;
n_t = data.num_tags;
a_mus = zeros(n_u, 1);
a_badge_impacts = zeros(n_u, 1);
user_expertises = zeros(n_u, n_t);
for u =1%:n_u
    cvx_begin
        variables eta_u(n_t) mu_u b_im_u 
        minimize user_answer_lglk(u, mu_u, b_im_u, eta_u, data);
        subject  to
            sum(eta_u) == 1;
            eta_u >= 0;
            mu_u >= 0;
            b_im_u >= 0;
    cvx_end
    a_mus(u) = mu_u;
    a_badge_impacts(u) = b_im_u;
    user_expertises(u, :) = eta_u; 
end
answers_pars                = struct;
answers_pars.a_mus          = a_mus;
answers_pars.a_b_ims        = a_badge_impacts;
answers_pars.user_expertises = user_expertises;
end

