% Example of plate reader data analysis
%
% See also:
%   ANALYZEPLATE
%   IMPORTPLATE
%   SMOOTHTIMECOURSE
%   CORRECTBACKGROUND
%   FITGOMPERTZMODEL
%   GOMPERTZ3
%   CHARACTERIZE
%   COMPUTERATIOMETRIC
%   PLOTPROFILE
%

% Create mask to select wells in plate
mask = zeros(12,8);
mask(1:36) = 1;
mask(1:6,6:8) = 1;

% Import data (assuming cwd is Platypus)
p1 = importPlate('data/Tim011114.csv', mask, {'CFP','YFP','OD'}, 100);
p2 = importPlate('data/Tim061114.csv', mask, {'CFP','YFP','OD'}, 100);

% Analyze the data
p1 = analyzePlate(p1);
p2 = analyzePlate(p2);

% Organise the data accoring to plasmid, replicate, and colony
[y,c,mum] = reshapelb(p1, p2);

% Plot heat maps of the data
figure; 
subplot(3,1,1); imagesc(reshape(y,6,6)); axis equal; colorbar; title('\alpha_y');
subplot(3,1,2); imagesc(reshape(c,6,6)); axis equal; colorbar; title('\alpha_c');
subplot(3,1,2); imagesc(reshape(y./c,6,6)); axis equal; colorbar; title('\rho');

