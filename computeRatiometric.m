function rplate = computeRatiometric(plate, ch, chref);
%--------------------------------------------------------------------------
% rplate = computeRatiometric(plate, ch, chref)
%
% computeRatiometric: compute ratiometric expression rate for channel ch,
% using full time course (<ch>_ratio), mean of this ratio (<ch>_mean_ratio), ratio of
% mean single channel expression rates (<ch>_ratio_of_means), and linear
% regression of ch against chref (<ch>_ratio_regr).
%
% Note: <ch>_ratio_regr_r2 gives the regression R^2.
%

% plate = cell array returned by importPlate2 or subsequent processing.
% ch = name of channel to compute ratio for (string).
% chref = reference channel name.
%
% (c) Tim Rudge, 2014 
% (Provided under GPL v3 license, http://www.gnu.org/copyleft/gpl.html)
%--------------------------------------------------------------------------


n = length(plate(:));

for i=1:n;
    chrate = [ch '_rate'];
    refrate = [chref '_rate'];

    rname = [ch '_ratio'];
    mrname = [ch '_mean_ratio'];
    rmname = [ch '_ratio_of_means'];
    regname = [ch '_ratio_regr'];
    r2name = [ch '_ratio_regr_r2'];

    t = plate(i).window_t;

    % make sure to use background corrected OD here...
    plate(i).(rname) = plate(i).(chrate)./plate(i).(refrate);
    plate(i).(mrname) = mean(plate(i).(rname));
    plate(i).(rmname) = mean(plate(i).(chrate))/mean(plate(i).(refrate));

    % Compute linear regression of ch against chref
    p = polyfit(plate(i).(chref), plate(i).(ch),1);
    yfit = polyval(p,plate(i).(chref));
    yresid = plate(i).(ch) - yfit;
    SSresid = sum(yresid.^2);
    SStotal = (length(plate(i).(ch))-1) * var(plate(i).(ch));
    r2 = 1 - SSresid/SStotal;

    plate(i).(regname) = p(1); % slope
    plate(i).(r2name) = r2;
end;

rplate = plate;