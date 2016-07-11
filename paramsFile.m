%data locations
params.acq.subjID = 'BrainSLAM';
params.acq.BehavioralDataDir = '/Users/admin/Desktop/'; 
params.acq.MapDataDir = 'Maps/';
params.acq.Map = 'City1A';

%behavioral acquisition parameters 
params.acq.nruns = 1; 
params.acq.sampling_rate = 5; %number of samples per second - in the data, so not needed here probably

%scan acquisition parameters
params.scan.tr = 3; %in seconds
params.scan.length = 198*params.scan.tr; %in seconds

%for data cleaning
params.loc.dis_thresh = 160; %impossible jump bw tps, in virtual units

%for heading regressors specifically
params.heading.binSize = 5; %in degrees
params.heading.kappa = 22; %compression of von mises (1/kappa is analogous to std^2) 

%for location regressors specifically
params.location.pyramidSize = 4; %size of Gaussian pyramid
params.location.stdSep = 4; %how separated each Gaussian is at each pyramid level
params.location.minSTD = 40; %in pixels, minimum path width, used as smallest stdev
params.location.downSample = 0.3; %downsample map & path for location filters
params.location.ntptsthresh = 3; %how many tpts must be included sampled per filter as a minimum

%for allo boundary regressors specifically
params.AlloBorder.nangles = 8;
params.AlloBorder.ndistances = 8;
params.AlloBorder.nearBias = 1; %1 or 0 to include near bias or not
params.AlloBorder.SDang = params.heading.kappa; %angular kappa
params.AlloBorder.SDrad = 0; %radial std constant (note that this scales linearly with distance)
params.AlloBorder.n2sample = 16; %number of angles to sample boundaries at before passing through BVC; bigger = better 

%for ego boundary regressors specifically
% params.EgoBorder.nangles = 8;
% params.EgoBorder.ndistances = 6;
% params.EgoBorder.nearBias = 1; %1 or 0 to include near bias or not
% params.EgoBorder.SDseparation = 2; %separate gaussians by n stdevs

%for ego motion regressors

%for regression
params.regress.ndelays = 0; %cut from beginning of each run; in seconds
params.regress.modelType = 1; %1=FIR, 2=Canonical HRF
params.regress.ntps = 16; %if FIR, number of tps to estimate
params.regress.alphaValue = 0.5; %alpha value for lasso (ENA) (use ENA_regression)
params.regress.corrValNum = 10; %n fold cross-validation