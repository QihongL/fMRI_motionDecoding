clear variables;
analysis_names = {'ROI01', 'wb'};

% specify path information
DIR.ROOT = '..';
DIR.DATA = fullfile(DIR.ROOT, 'demo_data/');
DIR.OUT = fullfile(DIR.ROOT, 'results/');
decodingObjective = '2d';

% parameters
NCVB = 5; % 5-folds cross validation
TEST_TRIALS = 4;
options.nlambda = 100;
options.alpha = 1;
SUBJ_NAMES = {'ah'};
NTR = 16;
NRUNS = 10;

% set up target vectors
[y, ROW_MASK, unit_mask] = getMaskAndRange(decodingObjective, NRUNS);

for roi = 1
    % specify parameters
    nSubjs = length(SUBJ_NAMES);
    FILENAMES = strcat(SUBJ_NAMES, {strcat('_', analysis_names{roi}, '.mat')});
    load(fullfile(DIR.DATA, FILENAMES{1}));
    
    % loop over TR ("time")
    for t = 5
        % select horizontal-depth data
        X = data.detrended{t}(~ROW_MASK,:);
        
        % set up the test index
        idx_testset = false(size(X,1),1);
        idx_testset(1 : (TEST_TRIALS * sum(~unit_mask))) = true;
        
        % fit logistic lasso
        % YOUR CODE HERE!
        %% hold out the test set

        
    end
end