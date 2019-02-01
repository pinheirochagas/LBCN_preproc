function PlotSelectivityGroup(dirs,coords, project_name, elect_select, cortex_space, correction_factor)


%% Load comon brain (replace by fsaverage)
% load([dirs.code_root filesep 'vizualization/Colin_cortex_left.mat']);
% cmcortex.left = cortex;
% load([dirs.code_root filesep 'vizualization/Colin_cortex_right.mat']);
% cmcortex.right = cortex;
% 
% 
% [DOCID,GID] = getGoogleSheetInfo('math_network', project_name);
% googleSheet = GetGoogleSpreadsheet(DOCID, GID);
% implant = googleSheet.implant{strcmp(googleSheet.subject_name, sbj_name)};


cmcortex.right=load('/Users/pinheirochagas/Pedro/Stanford/code/fieldtrip/template/anatomy/surface_pial_rigth.mat');
cmcortex.left= load('/Users/pinheirochagas/Pedro/Stanford/code/fieldtrip/template/anatomy/surface_pial_left.mat')

ft_plot_mesh(cmcortex.left);




fspial_surf = ft_read_headshape(['/Applications/freesurfer/fsaverage/surf/lefth.pial']);
fspial_surf.coordsys = 'fsaverage';

% 1.1: FT_surface based registration to fs_average
f1=figure;
title({'FT_SURFACE registration';'on fsaverage brain'}, 'Interpreter', 'none');
ft_plot_mesh(fspial_surf);
ft_plot_sens(elec_fsavg_frs,'elecsize',20,'style', 'r');
if strcmp(hemisphere, 'r')
    view([120 0]);
elseif strcmp(hemisphere, 'l')
    view([-120 0]);
end
alpha(0.7)
material dull;
lighting gouraud;
camlight;







%% Define elect size and color
load('cdcol_2018.mat')

elect_size = repmat(10, length(elect_select), 1);
elect_size(strcmp(elect_select, 'no selectivity')) = 5;

for i = 1:length(elect_select)

    if strcmp(elect_select{i}, 'math only')
        elect_col(i,:) = cdcol.indian_red;
    elseif strcmp(elect_select{i}, 'math selective')
        elect_col(i,:) = cdcol.raspberry_red;
    elseif strcmp(elect_select{i}, 'math and memory')
        elect_col(i,:) = cdcol.manganese_violet;
    elseif strcmp(elect_select{i}, 'memory only')
        elect_col(i,:) = cdcol.marine_blue;
    elseif strcmp(elect_select{i}, 'memory selective')
        elect_col(i,:) = cdcol.azurite_blue;
    else
        elect_col(i,:) = [0 0 0];
    end
end

%% Plot electrodes as dots in native space 
marker_size = 10;
figureDim = [0 0 .4 1];
f1 = figure('units', 'normalized', 'outerposition', figureDim);
views = {'lateral', 'lateral', 'medial', 'medial', 'ventral', 'ventral'};
hemis = {'left', 'right', 'left', 'right', 'left', 'right'};
for i = 1:length(views)
    subplot(3,2,i)
    if strcmp(cortex_space, 'MNI')
        coords_plot = CorrectElecLoc(coords, views{i}, hemis{i}, correction_factor);
        ctmr_gauss_plot(cmcortex.(hemis{i}),[0 0 0], 0, hemis{i}, views{i})        
    elseif strcmp(cortex_space, 'native')
        coords_plot = CorrectElecLoc(coords, views{i}, hemis{i}, correction_factor);
        ctmr_gauss_plot(subjVar.cortex.(hemis{i}),[0 0 0], 0, hemis{i}, views{i})
    else
        error('you must specify the cortical space to plot, either MNI or native.')
    end
    

    for ii = 1:length(coords_plot)
        % Only plot on the relevant hemisphere
        if (strcmp(hemis{i}, 'left') == 1 && coords_plot(ii,1) > 0) || (strcmp(hemis{i}, 'right') == 1 && coords_plot(ii,1) < 0)
        else
            plot3(coords_plot(ii,1),coords_plot(ii,2),coords_plot(ii,3), 'o', 'MarkerSize', elect_size(ii), 'MarkerFaceColor', elect_col(ii,:), 'MarkerEdgeColor', 'k');
        end
    end
    alpha(0.7)
%     if strcmp(implant, 'sEEG') || strcmp(implant, 'ECoG')
% %     if strcmp(implant, 'sEEG') 
%         alpha(0.5)
%     else
%     end
    if i == 2
        yl = ylim;
        xl = xlim;
        zl = zlim;
        fx = get(f1, 'Position');
%         text(sum(xl)/2,sum(yl)/2,zl(2)+zl(2)*0.2,sbj_name, 'Interpreter', 'none', 'FontSize', 30, 'HorizontalAlignment', 'Center')
    else
    end
end
text(135,550,1,subjVar.sbj_name, 'Interpreter', 'none', 'FontSize', 30, 'HorizontalAlignment', 'Center')

savePNG(gcf, 300, [dirs.result_root filesep 'selectivity' filesep subjVar.sbj_name '_selectivity_' project_name '_' cortex_space '.png']); % ADD TASK AND CONDITION
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