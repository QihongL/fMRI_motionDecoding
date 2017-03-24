%% Solve the 8-way direction classification with cyclic regression 
clear variables; clc; close all;
seed = 1; rng(seed);    % for reproducibility
% analysis_names = {'ROIs', 'wb', 'outside'};
analysis_names = {'ROIs'};

% specify path information
DIR.ROOT = '..';
DIR.DATA = fullfile(DIR.ROOT, 'data/');
DIR.OUT = fullfile(DIR.ROOT, 'results/');
model_name = 'logistic lasso with min dev lambda';
objectives = {'2d','3d','multinomial'};
objective = objectives{3};

% parameters
NCVB = 5; % 5-folds cross validation
NCVB_internal = 4;
TEST_TRIALS = 4;
options.nlambda = 50;
options.alpha = 1;
saveResults = 1;

% CONSTANTS (should not be changed)
% SUBJ_NAMES = {'ah','br','ds','jf','rl'};
SUBJ_NAMES = {'ah','br','ds','jf'};
NTR = 16;
NRUNS = 10;

y = genCyclicLabels(NRUNS); 

for roi = 1 : length(analysis_names)
    fprintf('%s \n', analysis_names{roi})
        
    % specify parameters
    nSubjs = length(SUBJ_NAMES);
    FILENAMES = strcat(SUBJ_NAMES, {strcat('_', analysis_names{roi}, '.mat')});
    
    %% decode
    fprintf('The results will be saved to <%s>.\n', DIR.OUT);
    
    RESULTS = cell(nSubjs,1);
    % loop over subjects
    for s = 1 : nSubjs
        fprintf('Sub %d: ', s);
        load(fullfile(DIR.DATA, FILENAMES{s}));
        
        RESULTS{s}.subj_name = SUBJ_NAMES{s};
        RESULTS{s}.method = model_name;
        RESULTS{s}.objective = objective;
        RESULTS{s}.features = analysis_names{roi};
        RESULTS{s}.nLambda = options.nlambda;
        
        % preallocate
        RESULTS{s}.acc = nan(NTR,NCVB);
        RESULTS{s}.corr = nan(NTR,NCVB);
        RESULTS{s}.coef = nan(size(data.coords,1)+1,NCVB, NTR);
        % loop over TR ("time")
        for t = 1 : NTR
            fprintf('%d ', t);
            % select data for t-th time point 
            X = data.detrended{t};
            
            % loop over all CVB
            for c = 1 : NCVB
                % set up the test index
                idx_testset = false(size(X,1),1);
                idx_testset(1 : TEST_TRIALS * length(idx_testset) / 10) = true;
                % fit logistic lasso   
                results = runCyclicLS(X, y, idx_testset, 'mns');
                % save results
                RESULTS{s}.corr(t,c) = results.corr; 
                RESULTS{s}.acc(t,c) = results.acc; 
            end
        end
        fprintf('\n');
    end
    
    %% save the result file to an output dir
    if saveResults
        saveFileName = strcat('result_std_',objective,'_',analysis_names{roi});
        save(strcat(DIR.OUT,saveFileName, '.mat'), 'RESULTS')
    end
    
end
