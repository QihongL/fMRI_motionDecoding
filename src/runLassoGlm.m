function results = runLassoGlm(X, y, testIdx, options, CVB)

% hold out the test set
X_train = X(~testIdx,:);
X_test = X(testIdx,:);
y_train = y(~testIdx);
y_test = y(testIdx);

% fit lasso
[B, FitInfo] = lassoglm(X_train,y_train,'binomial','NumLambda',options.nlambda,'CV',CVB);
coef = [FitInfo.Intercept(FitInfo.IndexMinDeviance); B(:,FitInfo.IndexMinDeviance)];
y_hat = glmval(coef,X_test,'logit');

% save coeff
results.lasso_lambda_min = FitInfo.Lambda(FitInfo.IndexMinDeviance);
results.lasso_coef_lambda_min = coef;
results.lasso_accuracy_lambda_min = sum(round(y_hat) == y_test) / length(y_test);
end

