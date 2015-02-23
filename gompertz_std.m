function y = gompertz_std(p, t);

% p =  [K, lambda, mu] 
K = p(1);
lambda = p(2); 
%lambda = 0; % With low initial dilution lag phase is too short to estimate
mu = p(3);

% y = ln(OD/OD0)
y = K*exp(-exp(mu*exp(1)*(lambda-t)/K +1));

