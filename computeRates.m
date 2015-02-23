function rplate = computeRates(plate, chnames);
%--------------------------------------------------------------------------
% rplate = computeRates(plate, chnames)
%
% computeRates: compute rates per OD in given measurement timecourses. 
% For measurement y this function computes (1/OD(t))dy/dt. Note
% that rate of OD per OD is the exponential growth rate. 
%
% plate = cell array returned by importPlate2 or subsequent processing.
% chnames = cell array of channel names (e.g. {'OD', 'CFP'}).
%
% Compute the per OD rate of each channel (C) as (1/OD)dC/dt
%
% (c) Tim Rudge, 2014 
% (Provided under GPL v3 license, http://www.gnu.org/copyleft/gpl.html)
%--------------------------------------------------------------------------


n = length(plate(:));
nc = length(chnames(:));

for i=1:n;
    for c=1:nc;
        oname = [chnames{c} '_rate'];
        mxname = [chnames{c} '_rate_max'];
        mname = [chnames{c} '_rate_mean'];
        mdname = [chnames{c} '_rate_median'];
        sdname = [chnames{c} '_rate_std'];
        
        f = plate(i).(['s' chnames{c}]);
        t = plate(i).t; %window_t;
        
        % make sure to use background corrected OD here...
        sOD_corr = feval(plate(i).sOD, t); %feval(plate(i).sOD, t) - plate(i).OD_bg(plate(i).window_idx) + 0.01;
        plate(i).(oname) = max(0,differentiate(f, t)./sOD_corr);
        plate(i).(mxname) = max(plate(i).(oname));
        plate(i).(mname) = mean(plate(i).(oname));
        plate(i).(mdname) = median(plate(i).(oname));
        plate(i).(sdname) = std(plate(i).(oname));
    end;
end;

rplate = plate;