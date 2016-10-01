clear variables; clc; close all;

% specify path information
DIR.PROJECT = '/Users/Qihong/Dropbox/github/motionDecoding_fMRI/';
DIR.DATA = fullfile(DIR.PROJECT, 'data/');
DIR.OUT = fullfile(DIR.PROJECT, 'results/'); 

% constants
SUBJ_NAMES = {'ah','br','ds','jf','rl'};
TR = 5; %use data at this TR to do classification
% the stimulus classes are a circular domain: 0 is rightward motion, pi is
% leftward motion, pi/2 is 'away' motion, 3*pi/2 is 'towards' motion
Y_RANGE = [1 2 3 4 5 6 7 8];
Y_LABELS = 0:pi/4:(2*pi - pi/4);

% specify parameters
numCVB = 8;
options.nlambda = 100;
nSubjs = length(SUBJ_NAMES);

%%
fprintf('subjID\t subjName\t numVox_ROIs\t numVox_cortex\t ROI/cortex \t numVox_ROIs_unique\n')
for s = 1 : nSubjs
    load(fullfile(DIR.DATA, SUBJ_NAMES{s}));
    % record the number of voxels in cortex and predefined ROIs 
    numVox_cortex = length(alldat.grayinds); 
    numVox_allROIs = 0; 
    idx_ROIs = [];  
    for r = 1 : length(alldat.ROIs) 
        idx_ROIs = horzcat(idx_ROIs, alldat.ROIs(r).ROIind);
        numVox_allROIs = numVox_allROIs + length(alldat.ROIs(r).ROIind);
    end
    ratio = numVox_allROIs/numVox_cortex;
    nonVox_ROIs_unique = length(unique(idx_ROIs));
    fprintf('%d \t %s \t\t %d \t\t %d \t\t %f \t\t %d \n', ...
        s, SUBJ_NAMES{s}, numVox_allROIs, numVox_cortex, ratio, nonVox_ROIs_unique);
end

%% conclusion
% 1. 40% of the voxels in the cortex are contained in some ROI 
% 2. ROIs are overlapping (about 13%)
% 3. on average, we have 7000 voxels in the cortex
