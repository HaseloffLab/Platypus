function splate = smoothTimecourse(plate, sparam, chname);
%--------------------------------------------------------------------------
% splate = smoothTimecourse(plate, sparam, chname)
%
% smoothTimeCourse: fit smoothing splines to timecourse data
%
% Fit smoothing splines to time course measurements in each well of plate
%
% plate = cell array returned by importPlate and subsequent processing
% sparam = parameter for spline fitting (see also FIT)
% chname = name (string) of channel to spline fit (e.g. 'YFP', 'OD')
% 
% This function will create a new cell array that is copied from plate, 
% and adds a field called s<chname>, e.g. sYFP with
% the function fit object, and another field called s<chname>_t, e.g.
% sYFP_t that evaluates this function at each time point.
%
% (c) Tim Rudge, 2014 
% (Provided under GPL v3 license, http://www.gnu.org/copyleft/gpl.html)
%--------------------------------------------------------------------------

outname1 = ['s' chname];
outname2 = ['s' chname '_t'];
n = length(plate(:));

for i=1:n;
    well = plate(i);
    plate(i).(outname1) = fit(plate(i).t, plate(i).(chname), 'smoothingspline', 'smoothingparam', sparam);
    plate(i).(outname2) = feval(plate(i).(outname1), plate(i).t);
end;

splate = plate;