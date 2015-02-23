function nplate = correctBackground(plate, chname, bgval);
%--------------------------------------------------------------------------
% nplate = correctBackground(plate, chname, bgval)
%
% correctBackground: remove background from timecourse measurements.
%
% plate = cell array returned by importPlate2 and subsequent processing.
% chname = name of channel to adjust (string).
% bgval = background value to remove, or [] to use minimum in timecourse.
%
% Remove background from a timecourse channel. Affects all versions
% of timepoints, e.g. chname='YFP' will remove background from 'YFP', 
% and 'sYFP_t'. The fit object 'sYFP' will not be touched, but  
% should be corrected using the 'sYFP_bg' field created here. 
% If bg=[], then the minimum value of the channel (smoothed) in each well
% will be used as background.
%
% TO DO: specify a blank well/wells to use full timecourse/mean as background
%
% (c) Tim Rudge, 2014 
% (Provided under GPL v3 license, http://www.gnu.org/copyleft/gpl.html)
%--------------------------------------------------------------------------


schname = ['s' chname];
bgname = [chname '_bg'];
stchname = [schname '_t'];
n = length(plate(:));

for i=1:n;
    if isempty(bgval);
        bg = min(plate(i).(stchname));
    else;
        bg = bgval;
    end;
    bg = bg(:);
    nbgt = length(bg);
    nct = length(plate(i).(chname));
    if nct>nbgt;
        % Pad bg values with mean of last 10 time points
        nextra = nct-nbgt;
        bg = [bg; mean(bg(end-9:end))*ones(nextra,1)];
    end;
    % Subtract bg from time points
    plate(i).(chname) = plate(i).(chname) - bg; %max(0, plate(i).(chname) - bg);
    %plate(i).(stchname) = max(0, plate(i).(stchname) - bg);
    %% bg correction for smoothed data
    %plate(i).(bgname) = bg;
    
    % This is a nicer way to correct the smoothed function, but is
    % INCREDIBLY slow for some reason.
    %plate(i).(scorrchname) = @(t) max(0, feval(plate(i).(schname),t) - bg); 
    
end;

nplate = plate;