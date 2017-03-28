clear variables; clc;
% specify path information
DIR.ROOT = '..';
DIR.DATA = fullfile(DIR.ROOT, 'data');
DIR.RAWDATA = fullfile(DIR.DATA,'rawdata');

% CONSTANTS (should not be changed)
SUBJ_NAMES = {'ah','br','ds','jf','rl'};
NTR = 16;
NSUBJ = length(SUBJ_NAMES);
NCVB = 5;   % 5-folds cross validation

%% select data
for s = 1 : NSUBJ
    vox_idx(s).subj_name  = SUBJ_NAMES{s}; 
    data_fname = sprintf('%s.mat',SUBJ_NAMES{s});
    load(fullfile(DIR.RAWDATA,data_fname))
    vox_idx(s).gray = alldat.grayinds; 
    
    idx_ROIs = []; 
    for r = 1 : length(alldat.ROIs)
        idx_ROIs = union(idx_ROIs, alldat.ROIs(r).ROIind);
    end
    vox_idx(s).ROIs_all = idx_ROIs; 
    vox_idx(s).ROIs = alldat.ROIs; 
end

save(sprintf('%s/vox_idx.mat',DIR.DATA), 'vox_idx'); 