function plotAccuracy_mean(accuracy, nSubjs, NCVB, NTR, alpha, p, showErrBar)

if showErrBar
    % SE over subjects
    se = tinv(1 - alpha/2, nSubjs-1) * std(accuracy.mean,0,2) / sqrt(NCVB);
    % plot with error bar
    errorbar(1:NTR, mean(accuracy.mean,2),se, 'linewidth', p.LW);
else
    plot(1:NTR, mean(accuracy.mean,2), 'linewidth', p.LW);
end


end



