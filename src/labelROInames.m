function [ sim_conditions ] = labelROInames( sim_conditions )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

ROInames = {'V1_d','V2_d','V3_d','V3A_d','V4_d','MT+_4',...
    'IPS_d','LO_d',...
    'IPS0_prob','IPS1_prob','IPS2_prob','IPS3_prob','LO_prob',...
    'V3a_prob','V3b_prob','VO1_prob','VO2_prob',...
    'SPL1_prob','PHC1_prob','PHC2_prob'};

for roi = 1 : length(sim_conditions) - 2
    strs = strsplit(ROInames{roi}, '_');
    sim_conditions{roi+2} = char(strcat(strs(1), ' ', strs(2)));
end
end

