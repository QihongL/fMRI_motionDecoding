function [ performance ] = readResults(RESULTS, NTR, nSubjs)


performance.accuracy.mean = nan(NTR,nSubjs);
performance.accuracy.sd = nan(NTR,nSubjs);
performance.numNZ = nan(NTR,nSubjs);
% gather results across all subjects 
for s = 1 : nSubjs
    % across all TRs
    for t = 1 : NTR
        % compute the mean and std for the accuracy
        performance.accuracy.mean(t,s) = mean(RESULTS{s}.accuracy(t,:));
        performance.accuracy.sd(t,s) = std(RESULTS{s}.accuracy(t,:),0); 
        % get sparsity 
        performance.numNZ(t,s) = nnz(RESULTS{s}.coef(:,:,t)); 
    end
end

end

