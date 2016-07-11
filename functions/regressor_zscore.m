function Y = regressor_zscore(X)
%zscores and filters all regressors in a cell array of regressors

Y = cellfun(@zscore_regressor,X,'UniformOutput',0);


end

function OUT = zscore_regressor(IN)

meanIN = mean(IN);
stdIN = std(IN);
sIN = size(IN);
OUT = (IN-repmat(meanIN,sIN(1),1))./repmat(stdIN,sIN(1),1);

%%truncate very high values to improve stability
%OUT(OUT>3.5)=3.5;

%%truncate low values
%OUT(OUT<-3.5)=-3.5;

end
