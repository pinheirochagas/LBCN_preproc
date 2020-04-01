function PlotModulation(dirs, project_name, subjVar, ind, cfg)

%% Load comon brain
elinfo = subjVar.elinfo;

fsaverage_dir = '/Applications/freesurfer/subjects/fsaverage/surf'; % correct that:'/Applications/freesurfer/freesurfer/subjects/fsaverage/surf/rh.pial'
if strcmp(cfg.Cortex, 'MNI')
    [cmcortex.right.vert cmcortex.right.tri]=read_surf(fullfile('/Applications/freesurfer/subjects/fsaverage/surf',['rh.' 'pial']));
    [cmcortex.left.vert cmcortex.left.tri]=read_surf(fullfile('/Applications/freesurfer/subjects/fsaverage/surf',['lh.' 'pial']));
    coords_plot = elinfo.MNI_coord;
elseif  strcmp(cfg.Cortex, 'native')
    cmcortex = subjVar.cortex;
    coords_plot = elinfo.LEPTO_coord;
else
    error('you must specify the cortical space to plot, either MNI or native.')
end

% Decide if project left
if cfg.project_left
    elinfo.MNI_coord(:,1) = -abs(elinfo.MNI_coord(:,1));
    elinfo.LvsR = repmat({'L'}, size(elinfo,1),1);
end

% basic parameters:
decimate = true;
final_fs = 50;

% Get color indices
% [col_idx,colors_plot] = colorbarFromValues(ind, 'RedBlue', [], true);
[col_idx,colors_plot] = colorbarFromValues(ind, cfg.Colormap, cfg.clim, cfg.color_center_zero);
col_idx(col_idx==0)=1; % dirty fix


%% Plot electrodes as dots in native space
if cfg.MarkerSize_mod
    marker_size = abs(ind)*cfg.MarkerSize;
else
    marker_size = repmat(cfg.MarkerSize,size(elinfo,1),1);
end
% figureDim = [0 0 1 .4];

f1 = figure('units', 'normalized', 'outerposition', cfg.figureDim);
views =  cfg.views;
hemis = cfg.hemis;

for i = 1:length(views)
    subplot(cfg.subplots(1),cfg.subplots(2),i)
    coords_plot = CorrectElecLoc(coords_plot, views{i}, hemis{i}, cfg.CorrectFactor); %
    ctmr_gauss_plot(cmcortex.(hemis{i}),[0 0 0], 0, hemis{i}, views{i})
    
    for ii = 1:length(coords_plot)
        % Only plot on the relevant hemisphere
        if ~isnan(col_idx(ii))
            if (strcmp(hemis{i}, 'left') == 1 && strcmp(elinfo.LvsR(ii), 'R') == 1) || (strcmp(hemis{i}, 'right') == 1 && strcmp(elinfo.LvsR(ii), 'L') == 1)
            else
                plot3(coords_plot(ii,1),coords_plot(ii,2),coords_plot(ii,3), 'o', 'MarkerSize', marker_size(ii), 'MarkerFaceColor', colors_plot(col_idx(ii),:), 'MarkerEdgeColor', 'none');
            end
        else
        end
    end
    
    
    if ~isempty(cfg.chan_highlight)
        for hi = 1:length(cfg.chan_highlight)
            if (strcmp(hemis{i}, 'left') && strcmpi(elinfo.LvsR{cfg.chan_highlight(hi)},'L'))
                plot3(coords_plot(cfg.chan_highlight(hi),1),coords_plot(cfg.chan_highlight(hi),2),coords_plot(cfg.chan_highlight(hi),3), 'o', 'MarkerSize', cfg.marker_size_high, 'MarkerFaceColor', cfg.highlight_face_col(hi,:), 'MarkerEdgeColor', cfg.highlight_edge_col(hi,:));
            elseif (strcmp(hemis{i}, 'right') && strcmpi(elinfo.LvsR{cfg.chan_highlight(hi)},'R'))
                plot3(coords_plot(cfg.chan_highlight(hi),1),coords_plot(cfg.chan_highlight(hi),2),coords_plot(cfg.chan_highlight(hi),3), 'o', 'MarkerSize', cfg.marker_size_high, 'MarkerFaceColor', cfg.highlight_face_col(hi,:), 'MarkerEdgeColor', cfg.highlight_edge_col(hi,:));
            else
            end
        end
    end
    
    alpha(cfg.alpha)
end
if cfg.save
    savePNG(gcf, 300, [dirs.result_root filesep 'selectivity' filesep 'group_selectivity4_' project_name '_' cortex_space '.png']); % ADD TASK AND CONDITION
    close all
else
end

end