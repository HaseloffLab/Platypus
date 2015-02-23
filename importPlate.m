function data = importPlate(fname, mask, mnames, numtpts);
%--------------------------------------------------------------------------
% data = importPlate(fname, mask, mnames)
%
% importPlate: import data from BMG plate reader csv file.
%
% Load BMG plate reader exported csv file and fill in a struct array - one
% struct per well
%
% fname = file name
% mnames = list of string names of measurments (e.g. {'OD', 'CFP', 'YFP'}) in the
% order they appear in the platereader file.
%
% mask = (12x8 matrix) if supplied to select which wells to load, mask>=0
%
% (c) Tim Rudge, 2014 
% (Provided under GPL v3 license, http://www.gnu.org/copyleft/gpl.html)
%--------------------------------------------------------------------------

% Run python script to convert csv file into sensible format
mfile = mfilename('fullpath');
[pathtoscript,name,ext] = fileparts(mfile);
pcall = sprintf('python %s/ConvertPlateReader.py %s temp.csv', pathtoscript, fname);
for i=1:length(mnames);
    pcall = [pcall, ' ', mnames{i}];
end;
system(pcall);

%data = struct(mnames{1},{},mnames{2},{},mnames{3},{},'t',{});
data = struct(mnames{1},{},'t',{});

d = importdata('temp.csv');
nc = max(d.data(:,2)) - min(d.data(:,2)) + 1;
nr = max(d.data(:,3)) - min(d.data(:,3)) + 1;
nt = size(d.data,1)/(nc*nr);
nn = size(d.colheaders,2);
rdata = reshape(d.data,nt, nr, nc, nn);

% There are less time points than use specified, get all of them
if nt<numtpts; numtpts=nt;

% no mask = use all wells
if isempty(mask);
    mask = zeros(12,8); 
end;

for i=1:nr;
    for j=1:nc;
        if mask(i,j)>=0;
            data(i,j).t = rdata(1:numtpts,i,j,4);
            for k=1:length(mnames);
                data(i,j).(mnames{k}) = rdata(1:numtpts,i,j,k+4);
            end;
        end;
    end;
end;
