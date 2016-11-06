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
DIR.PROJECT = '/Users/Qihong/Dropbox/github/motionDecoding_fMRI/';
DIR.OUT = fullfile(DIR.PROJECT, 'results/');
% CONSTANTS (should not be changed)
SUBJ_NAMES = {'ah','br','ds','jf','rl'};
NTR = 16;
nSubjs = length(SUBJ_NAMES);
chance = .5;
% parameters
NCVB = 5; % 5-folds cross validation
NCVB_internal = 4;

%% select data
numROIs = 20; 
sim_conditions = cell(numROIs,1);
for roi = 1 : numROIs
    sim_condition = sprintf('ROI%.2d',roi); 
    sim_conditions{roi} = sim_condition; 
end
sim_conditions{numROIs+1,1} = 'ROIs';
sim_conditions{numROIs+2,1} = 'wb';
% sim_conditions = {'v1', 'ROIs', 'wb'};
% sim_conditions = {'wb'};


%% read result file
numConditions = length(sim_conditions);
perf = cell(3,1);
for i = 1 : numConditions
    result_filename = strcat('result_HD_', sim_conditions{i});
    load(fullfile(DIR.OUT, strcat(result_filename, '.mat')))
    perf{i} = readResults(RESULTS, NTR, nSubjs);
    perf{i}.conditionName = result_filename;
end

%% plot the accuracy
p.FS = 14;
p.LW = 2;
alpha = .05;

% plot mean accuracy (averaged across all subjects) over TRs
figure(1)
hold on
for i = 1 : numConditions
    analysis_name = strrep(perf{i}.conditionName, '_', ' ');
    plotAccuracy_mean(perf{i}.accuracy, nSubjs, NCVB, NTR, alpha, p, 0)
end
hold off
hline = refline(0,chance);
hline.Color = 'k';
title_text = sprintf('Mean Accuracy: %d subjects', nSubjs);
title(title_text, 'fontsize', p.FS)
legend(sim_conditions, 'fontsize', p.FS, 'location', 'best')
ylabel('Mean CV accuracy', 'fontsize', p.FS)
xlabel('TR', 'fontsize', p.FS)
xlim([1 NTR])

% plot accuracy (averaged across CVBs) over TRs, for each subject separately
figure(2)
plotAccuracy_individual(perf, nSubjs, NCVB, NTR, ...
    SUBJ_NAMES, sim_conditions, chance, alpha, p, 0)


