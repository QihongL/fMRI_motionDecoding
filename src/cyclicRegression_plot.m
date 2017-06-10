clear all; 

load ../results/result_std_multinomial_ROIs.mat
NTR = 16;

% average 
accuracy = zeros(NTR,1);
correlation = zeros(NTR,1);
for i = 1 : length(RESULTS)
    accuracy = accuracy + mean(RESULTS{i}.acc,2);
    correlation = correlation + mean(RESULTS{i}.corr,2);
end
accuracy = accuracy / length(RESULTS); 
correlation = correlation / length(RESULTS);  

% plot 
LW = 2; 
subplot(121)
plot(correlation, 'linewidth', LW)
ylabel('correlation')
subplot(122)
plot(accuracy, 'linewidth', LW)
ylabel('accuracy')