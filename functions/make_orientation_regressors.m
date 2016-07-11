function X = make_orientation_regressors(data,params)
%make orientation regressors
%data = angle data from behavior
%params = param file


%% first, select bin size, and convert to radians
bins = 0:params.heading.binSize:180-params.heading.binSize;
bins = circ_ang2rad(bins);

%% for each run, filter data
for r=1:length(data) %for each run
    alpha = data{r};
    
    alpha_rad = circ_ang2rad(alpha);
    
    for b=1:length(bins) %need to loop over each bin angle
        
        [filterO junk] = circ_vmpdf(alpha_rad',bins(b),params.heading.kappa);
     
        X{r}(:,b) = filterO; 
    end
        
end

%add some figure outputs later of heading distribtions using
% circ_plot(alpha_rad,'hist',[],20,true,true,'linewidth',2,'color','r')

end

