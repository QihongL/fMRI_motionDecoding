function [ sim_conditions ] = labelROInames(numROIs, idx_deletedROI)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

ROInames = {'V1_d','V2_d','V3_d','V3A_d','V4_d','MT+_4',...
    'IPS_d','LO_d',...
    'IPS0_prob','IPS1_prob','IPS2_prob','IPS3_prob','LO_prob',...
    'V3a_prob','V3b_prob','VO1_prob','VO2_prob',...
    'SPL1_prob','PHC1_prob','PHC2_prob'};

sim_conditions = {}; 
for roi = 1 : numROIs
    if roi == idx_deletedROI
        continue
    end
    strs = strsplit(ROInames{roi}, '_');
    sim_conditions{length(sim_conditions)+1} = char(strcat(strs(1), ' ', strs(2)));
end
end

