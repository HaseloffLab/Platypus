function rplate = characterize(p, chnames);
%--------------------------------------------------------------------------
% rplate = characterize(p, chnames)
%
% characterize: compute promoter characteristics and rates for the given
% channels.
%
% p = cell array returned by importPlate or subsequent processing.
% chnames = cell array of channel names (e.g. {'YFP', 'CFP'}).
%
% Output is:
%   <chname>_rate = promoter activity
%   <chname>_alpha = constant of proportionality to growth rate
%   <chname>_alpha_r2 = R^2 for linear regression of fluorescence against
%   OD, where alpha is the slope.
%
% (c) Tim Rudge, 2014 
% (Provided under GPL v3 license, http://www.gnu.org/copyleft/gpl.html)
%--------------------------------------------------------------------------


n = length(plate(:));
nc = length(chnames(:));

for i=1:n;
    for c=1:nc;
        chname = chnames{c};
        rname = [chnames{c} '_rate'];
        ar2name = [chnames{c} '_alpha_r2'];
        aname = [chnames{c} '_alpha'];
        
        window_idx = p(i).window_idx;
        [pp,r2] = linreg(p(i).OD(window_idx), p(i).(chname)(window_idx));
        p(i).(aname)= pp(1);
        p(i).(rname) = pp(1)*p(i).gompertz_mu;
        p(i).(ar2name) = r2;
    end;
end;

rplate = p;