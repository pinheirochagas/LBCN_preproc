function PlotCoverage(sbj_name, dirs, plot_label, correction_factor)


% Load subjVar
if exist([dirs.original_data filesep sbj_name filesep 'subjVar_' sbj_name '.mat'], 'file')
    load([dirs.original_data filesep sbj_name filesep 'subjVar_' sbj_name '.mat']);
else
    center = 'Stanford';
    fsDir_local = '/Applications/freesurfer/subjects/fsaverage';
    [fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_name, center);
    subjVar = CreateSubjVar(sbj_name, dirs, data_format, fsDir_local);
end

%% Load a given globalVar
if plot_label
    gv_dir = dir(fullfile([dirs.data_root filesep 'originalData/' sbj_name]));
    gv_inds = arrayfun(@(x) contains(x.name, 'global'), gv_dir);
    fn_tmp = gv_dir(gv_inds);
    load([fn_tmp(1).folder filesep fn_tmp(1).name])
else
end

load('cdcol_2018.mat')
marker_size = 8;
figureDim = [0 0 .4 1];
% figureDim = [0 0 1 .4];


figure('units', 'normalized', 'outerposition', figureDim)
views = {'lateral', 'lateral', 'medial', 'medial', 'ventral', 'ventral'};
hemis = {'left', 'right', 'left', 'right', 'left', 'right'};
% 
% views = {'lateral', 'ventral'};
% hemis = {'left', 'left'};

for i = 1:length(views)
    subplot(3,2,i)
%     subplot(1,2,i)
    
    coords_plot = CorrectElecLoc(subjVar.native_coord, views{i}, hemis{i}, correction_factor);
    ctmr_gauss_plot(subjVar.cortex.(hemis{i}),[0 0 0], 0, hemis{i}, views{i})
    %     f1 = plot3(coords_plot(:,1),coords_plot(:,2),coords_plot(:,3), 'o', 'MarkerSize', 10, 'MarkerFaceColor', cdcol.light_cadmium_red, 'MarkerEdgeColor', cdcol.light_cadmium_red);
    
    for ii = 1:length(coords_plot)
        % Only plot on the relevant hemisphere
        if (strcmp(hemis{i}, 'left') == 1 && coords_plot(ii,1) > 0) || (strcmp(hemis{i}, 'right') == 1 && coords_plot(ii,1) < 0)
        else
            plot3(coords_plot(ii,1),coords_plot(ii,2),coords_plot(ii,3), 'o', 'MarkerSize', marker_size, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');
        end
        
    end
    
    if plot_label
        for it = 1:length(coords_plot)
            hold on
            if (strcmp(hemis{i}, 'left') == 1 && coords_plot(ii,1) > 0) || (strcmp(hemis{i}, 'right') == 1 && coords_plot(ii,1) < 0)
            else
                text(coords_plot(it,1),coords_plot(it,2),coords_plot(it,3), subjVar.labels(it), 'FontSize', 7);
            end
        end
    else
    end
    
    alpha(0.7)
end
text(135,550,1,sbj_name, 'Interpreter', 'none', 'FontSize', 30, 'HorizontalAlignment', 'Center')
if plot_label
    savePNG(gcf, 300, [dirs.result_root '/coverage/' sbj_name '_labels.png']);
else
    savePNG(gcf, 300, [dirs.result_root '/coverage/' sbj_name '.png']);
end

close all
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