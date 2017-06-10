%% Do some quick analysis for the ROKERS motion direction data
% plan: fit the model using
%   1. all voxels in the cortex
%   2. all voxels in the ROIs
%   3. all voxels outside of the ROIs (within the cortex)
clear variables; clc;
fh=findall(0,'type','figure');
for i=1:length(fh)
    clo(fh(i));
end
% specify path information
DIR.ROOT = '..';
DIR.OUT = fullfile(DIR.ROOT, 'results/');
% CONSTANTS (should not be changed)
SUBJ_NAMES = {'ah','br','ds','jf','rl'};
NTR = 16;
NSUBJ = length(SUBJ_NAMES);
CHANCE = .5;
NCVB = 5;   % 5-folds cross validation
NCVB_internal = 4;

%% select data
filestem = 'result_std';
objective = '2d';
showErrBar = 1;
windowSize = 0;
plotByCondition = 0;

numROIs = 20;
idx_deletedROI = 12;
sim_conditions = {'wb','ROIs','outside'};
sim_conditions = {'outside'};
for roi = 1 
    sim_condition = sprintf('ROI%.2d',roi);
    sim_conditions{length(sim_conditions)+1} = sim_condition;
end
% sim_conditions(idx_deletedROI + 2) =[];

%% read result file
numConditions = length(sim_conditions);
perf = cell(length(sim_conditions),1);
for i = 1 : numConditions
    % load result files
    result_filename = strcat(filestem, '_', objective ,'_', sim_conditions{i});
    load(fullfile(DIR.OUT, strcat(result_filename, '.mat')))
    % read out accuracy from the results
    perf{i} = readResults(RESULTS, NTR, NSUBJ);
    perf{i}.conditionName = result_filename;
end

%% plot the accuracy
p.FS = 14;
p.LW = 2;
alpha = .05;
% sim_conditions(2+1:length(sim_conditions)) = labelROInames(numROIs, idx_deletedROI);

%% plot mean accuracy (averaged across all subjects) over TRs

if ~plotByCondition
    figure(1)
    hold on
end
meanAccAcrossConditions = nan(NTR, length(sim_conditions));
meanStdAcrossConditions = nan(NTR, length(sim_conditions));
for i = 1 : numConditions
    analysis_name = strrep(perf{i}.conditionName, '_', ' ');
    [meanAccAcrossConditions(:,i), meanStdAcrossConditions(:,i)] ...
        = gatherSummaryStats(perf{i}.accuracy, NSUBJ, windowSize);
    
    % plot
    if plotByCondition
        figure('Visible','off')
    end
    if showErrBar
        % SE over subjects
        se = tinv(1 - alpha/2, NSUBJ-1) * meanStdAcrossConditions(:,i) / sqrt(NCVB);
        % plot with error bar
        errorbar(1:NTR, meanAccAcrossConditions(:,i), se, 'linewidth', p.LW);
    end
    if plotByCondition
        hline = refline(0,CHANCE);
        hline.Color = 'k';
        title_text = sprintf('Decode %s - Mean Accuracy across %d subjects\n movingAverage window size = %d', ...
            objective, NSUBJ-1, windowSize);
        title(title_text, 'fontsize', p.FS)
        legend(sim_conditions{i}, 'location', 'best')
        ylabel('Mean accuracy', 'fontsize', p.FS)
        xlabel('TR', 'fontsize', p.FS)
        xlim([1 NTR])
        picname = sprintf('../plots/3d_sub_roi/im%.2d_%s_avg.png', i,sim_conditions{i});
        saveas(gcf,picname,'png')
    end
    
end

if ~ showErrBar && ~ ~plotByCondition
    P = plot(1:NTR, meanAccAcrossConditions, 'linewidth', p.LW);
    set(P, {'color'}, num2cell(jet(length(sim_conditions)), 2));
end
if ~plotByCondition
    hold off

    hline = refline(0,CHANCE);
    hline.Color = 'k';
    title_text = sprintf('Decode %s - Mean Accuracy across %d subjects\n movingAverage window size = %d', ...
        objective, NSUBJ-1, windowSize);
    title(title_text, 'fontsize', p.FS)
    legend(sim_conditions, 'fontsize', p.FS, 'location', 'EastOutside')
    ylabel('Mean accuracy', 'fontsize', p.FS)
    xlabel('TR', 'fontsize', p.FS)
    xlim([1 NTR])
end

%% plot accuracy (averaged across CVBs) over TRs, for each subject separately

for i = 1 : length(sim_conditions)
%     figure(i + 10)
    figure('Visible','off')

    plotAccuracy_individual(perf(i), NSUBJ, NCVB, NTR, ...
        SUBJ_NAMES, sim_conditions(i), CHANCE, alpha, p, windowSize, showErrBar)
    suptitle_text = sprintf('Decode %s - Mean Accuracy across CV blocks\n movingAverage window size = %d', ...
        objective, windowSize);
    suptitle(suptitle_text)

    picname = sprintf('../plots/3d_sub_roi/im%.2d_%s.png', i,sim_conditions{i});
    saveas(gcf,picname,'png')
end