function [col_idx,cols] = colorbarFromValues(values, color_map,clim,center_zero)
%% Get a colormap from a set of values
%
ncols = 100 + 1; % # of discrete colors within color scale
ncols = length(values) + 2;

if isempty(clim) % if no limits specified, set colorscale limits based on range of data
    if center_zero % i.e. if value of 0 set to center of colormap
        min_value_symetric = -(nanmax([nanmax(values) abs(nanmin(values))]));
        col_idx=floor((values-min_value_symetric)/(-2*min_value_symetric) * 100) + 1;
    else % adjust colormap to whole range of values
        col_idx=floor((values-nanmin(values))/range(values) * 100) + 1;
    end
else 
    values(values<clim(1))=clim(1);
%     values(values>clim(2))=clim(2);
    values(values>clim(2))=values(values>clim(2))/max(values(values>clim(2))) * clim(2); 
    if center_zero % colorbar centered at zero
        clim = [-max(abs(clim(1)),abs(clim(2))) max(abs(clim(1)),abs(clim(2)))];
    end
    col_idx=floor((values-clim(1))/(clim(2)-clim(1)) * ncols) + 1;
    
end
    
if strcmp(color_map, 'parula') == 1
    cols = parula(ncols);
elseif strcmp(color_map, 'RedBlue') == 1
    cols = cmRedBlue(ncols);
    cols = cols(end:-1:1,:);
elseif strcmp(color_map, 'VioletGreen') == 1
    cols = cmVioletGreen(ncols);
elseif strcmp(color_map, 'PinkGreen') == 1
    cols = cmPinkGreen(ncols);
elseif strcmp(color_map, 'YellowGreen') == 1
    cols = cmYellowGreen(ncols);
elseif strcmp(color_map, 'RedsWhite') == 1
    cols = cmRedsWhite(ncols);  
elseif strcmp(color_map, 'BluesWhite') == 1
    cols = cmBluesWhite(ncols); 
else
    cols = cbrewer2(color_map, ncols+1);
    cols = cols(end:-1:1,:);
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
