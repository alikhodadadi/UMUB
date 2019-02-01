function [ x ] = solve_cvx_problem( F, H , n_t)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% rng(0,'twister')
size(F)
size(H)
cvx_begin 
        variable x(n_t) nonnegative;
        minimize -F*log(x)+ H*x + 0.0001 * norm(x, 1);
        subject  to
            sum(x) == 1;
cvx_end
end

