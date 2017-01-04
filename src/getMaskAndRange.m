function [y_target_vector, row_mask, unit_mask] = getMaskAndRange(decodingObjective, N_repeats)
% the stimulus classes are a circular domain: 0 is rightward motion, pi is
% leftward motion, pi/2 is 'away' motion, 3*pi/2 is 'towards' motion
Y_RANGE = [1 2 3 4 5 6 7 8];
% Y_LABELS = 0: pi/4 : (2*pi - pi/4);

if strcmp(decodingObjective, '2d')
    % 3 rightward motions vs. 3 leftward motions
    unit_mask = [0 0 1 0 0 0 1 0];
    range = [1 1 0 0 0 1];
    
elseif strcmp(decodingObjective, '3d')
    % 3 away motions vs. 3 towards motions
    unit_mask = [1 0 0 0 1 0 0 0];
    range = [1 1 1 0 0 0];
    
    % elseif strcmp(decodingObjective, '2d_1')
    %     % 1 rightward motion vs. 1 leftward motion
    %
    % elseif strcmp(decodingObjective, '3d_1')
    %     % 1 away motion vs. 1 toward motion
    
elseif strcmp(decodingObjective, 'multinomial')
    % 8-way decoding 
    unit_mask = [0 0 0 0 0 0 0 0];
    range = Y_RANGE; 
    
else
    error('Unrecognizable decoding objective.')
    
end

% get the unit_mask and target vector for the full data matrix
unit_mask = logical(unit_mask); 
row_mask = repmat(unit_mask', [N_repeats, 1]);
y_target_vector = repmat((range)',[N_repeats, 1]);
end