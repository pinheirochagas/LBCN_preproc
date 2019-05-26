function PlotCoverageROL(subjVar, ROLs, cortex_space, correction_factor, dirs)



%% Load comon brain
% load([dirs.code_root filesep 'vizualization/Colin_cortex_left.mat']);
% cmcortex.left = cortex;
% load([dirs.code_root filesep 'vizualization/Colin_cortex_right.mat']);
% cmcortex.right = cortex;
[cmcortex.right.vert cmcortex.right.tri]=read_surf(fullfile('/Applications/freesurfer/subjects/fsaverage/surf',['rh.' 'pial']));
[cmcortex.left.vert cmcortex.left.tri]=read_surf(fullfile('/Applications/freesurfer/subjects/fsaverage/surf',['lh.' 'pial']));


% basic parameters:
decimate = true;
final_fs = 50;

% Get color indices
[col_idx,colors_plot] = colorbarFromValues(ROLs, 'viridis', [], false);


%% Plot electrodes as dots in native space 
marker_size = 10;
figureDim = [0 0 1 1];
% figureDim = [0 0 1 .4];


f1 = figure('units', 'normalized', 'outerposition', figureDim);


views = {'lateral', 'lateral', 'medial', 'medial', 'ventral', 'ventral'};
hemis = {'left', 'right', 'left', 'right', 'left', 'right'};

views = {'lateral', 'dorsal', 'ventral'};
hemis = {'left', 'left', 'left'};

views = {'lateral', 'lateral', 'ventral', 'ventral'};
hemis = {'left', 'right', 'left', 'right'};



for i = 1:length(views)
    subplot(2,2,i)
    if strcmp(cortex_space, 'MNI')
        coords_plot = CorrectElecLoc(subjVar.elinfo.MNI_coord, views{i}, hemis{i}, correction_factor);
        ctmr_gauss_plot(cmcortex.(hemis{i}),[0 0 0], 0, hemis{i}, views{i})        
    elseif strcmp(cortex_space, 'native')
        coords_plot = CorrectElecLoc(subjVar.elinfo.LEPTO_coord, views{i}, hemis{i}, correction_factor);
        ctmr_gauss_plot(subjVar.cortex.(hemis{i}),[0 0 0], 0, hemis{i}, views{i})
    else
        error('you must specify the cortical space to plot, either MNI or native.')
    end
    
    for ii = 1:length(coords_plot)
        % Only plot on the relevant hemisphere
        if ~isnan(col_idx(ii))
            if (strcmp(hemis{i}, 'left') == 1 && strcmp(subjVar.elinfo.LvsR(ii), 'R') == 1) || (strcmp(hemis{i}, 'right') == 1 && strcmp(subjVar.elinfo.LvsR(ii), 'L') == 1)
            else
                plot3(coords_plot(ii,1),coords_plot(ii,2),coords_plot(ii,3), 'o', 'MarkerSize', marker_size, 'MarkerFaceColor', colors_plot(col_idx(ii),:), 'MarkerEdgeColor', 'k');
            end
%                 plot3(coords_plot(ii,1),coords_plot(ii,2),coords_plot(ii,3), 'o', 'MarkerSize', marker_size, 'MarkerFaceColor', colors_plot(col_idx(ii),:), 'MarkerEdgeColor', 'k');
        else
        end
    end
        alpha(1)
    
    if i == 2
        yl = ylim;
        xl = xlim;
        zl = zlim;
        fx = get(f1, 'Position');
%         text(sum(xl)/2,sum(yl)/2,zl(2)+zl(2)*0.2,sbj_name, 'Interpreter', 'none', 'FontSize', 30, 'HorizontalAlignment', 'Center')
    else
    end
end
text(135,550,1,sbj_name, 'Interpreter', 'none', 'FontSize', 30, 'HorizontalAlignment', 'Center')

savePNG(gcf, 300, [dirs.result_root filesep 'heatmap' filesep sbj_name '_heatmap_' project_name '_' conds_avg_conds_join{1} '_' cortex_space '.png']); % ADD TASK AND CONDITION
close all

end

%% Function to optimize electrode location for plotting
function coords_plot = CorrectElecLoc(coords, views, hemisphere, correction_factor)
coords_plot = coords;
% correction_factor = 0;
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