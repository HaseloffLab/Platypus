function gp = fitGompertzModel(p, odmin);
%--------------------------------------------------------------------------
% gp = fitGompertzModel(p, odmin)
%
% fitGompertzModel: Fits a Gompertz model to log(OD/OD0) data in plate p, and
% identifies an exponential phase window as peak growth (t_m) to peak
% growth + 4 doubling periods.
%
% p = plate data structure as returned by importPlate etc.
% odmin = minimum OD to consider for OD0 (initial OD)
%
% gp = modified plate data struct, with params of Gompertz model:
%
% gompertz_K, gompertz_lambda, gompertz_mu
%
% and a function handle @(t)gompertz_func. Window start/end times 
% (window_t0, window_t1) and indexes (window_idx) are also stored in gp.
%
% (c) Tim Rudge, 2014 
% (Provided under GPL v3 license, http://www.gnu.org/copyleft/gpl.html)
%--------------------------------------------------------------------------

if ~isempty(odmin); odmin=0.001;
n=numel(p);

for i=1:n;
    if ~isempty(p(i).OD);
        idx = find(p(i).OD>odmin);
        tmean = mean(p(i).t(idx));
        OD0 = p(i).OD(idx(1));

        % X and Y data for fitting
        x = p(i).t(idx)/tmean; % scaled abscissa
        y = log(p(i).OD(idx)/OD0); % log(A/A0)
        
        % Run nlinfit
        opts = statset('robust','off');
        [beta,r,J,COVB,mse] = nlinfit(x, y, @(b,x)gompertz3(b,x), [0,0,0], opts);
        
        % Rescale params
        p(i).gompertz_K = exp(beta(1));
        p(i).gompertz_lambda = beta(2)*tmean;
        p(i).gompertz_mu = exp(beta(3))/tmean;
        
        % Define function for this well's OD
        p(i).gompertz_func = @(x) OD0*exp(gompertz3(beta,x/tmean));
        
        % Time of peak growth rate
        tm = p(i).gompertz_K/(exp(1)*p(i).gompertz_mu) + p(i).gompertz_lambda;
        
        % Set the time window to t_m, t_m + 4 doubling times
        p(i).window_t0 = tm; 
        p(i).window_t1 = tm + 4*log(2)/p(i).gompertz_mu; 
        
        % Set the indexes of these time points
        p(i).window_idx = find((t>p(i).window_t0).*(t<p(i).window_t1));
    end;
end;

% Return modified plate
gp=p;

% END: fitGompertzModel