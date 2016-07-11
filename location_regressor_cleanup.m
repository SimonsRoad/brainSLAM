function [Xloc Xloc_details] = location_regressor_cleanup(X,X_details,params)
%cleans up location regressors to remove empty regressors, etc.

for run=1:length(X)
    
    XX = [XX X{run}];
    
end

    T = sum(XX>0);

for run=1:length(X)
    
    XX = X{run}; 
    Xd = X_details{run}; 
    Xloc{run}=XX(:,T>params.location.ntptsthresh); 
    Xloc_details{run}=Xd(T'>params.location.ntptsthresh,:); 
    
    
end

end

