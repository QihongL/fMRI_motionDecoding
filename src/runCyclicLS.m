function [ results ] = runCyclicLS( X, y, idx_testset, method)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
%% hold out the test set
X_train = X(~idx_testset,:);
X_test = X(idx_testset,:);
y_train = y(~idx_testset);
y_test = y(idx_testset);
n = size(X,2);

%% fit model
if strcmp(method,'mns')
    X_train = horzcat(ones(size(X_train,1),1), cos(X_train), sin(X_train));
    % fit mns
    beta = X_train \ y_train;
    y_hat = beta(1) + cos(X_test)*beta(2:1+n) + sin(X_test)*beta(2+n:end);
elseif strcmp(method,'lasso')
    X_train = horzcat(cos(X_train), sin(X_train));
    % fit lasso
    options.alpha = 1;
    cvfit = cvglmnet(X_train, y_train, 'gaussian',options);
    best_idx = cvfit.lambda_min == cvfit.lambda;
    beta = cvfit.glmnet_fit.beta(:,best_idx);
    y_hat = cvglmnetPredict(cvfit, X_test, cvfit.lambda_min);
else
    error('unrecognizable method type: must be lasso or mns')
end

%% save results
results.coef = beta;
results.yhat = y_hat;
results.residual = norm(y_hat - y_test);
results.corr = corr(y_hat,y_test);
results.acc = sum(bound(round(y_hat),1,8) == y_test) / length(y_test);
end


function x = bound(x, lwr, upr)
x(x > upr) = upr;
x(x < lwr) = lwr;
end

