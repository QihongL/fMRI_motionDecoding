%% Do some quick analysis for the ROKERS motion direction data
% plan: fit the model using
%   1. all voxels in the cortex
%   2. all voxels in the ROIs
%   3. all voxels outside of the ROIs (within the cortex)
clear variables; clc; close all;
seed = 1; rng(seed);    % for reproducibility 
analysis_name = 'ROIs'; 


% specify path information
DIR.PROJECT = '/Users/Qihong/Dropbox/github/motionDecoding_fMRI/';
DIR.DATA = fullfile(DIR.PROJECT, 'data/');
DIR.OUT = fullfile(DIR.PROJECT, 'results/');
% parameters 
NCVB = 5; % 5-folds cross validation
NCVB_internal = 4; 
options.nlambda = 50;
saveResults = 1; 

% CONSTANTS (should not be changed)
SUBJ_NAMES = {'ah','br','ds','jf','rl'};
NTR = 16;
NRUNS = 10;
CVB_UNIT = NRUNS/NCVB;
NBLOCK_TRAIN = CVB_UNIT * (NCVB-1);

% the stimulus classes are a circular domain: 0 is rightward motion, pi is
% leftward motion, pi/2 is 'away' motion, 3*pi/2 is 'towards' motion
% Y_RANGE = [1 2 3 4 5 6 7 8];
% Y_LABELS = 0: pi/4 : (2*pi - pi/4);
HOR_DEP_MASK = repmat(logical([1 0 1 0 1 0 1 0])', [NRUNS,1]);
Y_RANGE = [0 1 0 1];
Y_LABELS = 0: pi/2 : (2*pi - pi/4);

% specify parameters
nSubjs = length(SUBJ_NAMES);
FILENAMES = strcat(SUBJ_NAMES, {strcat('_', analysis_name, '.mat')});


%% decode 
fprintf('The results will be saved to <%s>.\n', DIR.OUT);

% set up target vectors
y = repmat((Y_RANGE)',[NRUNS,1]);
RESULTS = cell(nSubjs,1);
% loop over subjects
for s = 1 : nSubjs
    fprintf('Sub %d: ', s);
    load(fullfile(DIR.DATA, FILENAMES{s}));
    
    RESULTS{s}.subj_name = SUBJ_NAMES{s};
    RESULTS{s}.title = 'logistic lasso with min dev lambda'; 
    RESULTS{s}.nLambda = options.nlambda; 
    
    % preallocate
    RESULTS{s}.accuracy = nan(NTR,NCVB);
    RESULTS{s}.lambda_min = nan(NTR,NCVB);
    RESULTS{s}.coef = nan(size(data.coords,1)+1,NCVB, NTR);
    % loop over TR ("time")
    for t = 1 : NTR
        fprintf('%d ', t);
        
        % select horizontal-depth data 
        X = data.detrended{t}(HOR_DEP_MASK,:);
        
        idx_cvb = randperm(NCVB);
        % decode for all CVB
        for c = 1 : NCVB
            % set up the test index
            idx_testset = false(size(X,1),1);
            idx_testset(NBLOCK_TRAIN * (idx_cvb(c)-1) + (1:NBLOCK_TRAIN)) = true;
            % fit logistic lasso 
            results = runLassoGlm(X, y, idx_testset, options, NCVB_internal);
            % record the results
            RESULTS{s}.accuracy(t,c) = results.lasso_accuracy_lambda_min;
            RESULTS{s}.lambda_min(t,c) = results.lasso_lambda_min;
            RESULTS{s}.coef(:,c,t) = results.lasso_coef_lambda_min;
        end
    end
    fprintf('\n');
end

%% save the result file to an output dir
if saveResults
    saveFileName = strcat('result_HD_',analysis_name);
    save(strcat(DIR.OUT,saveFileName, '.mat'), 'RESULTS')
end
