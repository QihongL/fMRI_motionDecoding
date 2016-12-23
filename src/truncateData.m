clear variables; clc; close all;
% specify path information
DIR.PROJECT = '/Users/Qihong/Dropbox/github/motionDecoding_fMRI/';
DIR.DATA = fullfile(DIR.PROJECT, '/data/rawdata/');
DIR.OUT = fullfile(DIR.PROJECT, 'data/');

% constants
SUBJ_NAMES = {'ah','br','ds','jf','rl'};
% specify parameters
nSubjs = length(SUBJ_NAMES);
nTR = 16;
nClasses = 8;

saveTruncatedData = 1;

%% only take a subset of the data
for s = 1:nSubjs
    load(fullfile(DIR.DATA, SUBJ_NAMES{s}));
    
    % record subj name, title, coordinates and ROIs
    data.subject_name = SUBJ_NAMES{s};
    data.title = 'detrened_data';
    data.ROIs = alldat.ROIs;
    
    %     %% take all ROIs
    %     idx_ROIs = [];
    %     for i = 1
    % %     for i = 1 : length(data.ROIs)
    %         idx_ROIs = horzcat(idx_ROIs,data.ROIs(i).ROIind);
    %     end
    %     idx_ROIs = unique(idx_ROIs);
    %
    %     %% take whole cortex
    %     idx_cortex = alldat.grayinds;
    
    
    idx_outside = alldat.grayinds;
    
    for roi = 1 : length(alldat.ROIs)
        trunc_name = sprintf('ROI%.2d',roi);
        %% select the index , get the data
        data.name = trunc_name;
        data.ROIind = alldat.ROIs(roi).ROIind';
        data.coords = alldat.ROIs(roi).coords';
        idx_outside = setdiff(idx_outside,data.ROIind);
        
        % take the functional data, ordered by TR
        data.detrended = cell(nTR,1);
        for t = 1 : nTR
            % internally, ordered by runs (loop over 10 runs)
            for run = 1 : length(alldat.detrendedData)
                data.detrended{t} = vertcat(data.detrended{t}, ...
                    alldat.detrendedData{run}(:,data.ROIind,t));
            end
        end
               
        % save data
        if saveTruncatedData
            fprintf('Truncated data for <%s> is saved to <%s>\n', ...
                data.subject_name, DIR.DATA);
            save(strcat(DIR.OUT,data.subject_name,'_',trunc_name),'data');
        end
    end
    
    % get all data outside of the 20 ROIs
    data.subject_name = SUBJ_NAMES{s};
    data.title = 'detrened_data';
    data.ROIs = alldat.ROIs;
    trunc_name = 'outside';
    data.name = trunc_name;
    data.ROIind = idx_outside;
    data.coords = alldat.coords(idx_outside,:);
    % collect bold signal
    data.detrended = cell(nTR,1);
    for t = 1 : nTR
        for run = 1 : length(alldat.detrendedData)
            data.detrended{t} = vertcat(data.detrended{t}, ...
                alldat.detrendedData{run}(:,idx_outside,t));
        end
    end
    % save data
    if saveTruncatedData
        fprintf('Truncated data for <%s> is saved to <%s>\n', ...
            data.subject_name, DIR.DATA);
        save(strcat(DIR.OUT,data.subject_name,'_',trunc_name),'data');
    end
end
