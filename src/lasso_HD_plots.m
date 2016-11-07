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
windowsize = 0; 
objective = '3d'; 
numROIs = 7; 
sim_conditions = {'wb','ROIs'};
for roi = 1 : numROIs
    sim_condition = sprintf('ROI%.2d',roi); 
    sim_conditions{roi+2} = sim_condition; 
end


%% read result file
numConditions = length(sim_conditions);
perf = cell(length(sim_conditions),1);
for i = 1 : numConditions
    result_filename = strcat('result_', objective ,'_', sim_conditions{i});
    load(fullfile(DIR.OUT, strcat(result_filename, '.mat')))
    perf{i} = readResults(RESULTS, NTR, nSubjs);
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
for i = 1 : numConditions
    analysis_name = strrep(perf{i}.conditionName, '_', ' ');
    plotAccuracy_mean(perf{i}.accuracy, nSubjs, NCVB, NTR, alpha, p, windowsize, 0)
end
hold off
hline = refline(0,chance);
hline.Color = 'k';
title_text = sprintf('Decode %s - Mean Accuracy across %d subjects\n movingAverage window size = %d', ...
    objective, nSubjs-1, windowsize);
title(title_text, 'fontsize', p.FS)
legend(sim_conditions, 'fontsize', p.FS, 'location', 'best')
ylabel('Mean accuracy', 'fontsize', p.FS)
xlabel('TR', 'fontsize', p.FS)
xlim([1 NTR])


% plot accuracy (averaged across CVBs) over TRs, for each subject separately
figure(2)
plotAccuracy_individual(perf, nSubjs, NCVB, NTR, ...
    SUBJ_NAMES, sim_conditions, chance, alpha, p, windowsize, 0)
suptitle_text = sprintf('Decode %s - Mean Accuracy across CV blocks\n movingAverage window size = %d', ...
    objective, windowsize);
suptitle(suptitle_text)