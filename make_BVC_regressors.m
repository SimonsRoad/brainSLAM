function [XalloB XalloB_details] = make_BVC_regressors(location,params,map)
%x = make_bvc_regressors(location data, parameters, boundary map)
%filters input locations with bvcs to construct bvc regressors

%% initial parameters
map_size = size(map);
n2sample = params.AlloBorder.n2sample; %number of directions to sample prior to filtering

%% get index of map boundaries at each of several directions
step_size = 360/n2sample;
angles= circ_ang2rad(0:step_size:360-step_size);
[x_vals y_vals] = pol2cart(angles',repmat(2500,n2sample,1)); %2500 is number of pixels away to look from center, just keep large

lpts = cell(length(angles),1);
for a=1:length(angles); lpts{a} = linepts([0 0], [x_vals(a), y_vals(a)]); end

%setup filter bank distances -- need to not hardcode
if params.AlloBorder.nearBias;
    near_total = round((params.AlloBorder.ndistances)/2);
    PrefRadial = [1:16:near_total*16 near_total*16*2:near_total*16*2:near_total*16*2*near_total];
else
    PrefRadial = 1:16*params.AlloBorder.ndistances:16*params.AlloBorder.ndistances^2;
end

%% loop over runs and locations
for run=1:length(location)
    
    loc = location{run};
    
    %first compute distance to boundary at each of n direction for each
    %location ll
    for ll=1:length(loc)
        
        %reset lpts to location & correct for lpts going over map size
        for a=1:n2sample
            tmp = lpts{a}+repmat(loc(ll,:),length(lpts{a}(:,1)),1);
            tmp(logical(tmp <= 0))=NaN;
            tmp(logical(tmp(:,1) > map_size(1)),1)=NaN;
            tmp(logical(tmp(:,2) > map_size(2)),2)=NaN;
            I = sum(isnan(tmp),2)>0;
            blocs = sub2ind(map_size,tmp(~I,1),tmp(~I,2));
            Xlpts{a} = blocs;
        end
        
        %find first boundary distance at each location & store boundary
        %distances at each location
        for a=1:n2sample
            boundaries = map(Xlpts{a});
            tmp = find(boundaries==1);
            if isempty(tmp); b_dis(ll,a)=NaN;
            else b_dis(ll,a) = tmp(1);
            end
        end
        
        
    end
    
    %% filter distance with bvc model
    
    %get angular constants for each direction
    step_size = 360/params.AlloBorder.nangles;
    PrefAngles= circ_ang2rad(0:step_size:360-step_size);
    
    for a=1:length(PrefAngles)
        
        [filterO junk] = circ_vmpdf(angles,PrefAngles(a),params.heading.kappa);
        Theta{a} = filterO';
        
    end
    
    %filter different preferred distances
    for d=1:length(PrefRadial)
        
        radial_difference = b_dis - repmat(PrefRadial(d),size(b_dis));
        radial_dev = repmat(params.AlloBorder.SDang,size(b_dis)) + b_dis;
        Radial{d} = exp(-(radial_difference.^2)./(2*radial_dev))./sqrt(2*pi.*(radial_dev));
        
    end
    
    %integrate over all angles
    ticker = 1;
    for d=1:length(PrefRadial)
        for a=1:length(PrefAngles)
            
            
            X(:,ticker) = nansum(Radial{d}.*repmat(Theta{a},length(Radial{d}),1),2);
            ticker = ticker + 1;
            XalloB_details(:,ticker) = [PrefRadial(d);PrefAngles(a)];  %%need to add this thing to collect formatting info for the design mat
            
        end
    end
    
    XalloB{run} = X;
    clear X;

end

end


