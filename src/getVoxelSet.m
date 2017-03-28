function [voxSet, voxSet_collapsed] = getVoxelSet(infoCell)
%UNTITLED2 Summary of this function goes here
% input     - voxSelMat - [iter x CVB]
% output    - voxSelIdx - [iter x 1] - idx of set of vox selected
nIters = size(infoCell,2);
if nIters ~= 0
    NCVB = size(infoCell{1}.voxSel,2);
    
    voxSet = cell(nIters,1);
    for i = 1 : nIters
        for c = 1 : NCVB
            voxSet{i} = union(voxSet{i}, infoCell{i}.voxSel{c});
        end
    end
    
else
    voxSet = cell(0,0); 
end

% collapse voxels over lasso iterations
voxSet_collapsed = [];
for i = 1 : length(voxSet)
    voxSet_collapsed = union(voxSet_collapsed, voxSet{i});
end

end

