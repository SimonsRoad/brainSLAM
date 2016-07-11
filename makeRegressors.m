close all; clc; clear all;

%% load parameter files and function paths
paramsFile;

%add regressor functions to path
addpath(genpath('/Users/admin/Desktop/Experiments/brainSLAM/scripts'));

%% get data

%load the map and scale_factor for locations associated with map
load(params.acq.Map);


for i=1:params.acq.nruns;
    
    %file name
    filename = [params.acq.subjID '_Run' int2str(i) '.txt'];
    
    %get data
    %n.b. time is in seconds from onset of run
    [location angle time] = getBSLAM_behavior_data(filename,params);
    
    %filter location data
    location = filter_location_data(location,params,scale_factor);
    
    %data in struct
    data.location{i} =  location;
    data.orientation{i} = angle;
    data.time{i} = time;
    
end

%% make heading regressors
% Xhead = make_orientation_regressors(data.orientation,params);
% Xhead = regressor_resample(Xhead,data.time,params);
% Xhead = regressor_zscore(Xhead); %%maybe not needed -- could happen automaticlly during regression


%% make location regressors
[Xloc Xloc_details] = make_location_regressors(data.location,params,Map);
Xloc = regressor_resample(Xloc,data.time,params);
[Xloc Xloc_details] = location_regressor_cleanup(Xloc,Xloc_details,params);
%Xloc = regressor_zscore(Xloc);

%% make BVC regressors
% [XalloB XalloB_details] = make_BVC_regressors(data.location,params,Map);
%XalloB = regressor_resample(XalloB,data.time,params);
% XalloB = regressor_zscore(XalloB);

%% make ego boundary regressors
% XegoB = make_location_regressors(data.location,data.orientation,params,Map);

%% make ego motion regressors




%% plot filters with path movie


%% save everything
%first, save params file for this subject for this particular analysis
%second, save design matrices