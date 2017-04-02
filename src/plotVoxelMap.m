function [fig] = plotVoxelMap(brainMap, voxelMap, title_text)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
fig = scatter3(brainMap(:,1),brainMap(:,2),brainMap(:,3),'.');
hold on
scatter3(voxelMap(:,1),voxelMap(:,2),voxelMap(:,3),'r', 'linewidth', 2);
hold off
title(title_text)

end

