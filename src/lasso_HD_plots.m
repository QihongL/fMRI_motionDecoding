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
objective = '3d';
showErrBar = 1;
windowsize = 0;

numROIs = 2;
sim_conditions = {'wb','ROIs'};
% sim_conditions = {'ROI16'};
for roi = 1 : numROIs
    sim_condition = sprintf('ROI%.2d',roi);
    sim_conditions{roi+2} = sim_condition;
end

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
sim_conditions = labelROInames(sim_conditions);

% plot mean accuracy (averaged across all subjects) over TRs
figure(1)
hold on
meanAccAcrossConditions = nan(NTR, length(sim_conditions));
meanStdAcrossConditions = nan(NTR, length(sim_conditions));
for i = 1 : numConditions
    analysis_name = strrep(perf{i}.conditionName, '_', ' ');
    [meanAccAcrossConditions(:,i), meanStdAcrossConditions(:,i)] ...
        = gatherSummaryStats(perf{i}.accuracy, NSUBJ, windowsize);
    
    % plot
    if showErrBar
        % SE over subjects
        se = tinv(1 - alpha/2, NSUBJ-1) * meanStdAcrossConditions(:,i) / sqrt(NCVB);
        % plot with error bar
        errorbar(1:NTR, meanAccAcrossConditions(:,i), se, 'linewidth', p.LW);
    end
end
if ~ showErrBar
    plot(1:NTR, meanAccAcrossConditions, 'linewidth', p.LW);
end

hold off
hline = refline(0,CHANCE);
hline.Color = 'k';
title_text = sprintf('Decode %s - Mean Accuracy across %d subjects\n movingAverage window size = %d', ...
    objective, NSUBJ-1, windowsize);
title(title_text, 'fontsize', p.FS)
legend(sim_conditions, 'fontsize', p.FS, 'location', 'EastOutside')
ylabel('Mean accuracy', 'fontsize', p.FS)
xlabel('TR', 'fontsize', p.FS)
xlim([1 NTR])


% plot accuracy (averaged across CVBs) over TRs, for each subject separately
figure(2)
plotAccuracy_individual(perf, NSUBJ, NCVB, NTR, ...
    SUBJ_NAMES, sim_conditions, CHANCE, alpha, p, windowsize, showErrBar)
suptitle_text = sprintf('Decode %s - Mean Accuracy across CV blocks\n movingAverage window size = %d', ...
    objective, windowsize);
suptitle(suptitle_text)