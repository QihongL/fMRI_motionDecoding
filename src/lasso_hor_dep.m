%% Do some quick analysis for the ROKERS motion direction data
% plan: fit the model using
%   1. all voxels in the cortex
%   2. all voxels in the ROIs
%   3. all voxels outside of the ROIs (within the cortex)
clear variables; clc; close all;
% seed = 2; rng(seed); 

% specify path information
DIR.PROJECT = '/Users/Qihong/Dropbox/github/motionDecoding_fMRI/';
DIR.DATA = fullfile(DIR.PROJECT, 'data/');
DIR.OUT = fullfile(DIR.PROJECT, 'results/');

% constants
SUBJ_NAMES = {'ah','br','ds','jf','rl'};
NTR = 16; 
NCVB = 5; % 5-folds cross validation 
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
options.nlambda = 100;
nSubjs = length(SUBJ_NAMES);
FILENAMES = strcat(SUBJ_NAMES, {'_trunc.mat'});


%% 
% set up target vectors
y_train = repmat((Y_RANGE)',[NBLOCK_TRAIN,1]);
y_test = repmat((Y_RANGE)',[CVB_UNIT,1]);
y = vertcat(y_train, y_test);
% for s = 1 : nSubjs
for s = 1
    load(fullfile(DIR.DATA, FILENAMES{s}));

%     for t = 1 : NTR
    for t = 5
        
        % select either horizontal or depth data 
        X = data.detrended{t}(HOR_DEP_MASK,:);
        
        idx_cvb = randperm(NCVB);
%         for c = 1 : NCVB
        for c = 1 
            % set up the test index 
            idx_testset = false(size(X,1),1);
            idx_testset(NBLOCK_TRAIN * (idx_cvb(c)-1) + (1:NBLOCK_TRAIN)) = true;
            
            options.alpha = 1; % 1 == lasso, 0 == ridge
            results = runLasso(X, y, idx_testset, options);
%             % hold out test set
%             X_train = X(~idx_testset, : );
%             X_test = X(idx_testset, : );
%             cvfit = cvglmnet(X_train, y_train, 'binomial', options);
            

            
        end
    end
    
    
end
% 
% 
% %% start the mvpa analysis
% results = cell(numSubjs,1);
% % loop over subjects
% for i = 1 : numSubjs
%     s = subjIDs(i);
%     fprintf('Subj%.2d: ', s);
%     
%     % preallocate: results{i} for the ith subject
%     results{i}.subjID = s;
%     results{i}.dataType = DATA_TYPE;
%     results{i}.lasso.accuracy.onese = nan(numCVB,1);
%     results{i}.lasso.accuracy.min = nan(numCVB,1);
%     results{i}.ridge.accuracy.onese = nan(numCVB,1);
%     results{i}.ridge.accuracy.min = nan(numCVB,1);
%     
%     % load the data
%     load(strcat(DIR.DATA,filename.metadata))
%     load(strcat(DIR.DATA,filename.data{i}))
%     y = metadata(s).targets(1).target;  % target 1 = label
%     [M,N] = size(X);
%     % read data parameters
%     cvidx = metadata(s).cvind(:,CVCOL);
%     
%     % loop over CV blocks
%     for c = 1: numCVB
%         fprintf('%d ', c);
%         % choose a cv index
%         testIdx = cvidx == c;
%         % hold out the test set
%         X_train = X(~testIdx,:);
%         X_test = X(testIdx,:);
%         y_train = y(~testIdx);
%         y_test = y(testIdx);
%         
%         % fit lasso
%         options.alpha = 1; % 1 == lasso, 0 == ridge
%         cvfit = cvglmnet(X_train, y_train, 'binomial', options);
%         results{i}.lasso.coef_1se{c} = cvglmnetCoef(cvfit, 'lambda_1se');
%         results{i}.lasso.lambda_1se(c) = cvfit.lambda_1se;
%         results{i}.lasso.coef_min{c} = cvglmnetCoef(cvfit, 'lambda_min');
%         results{i}.lasso.lambda_min(c) = cvfit.lambda_min;
%         
%         % compute the performance
%         y_hat = myStepFunction(cvglmnetPredict(cvfit, X_test,cvfit.lambda_1se));
%         results{i}.lasso.accuracy.onese(c) = sum(y_hat == y_test) / length(y_test);
%         y_hat = myStepFunction(cvglmnetPredict(cvfit, X_test,cvfit.lambda_min));
%         results{i}.lasso.accuracy.min(c) = sum(y_hat == y_test) / length(y_test);
%         
%         % fit ridge
%         options.alpha = 0; % 1 == lasso, 0 == ridge
%         cvfit = cvglmnet(X_train, y_train, 'binomial', options);
%         results{i}.ridge.coef_1se{c} = cvglmnetCoef(cvfit, 'lambda_1se');
%         results{i}.ridge.lambda_1se(c) = cvfit.lambda_1se;
%         results{i}.ridge.coef_min{c} = cvglmnetCoef(cvfit, 'lambda_min');
%         results{i}.ridge.lambda_min(c) = cvfit.lambda_min;
%         
%         % compute the performance
%         y_hat = myStepFunction(cvglmnetPredict(cvfit, X_test,cvfit.lambda_1se));
%         results{i}.ridge.accuracy.onese(c) = sum(y_hat == y_test) / length(y_test);
%         y_hat = myStepFunction(cvglmnetPredict(cvfit, X_test,cvfit.lambda_min));
%         results{i}.ridge.accuracy.min(c) = sum(y_hat == y_test) / length(y_test);
%         
%     end
%     fprintf('\n');
% end
% % save the data
% saveFileName = sprintf( strcat('newresults_', DATA_TYPE,'_bc',BOXCAR, ...
%     '_wStart',WIND_START, 'wSize', WIND_SIZE, '.mat'));
% 
% save(strcat(DIR.OUT,saveFileName), 'results')
