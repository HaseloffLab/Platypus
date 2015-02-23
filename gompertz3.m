function y = gompertz3(p, t);
%--------------------------------------------------------------------------
% y=gompertz3(p,t)
%
% Compute a Gompertz growth model at time t, with given parameters p,
% where:
%
% p = [log(K), lambda, log(mu)]
%
% i.e. K and mu are fitted in log space, guaranteeing positivity, and
% lambda (lag period) is in real space, allowing zero or negative values.
% This might occur e.g. if the data does not contain any lag phase growth.
%
% (c) Tim Rudge, 2014 
% (Provided under GPL v3 license, http://www.gnu.org/copyleft/gpl.html)
%--------------------------------------------------------------------------

% p = [log(K), lambda, log(mu)]
K = exp(p(1));
lambda = p(2); 
mu = exp(p(3));

% y = log(OD/OD0)
y = K*exp(-exp(mu*exp(1)*(lambda-t)/K +1));

