function [location angle time] = getBSLAM_behavior_data(filename,params)
%read in location and angle data

%sampling rate for locations
sampling_rate = params.acq.sampling_rate; %in msec

%location of data
dataDIR = params.acq.BehavioralDataDir ; 

fid = fopen([dataDIR '/' filename]);

%turn data into a gigantic cell array
lineind = 1;
while 1
    
    tline = fgetl(fid);
    if ~ischar(tline)
        break;
    else
        data{lineind}=tline;
        lineind = lineind+1;
    end
end

fclose(fid);


%read in data
tick=1;
tp_old = 0;
tp = 0;

for i=1:length(data)
    
    line = data{i};
    
    if ~strcmp(line(24),'U') %for unknown command
        
        %store tps in seconds
        tp_curr = str2num(line(20:21)); %current second 
        if tp_curr==tp_old
            
            time(tick)=time(tick-1);     
        
        else
            tp = tp + 1;
            time(tick)=tp;
            
        end
        tp_old = tp_curr;     
        
        
        %get location and angle
        subject_location = sscanf(line(24:end),'setpos %f %f %f ;setang %f %f %f');
        location(tick,:) = subject_location(1:2);
        angle(tick) = subject_location(5);
        
        %increment ticker
        tick = tick + 1;
    end
    
end

%convert angle to 0-360
IDX = angle < 0;
angle(IDX) = angle(IDX) + 360;


end

