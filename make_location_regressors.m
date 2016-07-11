function [Xloc Xloc_details] = make_location_regressors(location,params,Map)
%construct location regressors

%setup # of pyramids, and # of filters in the pyramid
pyramid = ((2.^(1:params.location.pyramidSize)).*(params.location.minSTD.*params.location.downSample))-params.location.minSTD.*params.location.downSample; %convert to pixels

%size of map
Map = imresize(Map,params.location.downSample);
map_size = size(Map);
clear Map; 

%% loop over runs and locations
for run=1:length(location)
    
    loc = location{run};
    loc = ceil(loc.*params.location.downSample); %downsample to match map;

    %set up some tickers
    filter_total = 1;
    
    %loop over pyramid layers
    for p = 1:length(pyramid)
        
        % get centers for this pyramid
        p_current = pyramid(p);
        %pyramid_totals = floor(map_size./(p_current.*params.location.stdSep));
        
        centerx = p_current:p_current*params.location.stdSep:map_size(1);
        centery = p_current:p_current*params.location.stdSep:map_size(2);
        
        %loop over centers
        for cx=1:length(centerx)
            
            for cy=1:length(centery)
                
                center = [centerx(cx) centery(cy)];
                
                mat = gauss2d(zeros(map_size), sqrt(p_current), center);
                
                locI = sub2ind(size(mat),loc(:,1),loc(:,2));
                X(:,filter_total) = mat(locI);
                X_details(filter_total,:) = [p_current center]./params.location.downSample;
                
                %end
                imagesc(mat>0); hold on; 
                scatter(loc(X(:,filter_total)>0,2),loc(X(:,filter_total)>0,1),1,'g'); drawnow
                filter_total = filter_total + 1;
                
                clear tmp; clear mat
            
            end
        end
        
   
    end
    
    Xloc{run} = X;
    Xloc_details{run} = X_details;
    clear X;
    
end




end

