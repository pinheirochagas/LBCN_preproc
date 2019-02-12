function PlotAtlasLabels(subjVar,plot_label)

correction_factor = false;
load('cdcol_2018.mat');
marker_size = 8;
figureDim = [0 0 .4 1];

figure('units', 'normalized', 'outerposition', figureDim)
views = {'lateral', 'lateral', 'medial', 'medial', 'ventral', 'ventral'};
hemis = {'left', 'right', 'left', 'right', 'left', 'right'};
shading interp; lighting gouraud; material dull;

for i = 1:length(views)
    subplot(3,2,i)
    coords_plot = CorrectElecLoc(subjVar.LEPTO_coord, views{i}, hemis{i}, correction_factor);
    ctmr_gauss_plot(subjVar.cortex.(hemis{i}),[0 0 0], 0, hemis{i}, views{i})    
    for ii = 1:length(coords_plot)
        % Only plot on the relevant hemisphere
        if (strcmp(hemis{i}, 'left') == 1 && coords_plot(ii,1) > 0) || (strcmp(hemis{i}, 'right') == 1 && coords_plot(ii,1) < 0)
        else
            plot3(coords_plot(ii,1),coords_plot(ii,2),coords_plot(ii,3), 'o', 'MarkerSize', marker_size, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');
        end
        
    end
    for it = 1:length(coords_plot)
        hold on
        if ~contains(subjVar.elinfo.FS_label(it),'empty') && ~strcmp(subjVar.elinfo.Destr_ind(it),'Depth')
            switch plot_label
                case 'chan_label'
                    text(coords_plot(it,1),coords_plot(it,2),coords_plot(it,3), subjVar.elinfo.FS_label(it), 'FontSize', 7);
                case 'anat_label'
                    text(coords_plot(it,1),coords_plot(it,2),coords_plot(it,3), subjVar.elinfo.Destr_ind(it), 'FontSize', 7);
                case 'netw_label'
                    text(coords_plot(it,1),coords_plot(it,2),coords_plot(it,3), subjVar.elinfo.Yeo_ind(it), 'FontSize', 7);
            end
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