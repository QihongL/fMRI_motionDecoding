%% Do some quick analysis for the ROKERS motion direction data
% plan: fit the model using
%   1. all voxels in the cortex
%   2. all voxels in the ROIs
%   3. all voxels outside of the ROIs (within the cortex)
clear variables; clc; close all;
seed = 1; rng(seed);    % for reproducibility

analysis_names = {};
analysis_names = {'ROIs', 'outside', 'wb'};

% for roi = 13 : 20
%     analysis_names{length(analysis_names)+1} = sprintf('ROI%.2d',roi);
% end

% specify path information
DIR.ROOT = '..';
DIR.DATA = fullfile(DIR.ROOT, 'data/');
DIR.OUT = fullfile(DIR.ROOT, 'results/');
model_name = 'logistic lasso with min dev lambda';
objectives = {'2d','3d','multinomial'};
objective = objectives{1};
iterlasso = 0

% parameters
NCVB = 5; % 5-folds cross validation
NCVB_internal = 4;
TEST_TRIALS = 4;
options.nlambda = 50;
options.alpha = 1;
saveResults = 0;

% CONSTANTS (should not be changed)
SUBJ_NAMES = {'ah','br','ds','jf','rl'};
NTR = 16;
NRUNS = 10;

% set up target vectors
[y, ROW_MASK, unit_mask] = getMaskAndRange(objective, NRUNS);

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
        RESULTS{s}.accuracy = nan(NTR,NCVB);
        RESULTS{s}.lambda_min = nan(NTR,NCVB);
        RESULTS{s}.coef = nan(size(data.coords,1)+1,NCVB, NTR);
        % loop over TR ("time")
        if iterlasso
            RESULTS{s}.result = cell(NTR,1); 
        end
         for t = 1 : NTR
            fprintf('%d ', t);
            % select horizontal-depth data
            X = data.detrended{t}(~ROW_MASK,:);
            
            if iterlasso
                nPossibleLabels = 6; 
                options.alpha = 1; 
                options.nLambda = 50;
                chance = .5; 
                cv_idx = reshape(repmat([1:NCVB],nPossibleLabels * (NRUNS/NCVB),1),NCVB * nPossibleLabels * (NRUNS/NCVB),1);
                RESULTS{s}.result{t} = runIterLasso(X,y,cv_idx,options,NCVB_internal,chance);
            else
                % decode for all CVB
                for c = 1 : NCVB
                    % set up the test index
                    idx_testset = false(size(X,1),1);
                    idx_testset(1 : (TEST_TRIALS * sum(~unit_mask))) = true;
                    
                    % fit logistic lasso
                    results = runLassoGlm(X, y, idx_testset, options, NCVB_internal, 'glmnet');
                    % record the results
                    RESULTS{s}.accuracy(t,c) = results.lasso_accuracy_lambda_min;
                    RESULTS{s}.lambda_min(t,c) = results.lasso_lambda_min;
                    RESULTS{s}.coef(:,c,t) = results.lasso_coef_lambda_min;
                end
            end
        end
        fprintf('\n');
    end
    
    %% save the result file to an output dir
    if saveResults
        saveFileName = strcat('result_ilasso_',objective,'_',analysis_names{roi});
        save(strcat(DIR.OUT,saveFileName, '.mat'), 'RESULTS')
    end
    
end
