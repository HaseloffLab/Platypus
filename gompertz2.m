function y = gompertz2(p, t);

% p = [log(K), mu] )
K = exp(p(1));
lambda = 0; % With low initial dilution lag phase is too short to estimate
mu = exp(p(2));

% y = ln(OD/OD0)
y = K*exp(-exp(mu*exp(1)*(lambda-t)/K +1));

