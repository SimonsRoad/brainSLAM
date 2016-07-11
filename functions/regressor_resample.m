function Y = regressor_resample(X,time,params)
%resample regressors to the TR by summing events within a TR

%first, resample to seconds
for r=1:length(X)
       
    t = time{r};
    for n=1:max(t);
        [junk It] = ismember(t',n);
        D(n,:) = sum(X{r}(logical(It),:));
    end
    
    X{r} = D; 
end

%sum values within a TR
for r=1:length(X)
   
    bins = 1:params.scan.tr:max(time{r});
    
    for b=1:length(bins)-1
        Y{r}(b,:) = sum(X{r}(bins(b):bins(b+1)-1,:));
    end
    
end

end

