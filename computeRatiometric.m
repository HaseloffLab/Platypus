function rplate = computeRatiometric(plate, ch, chref);
%--------------------------------------------------------------------------
% rplate = computeRatiometric(plate, ch, chref)
%
% computeRatiometric: compute ratiometric expression rate for channel ch 
% (<ch>_ratio), simply takes the ratio:
%
%       <ch>_ratio = plate(i).<ch>_alpha / plate(i).<chref>_alpha
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
    if ~isempty(plate(i).(ch)) && ~isempty(plate(i).(chref));
        % Input field names
        chalpha = [ch '_alpha'];
        refalpha = [chref '_alpha'];

        % Output field name
        rname = [ch '_ratio'];

        % Compute the ratio
        plate(i).(rname) = plate(i).(chalpha)./plate(i).(refalpha);
    end;
end;

rplate = plate;