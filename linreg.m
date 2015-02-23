function [p,r2, ci] = linreg(x,y);
% Return linear fit params p, and R^2

[p,S,mu] = polyfit(x,y,1);

yfit = polyval(p,x);
yresid = y - yfit;
SSresid = sum(yresid.^2);
SStotal = (length(y)-1) * var(y);
r2 = 1 - SSresid/SStotal;

ci = polyparci(p,S);