% Example of plate reader data analysis
%
% See also:
%   IMPORTPLATE2
%   SMOOTHTIMECOURSE
%   CORRECTBACKGROUND
%   SELECTWINDOW
%   COMPUTERATES
%   PLOTPROFILE
%


%mask = zeros(12,8);
%mask(4:5,1:2) = 1; % Use only first 3 rows of plate
mask = ones(12,8);

% Import data from file 240413.csv
p = importPlate('140813_AK_MK01.csv', mask, {'CFP','YFP','OD'});

% Smooth each channel with its own parameter
p = smoothTimecourse(p, 1e-5, 'CFP');
p = smoothTimecourse(p, 1e-5, 'YFP');
p = smoothTimecourse(p, 1e-4, 'OD');

% Correct OD background with minimum as bg value
p = correctBackground(p, 'OD', []);

% Choose a window of data with 0.1<OD<0.8, and 0<t<1000
p = selectWindow(p, [0.1,0.8], [0,1000]);

% Compute the rates per OD of all channels
p = computeRates(p, {'OD','CFP','YFP'});

% Plot some timecourses 
figure; plot(p(1).t, p(1).CFP, 'b');
hold on; plot(p(1).t, p(1).YFP, 'r');

% Plot some values against an inducer concentration
inducer = 1e-6*[0	0.01	0.1	1	2.5	5	10	25	50	100	250	500];    %some arbitrary concentrations for illustration
wells = [1:12]; % plotting first 12 wells = first row

figure; plotProfile(p, inducer, 'CFP_rate_mean', wells, 'b.');
hold on; plotProfile(p, inducer, 'YFP_rate_mean', wells, 'r.');

% This will plot the mean CFP level, because 'CFP' is a timecourse
figure; plotProfile(p, inducer, 'CFP', wells, 'b.');
