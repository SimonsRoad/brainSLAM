function loc_out = filter_location_data(loc_in, params,scale_factor)
%filters the location data to remove large jumps from Hammer?
%also include smoothing of path?

%% 1. calculate distance traveled between each time point
distance_traveled = sqrt((loc_in(2:end,1)-loc_in(1:end-1,1)).^2+(loc_in(2:end,2)-loc_in(1:end-1,2)).^2);    

%% 2. clear out-of-tracking jumps
dis_filter = find(distance_traveled>params.loc.dis_thresh); 
dis_filter = dis_filter(2:2:length(dis_filter)); %every other jump is what we want to cut

%set jumps to NaNs 
loc_in(dis_filter,:) = NaN;

%% 3. need to flip the x and y in the location data to match the map, and
%% scale
loc_in = round((-1.*repmat(scale_factor,length(loc_in),1)+ones(length(loc_in),2))+loc_in);
loc_in = [loc_in(:,2) loc_in(:,1)]; 

loc_out = loc_in;

end

