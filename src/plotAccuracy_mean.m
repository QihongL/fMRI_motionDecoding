function plotAccuracy_mean(accuracy, nSubjs, NCVB, NTR, alpha, p, windowsize, showErrBar)

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

% plot 
if showErrBar
    % SE over subjects
    se = tinv(1 - alpha/2, nSubjs-1) * std(accuracy.mean,0,2) / sqrt(NCVB);
    % plot with error bar
    errorbar(1:NTR, mean(accuracy_timeSeries,2),se, 'linewidth', p.LW);
else
    plot(1:NTR, mean(accuracy_timeSeries,2), 'linewidth', p.LW);
end


end



