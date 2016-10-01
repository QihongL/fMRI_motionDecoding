%% Understand the definition of ROIs
clear variables; clc; close all;

% specify path information
DIR.PROJECT = '/Users/Qihong/Dropbox/github/motionDecoding_fMRI/';
DIR.DATA = fullfile(DIR.PROJECT, 'data/');
DIR.OUT = fullfile(DIR.PROJECT, 'results/'); 

% constants
SUBJ_NAMES = {'ah','br','ds','jf','rl'};
% specify parameters
nSubjs = length(SUBJ_NAMES);

%% record ROI info
fprintf('subjID\t subjName\t numVox_ROIs\t numVox_cortex\t numVox_ROIs_unique \t ROI/cortex \n')
% loop over all subjects
for s = 1 : nSubjs
    load(fullfile(DIR.DATA, SUBJ_NAMES{s}));
    % record the number of voxels in cortex and predefined ROIs 
    numVox_cortex = length(alldat.grayinds); 
    idx_ROIs = [];  
    for r = 1 : length(alldat.ROIs) 
        idx_ROIs = horzcat(idx_ROIs, alldat.ROIs(r).ROIind);
    end
    % compute the number of voxels in the ROIs
    numVox_allROIs = length(idx_ROIs);
    numVox_ROIs_unique = length(unique(idx_ROIs));
    ratio = numVox_ROIs_unique/numVox_cortex;
    
    fprintf('%d \t %s \t\t %d \t\t %d \t\t %d \t\t\t %f \n', ...
        s, SUBJ_NAMES{s}, numVox_allROIs, numVox_cortex, numVox_ROIs_unique, ratio);
end

%% conclusion
% 1. About 35% of the voxels in the cortex are contained in some ROI 
% 2. ROIs are overlapping (about 13%)
% 3. on average, we have 7000 voxels in the cortex, the column:row ratio is
% comparable to the FPO data
