function ap = analyzePlate(p);
%--------------------------------------------------------------------------
% ap = analyzePlate(p)
%
%
% p = plate data structure as returned by importPlate etc.
%
% ap = modified plate data struct after:
%
%   1. background correction
%   2. time-course smoothing
%   3. Gompertz model fitting
%   4. YFP and CFP promoter characterization
%   5. Computation of ratiometric characteristics
%
% (c) Tim Rudge, 2014 
% (Provided under GPL v3 license, http://www.gnu.org/copyleft/gpl.html)
%--------------------------------------------------------------------------

p = correctBackground(p, 'OD', bg.OD_mean);
p = correctBackground(p, 'CFP', bg.CFP_mean);
p = correctBackground(p, 'YFP', bg.YFP_mean);

% Generate spline-smoothed versions of time courses - currently not 
% actually used but could be helpful
p = smoothTimecourse(p, 1e-5, 'CFP');
p = smoothTimecourse(p, 1e-5, 'YFP');
p = smoothTimecourse(p, 1e-4, 'OD');

% Fit the growth model
p = fitGompertzModel(p, 0.001);

% Compute promoter characteristics for YFP and CFP
p = characterize(p, {'YFP', 'CFP'});

% Compute ratiometric characteristics
p = computeRatiometric(p, 'YFP', 'CFP');