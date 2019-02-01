function [ rank ] = tau_rank( x, y, type)
%UNTITLED7 Summary of this function goes here
%   type variable  determines the column or row rank calculations
%   type: 1=column, 2= row
%
if(size(x)~= size(y))
    disp('Size of input matrices should be equall!!');
end
[r, c] = size(x);
if(type == 1)% col
    res = 0;
    for i = 1:c
        res = res + corr(x(:,i), y(:,i));
    end
    res = res/c;
else %row
    res = 0;
    for i = 1:r
        res = res + corr(x(i,:)', y(i,:)');
    end
    res = res/r;
end
rank = res;
end

