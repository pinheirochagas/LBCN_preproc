function PlotAtlasLabels(subjVar,cfg)
% plot_label = type of label to plot
%   FS_label: freesurfer label
%   Destr_ind: Destrieux atlas
%   Yeo_ind: Yeo2007

correction_factor = false;
load('cdcol_2018.mat');
marker_size = 2;
figureDim = [0 0 1 1];

figure('units', 'normalized', 'outerposition', figureDim)

% Define subplot dims
if isprime(length(cfg.views)) && length(cfg.views) < 7
    subplot_dim = [ceil(sqrt(length(cfg.views))), 1];
else
    subplot_dim = [ceil(sqrt(length(cfg.views))), ceil(sqrt(length(cfg.views)))];
end


for i = 1:length(cfg.views)
    subplot(subplot_dim(1), subplot_dim(2),i)
    coords_plot = CorrectElecLoc(subjVar.LEPTO_coord, cfg.views{i}, cfg.hemis{i}, cfg.correction_factor);
    ctmr_gauss_plot(subjVar.cortex.(cfg.hemis{i}),[0 0 0], 0, cfg.hemis{i}, cfg.views{i})    
    for ii = 1:length(coords_plot)
        % Only plot on the relevant cfg.hemisphere
        if (strcmp(cfg.hemis{i}, 'left') == 1 && coords_plot(ii,1) > 0) || (strcmp(cfg.hemis{i}, 'right') == 1 && coords_plot(ii,1) < 0)
        else
            plot3(coords_plot(ii,1),coords_plot(ii,2),coords_plot(ii,3), 'o', 'MarkerSize', marker_size, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');
        end
        
    end
    for it = 1:length(coords_plot)
        hold on
        if ~contains(subjVar.elinfo.FS_label(it),'empty') && ~strcmp(subjVar.elinfo.Destr_ind(it),'Depth')
            text(coords_plot(it,1),coords_plot(it,2),coords_plot(it,3), subjVar.elinfo.(cfg.plot_label)(it), 'FontSize', cfg.label_fontsize, 'FontWeight', 'bold', 'Color', 'r', 'HorizontalAlignment', 'center');
        else
        end
    end
    alpha(0.7)
end


end
%% Function to optimize electrode location for plotting
function coords_plot = CorrectElecLoc(coords, views, hemisphere, correction_factor)
coords_plot = coords;
switch views
    case 'lateral'
        if strcmp(hemisphere, 'right')
            coords_plot(:,1) = coords_plot(:,1) + correction_factor;
        elseif strcmp(hemisphere, 'left')
            coords_plot(:,1) = coords_plot(:,1) - correction_factor;
        end
    case 'medial'
        if strcmp(hemisphere, 'right')
            coords_plot(:,1) = coords_plot(:,1) - correction_factor;
        elseif strcmp(hemisphere, 'left')
            coords_plot(:,1) = coords_plot(:,1) + correction_factor;
        end
    case 'ventral'
        coords_plot(:,3) = coords_plot(:,3) - correction_factor;
end
end