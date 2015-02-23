function wplate = selectWindow(plate, odrange, trange);
%--------------------------------------------------------------------------
% wplate = selectWindow(plate, odrange, trange)
%
% selectWindow: crop timecourse data to given time and OD ranges.
%
% odrange = [min,max] OD
% trange = [min,max] time
%
% Eliminates data outside given OD and time ranges, returns a new cell
% array containing <window_t> - the appropriate times, 
% and <window_idx> the indexes of each time point in the measurement arrays.
%
% (c) Tim Rudge, 2014 
% (Provided under GPL v3 license, http://www.gnu.org/copyleft/gpl.html)
%--------------------------------------------------------------------------

n = length(plate(:));
odmin = odrange(1);
odmax = odrange(2);
trmin = trange(1);
trmax = trange(2);

for i=1:n;
    % Select data range to use, od>odmin and time range
    tmin1 = max(find( plate(i).sOD_t<odmin )) + 1;
    tmin2 = max(find( plate(i).t<trmin )) + 1;
    tmin = max([tmin1,tmin2]);

    tmax1 = max(find(plate(i).t<=trmax));
    tmax2 = max(find(plate(i).sOD_t<=odmax));
    tmax = min([tmax1,tmax2]);

    tidx = [tmin:tmax];
    plate(i).window_idx = tidx;
    plate(i).window_t = plate(i).t(tidx);
end;

wplate = plate;