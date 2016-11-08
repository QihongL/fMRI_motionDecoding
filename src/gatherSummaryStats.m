function [accuracy_timeSeries, std_timeSeries] ...
    = gatherSummaryStats(accuracy, nSubjs, windowsize)

% exclude the 5-th subject with alignment issue 
exclude = 5; 
accuracy.mean(:,exclude) = [];
accuracy.sd(:,exclude) = [];
nSubjs = nSubjs - length(exclude);

% smoothing 
accuracy_timeSeries = accuracy.mean; 
if windowsize > 0 
    accuracy_timeSeries = movingmean(accuracy_timeSeries, windowsize); 
end
std_timeSeries = std(accuracy_timeSeries,0,2);
accuracy_timeSeries = mean(accuracy_timeSeries,2); 

end



