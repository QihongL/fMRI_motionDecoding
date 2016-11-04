function plotAccuracy_individual(performance, nSubjs, NCVB, NTR, SUBJ_NAMES, ...
    sim_conditions, chance, alpha, p, showErrBar)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
for s = 1 : nSubjs
    subplot(2, ceil(nSubjs/2), s)
    for i = 1 : length(performance)
        accuracy = performance{i}.accuracy;
        hold on
        % SE over CV blocks
        if showErrBar
            se = tinv(1 - alpha/2, nSubjs-1) * accuracy.sd(:,s) / sqrt(NCVB);
            errorbar(1:NTR, accuracy.mean(:,s), se, 'linewidth', p.LW);
        else
            plot(1:NTR, accuracy.mean(:,s), 'linewidth', p.LW);
        end
        hold off
        
    end
    
    hline = refline(0,chance);
    hline.Color = 'k';
    
    title_text = sprintf('Subject: %s ', SUBJ_NAMES{s});
    title(title_text, 'fontsize', p.FS)
    
    ylabel('Mean CV accuracy', 'fontsize', p.FS)
    xlabel('TR', 'fontsize', p.FS)
    ylim([.2 1])
    xlim([1 NTR])
    
    if s == nSubjs
        legend(sim_conditions, 'fontsize', p.FS, 'location', 'best')
    end
end


end

