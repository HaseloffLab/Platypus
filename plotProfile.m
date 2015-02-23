function plotProfile(plate, xvalues, fieldname, idxs, linespec);
%--------------------------------------------------------------------------
% plotProfile(plate, xvalues, fieldname, idxs, linespec)
%
% plotProfile: plot plate reader analysis data on a given x-axis.
%
%   plate = cell array returned by importPlate2 or subsequent processing
%   xvalues = values to use on x-axis for each data point
%   fieldname = the name of the field (string) in <plate> to plot, e.g.
% 'CFP_ratio_mean', if the field is an array (e.g. 'CFP_ratio') then the
% mean value over the timecourse will be plotted.
%   idxs = list of indexes of the wells (1...96) to plot ([] means plot all)
% linespec = plot options (see also PLOT).
%
% (c) Tim Rudge, 2014 
% (Provided under GPL v3 license, http://www.gnu.org/copyleft/gpl.html)
%--------------------------------------------------------------------------


if ~isempty(idxs);
    plate = plate(idxs);
    xvalues = xvalues(idxs);
end;
if length(plate(:))~=length(xvalues(:));
    disp 'Number of x-axis values is different to number of wells in plate';
    return;
end;
if length(plate(1).(fieldname)(:))>1;
    disp(['Note: field ' fieldname ' is an array, plotting mean value']);
end;



data = zeros(size(plate));
n = length(plate(:));
for i=1:n;
    data(i) = mean(plate(i).(fieldname));
end;

plot(xvalues, data, linespec);