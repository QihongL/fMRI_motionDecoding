clear variables; clc;
fh=findall(0,'type','figure');
for i=1:length(fh)
    clo(fh(i));
end
% specify path information
DIR.ROOT = '..';
DIR.DATA = fullfile(DIR.ROOT, 'data/');
DIR.OUT = fullfile(DIR.ROOT, 'results/');
DIR.PLOT = fullfile(DIR.ROOT, 'plots/ilasso/');
DIR.VOXMAP = fullfile(DIR.PLOT, 'voxSelMap_by_cond_subj');


% CONSTANTS (should not be changed)
SUBJ_NAMES = {'ah','br','ds','jf','rl'};
NTR = 16;
NSUBJ = length(SUBJ_NAMES);
CHANCE = .5;
NCVB = 5;   % 5-folds cross validation
NCVB_internal = 4;

%% select data
filestem = 'result_ilasso';
objective = '2d';
CONDS = {'ROIs', 'wb', 'outside'};

%% gather data
accuracy = cell(length(CONDS),NSUBJ,NTR);
voxSets = cell(length(CONDS),NSUBJ,NTR);
for c = 1 : length(CONDS)
    % for c = 1 : length(CONDS)
    condition = CONDS{c};
    fname = sprintf('%s_%s_%s.mat', filestem,objective,condition);
    load(fullfile(DIR.OUT,fname))
    for s = 1 : NSUBJ
        for t = 1 : NTR
            % calculate the number of voxels selected
            [~, voxSets{c,s,t}] = getVoxelSet(RESULTS{s}.result{t}.lasso);
            tempAccMat = [];
            for i = 1 : RESULTS{s}.result{t}.iterNum
                % gather accuracy
                tempAccMat = vertcat(tempAccMat, RESULTS{s}.result{t}.lasso{i}.accuracy);
            end
            accuracy{c,s,t} = tempAccMat;
        end
    end
end

%% plot the accuracy-iterations over TR
LW = 1.5;
alpha = .05;
% tval = tinv(1 - alpha/2, NCVB-1);
% for c = 1 : length(CONDS)
%     for t = 1 : NTR
%         for s = 1 : NSUBJ
%             subplot(2,3,s)
%             eb = std(accuracy{c,s,t},0,2)* tval / sqrt(NCVB);
%             fig = errorbar(mean(accuracy{c,s,t},2),eb, 'linewidth', LW);
%             xlabel('Iterations');ylabel('Accuracy');
%             ylim([.5, 1]);
%         end
%         title_text = sprintf('ilasso accuracy, %s,TR = %d',CONDS{c},t);
%         suptitle(title_text)
%         figname = sprintf('ilasso_acc_%s_t%.2d.jpg',CONDS{c},t);
%         saveas(fig,fullfile(DIR.PLOT,figname))
%     end
% end


% %% plot voxels on the brain
% saveVoxMap = 0; 
% for c = 1 : length(CONDS)
%     cond = CONDS{c};
%     for s = 1 : NSUBJ
%         subj_name = SUBJ_NAMES{s};
%         data_fname = sprintf('%s_%s.mat',subj_name, cond);
%         load(fullfile(DIR.DATA, data_fname))
%         for t = 1 : NTR
%             fig = subplot(4,4,t);
%             title_text = sprintf('TR = %d', t);
%             plotVoxelMap(data.coords, data.coords(voxSets{c,s,t},:), title_text); 
%         end
%         suptitle_text = sprintf('%s_%s', subj_name, cond);
%         suptitle(suptitle_text);
%         if saveVoxMap
%             saveas(fig,fullfile(DIR.VOXMAP,suptitle_text))
%         end
%     end
% end



% %% plot num voxels selected across different conditions over time ...
% load ../data/vox_idx.mat
% for s = 1 : NSUBJ
%     for c = 2 % whole brain 
%         cond = CONDS{c};
%         subj_name = SUBJ_NAMES{s};
%         for t = 1 : NTR
%             vox_sel_idx = vox_idx(s).gray(voxSets{c,s,t}); 
%             nVox.inROI(s,t) = length(intersect(vox_sel_idx,vox_idx(s).ROIs_all));
%             nVox.total(s,t) = length(vox_idx(s).gray(voxSets{c,s,t}));
%         end
%     end
% end
% 
% plot([nVox.inROI ./ nVox.total]', 'linewidth',LW)
% legend(SUBJ_NAMES,'location','SW')
% xlabel('TR')
% ylabel('vox within ROIs / vox total (%)')
% title('% voxel selected in the ROIs')


% for c = 1 : length(CONDS)
%     cond = CONDS{c};
%     for s = 1 : NSUBJ
%         subj_name = SUBJ_NAMES{s};
%         data_fname = sprintf('%s_%s.mat',subj_name, cond);
%         load(fullfile(DIR.DATA, data_fname))
%         
%         
%         
%         for t = 1 : NTR
%             %             voxSets{c,s,t}
%         end
%     end
% end