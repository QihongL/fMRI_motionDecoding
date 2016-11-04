%% Do some quick analysis for the ROKERS motion direction data
% plan: fit the model using
%   1. all voxels in the cortex
%   2. all voxels in the ROIs
%   3. all voxels outside of the ROIs (within the cortex)
clear variables; clc; clf; 

result_file_name = 'result_HD_ROIs';
chance = .5; 

% specify path information
DIR.PROJECT = '/Users/Qihong/Dropbox/github/motionDecoding_fMRI/';
DIR.OUT = fullfile(DIR.PROJECT, 'results/');
% parameters 
NCVB = 5; % 5-folds cross validation
NCVB_internal = 4; 

% CONSTANTS (should not be changed)
SUBJ_NAMES = {'ah','br','ds','jf','rl'};
NTR = 16;
NRUNS = 10;
CVB_UNIT = NRUNS/NCVB;
NBLOCK_TRAIN = CVB_UNIT * (NCVB-1);
nSubjs = length(SUBJ_NAMES);

%% read result file 
load(fullfile(DIR.OUT, strcat(result_file_name, '.mat')))

% gather accuracy
accuracy.mean = nan(NTR,nSubjs);
accuracy.sd = nan(NTR,nSubjs);
for s = 1 : nSubjs
    for t = 1 : NTR
        % compute the mean and std for the accuracy
        accuracy.mean(t,s) = mean(RESULTS{s}.accuracy(t,:));
        accuracy.sd(t,s) = std(RESULTS{s}.accuracy(t,:),0); 
    end
end

%% plot the accuracy
p.FS = 14;
p.LW = 2;
alpha = .05; 
analysis_name = strrep(result_file_name, '_', ' ');

% plot accuracy (averaged across all subjects) over TRs
figure(1)
% SE over subjects
se = tinv(1 - alpha/2, nSubjs-1) * std(accuracy.mean,0,2) / sqrt(NCVB);
errorbar(1:NTR, mean(accuracy.mean,2),se, 'linewidth', p.LW);
hline = refline(0,chance);
hline.Color = 'k';
title_text = sprintf('Mean Accuracy: %d subjects - %s', nSubjs, analysis_name);
title(title_text, 'fontsize', p.FS)
legend({'mean accuracy', 'chance'}, 'fontsize', p.FS, 'location', 'SE')
ylabel('Mean CV accuracy', 'fontsize', p.FS)
xlabel('TR', 'fontsize', p.FS)
xlim([1 NTR])


% plot accuracy (averaged across CVBs) over TRs, for each subject separately 
figure(2)
for s = 1 : nSubjs
    subplot(2, ceil(nSubjs/2), s)
    % SE over CV blocks
    se = tinv(1 - alpha/2, nSubjs-1) * accuracy.sd(:,s) / sqrt(NCVB);
    errorbar(1:NTR, accuracy.mean(:,s), se, 'linewidth', p.LW);
    title_text = sprintf('Subject: %s ', SUBJ_NAMES{s});
    title(title_text, 'fontsize', p.FS)
    hline = refline(0,chance);
    hline.Color = 'k';
    ylabel('Mean CV accuracy', 'fontsize', p.FS)
    xlabel('TR', 'fontsize', p.FS)
    ylim([0 1])
    xlim([1 NTR])
end
legend({'mean accuracy', 'chance'}, 'fontsize', p.FS, 'location', 'SE')
suptitle(analysis_name)
