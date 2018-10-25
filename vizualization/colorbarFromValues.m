function [col_idx,cols] = colorbarFromValues(values, color_map)
%% Get a colormap from a set of values
%
min_value_symetric = -(max([max(values) abs(min(values))]));
% col_idx=floor((values-min_value_symetric)/(-2*min_value_symetric) * 100) + 1;
col_idx=floor((values-min(values))/range(values) * 100) + 1;


if strcmp(color_map, 'parula') == 1
    cols = parula(max(col_idx));
elseif strcmp(color_map, 'RedBlue') == 1
    cols = cmRedBlue(max(col_idx));
elseif strcmp(color_map, 'VioletGreen') == 1
    cols = cmVioletGreen(max(col_idx));
elseif strcmp(color_map, 'PinkGreen') == 1
    cols = cmPinkGreen(max(col_idx));
elseif strcmp(color_map, 'YellowGreen') == 1
    cols = cmYellowGreen(max(col_idx));
elseif strcmp(color_map, 'RedsWhite') == 1
    cols = cmRedsWhite(max(col_idx));  
elseif strcmp(color_map, 'BluesWhite') == 1
    cols = cmBluesWhite(max(col_idx)); 
else
    cols = cbrewer2(color_map, max(col_idx));
end

% 
% 
% 
% if strcmp(color_map, 'parula') == 1
%     cols = parula(range(col_idx)+1);
% elseif strcmp(color_map, 'RedBlue') == 1
%     cols = cmRedBlue(range(col_idx)+1);
% elseif strcmp(color_map, 'VioletGreen') == 1
%     cols = cmVioletGreen(range(col_idx)+1);
% elseif strcmp(color_map, 'PinkGreen') == 1
%     cols = cmPinkGreen(range(col_idx)+1);
% elseif strcmp(color_map, 'YellowGreen') == 1
%     cols = cmYellowGreen(range(col_idx)+1);
% else
%     cols = cbrewer2(color_map, range(col_idx)+1);
% end

end
