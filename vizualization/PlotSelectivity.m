function PlotSelectivity(dirs, subjVar, elect_select, cortex_space, correction_factor, overlay)

coords = elect_select.LEPTO_coord;
elect_select = elect_select.elect_select;

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


subDir = dirs.freesurfer;
subj = dir(subDir);
subj=subj(~ismember({subj.name},{'.','..', '.DS_Store'}) & horzcat(subj.isdir) == 1);
subj = subj.name;

%% Define elect size and color
load('cdcol_2018.mat')

elect_size = repmat(9, length(elect_select), 1);
elect_size(strcmp(elect_select, 'no selectivity')) = 2;
elect_size(strcmp(elect_select, 'math and autobio')) = 7;


for i = 1:length(elect_select)

    if strcmp(elect_select{i}, 'math only')
        elect_col(i,:) = cdcol.carmine;
    elseif strcmp(elect_select{i}, 'math selective')
        elect_col(i,:) = cdcol.pink;
    elseif strcmp(elect_select{i}, 'math and autobio')
        elect_col(i,:) = cdcol.mauve;
    elseif strcmp(elect_select{i}, 'autobio only')
        elect_col(i,:) = cdcol.ultramarine;
    elseif strcmp(elect_select{i}, 'autobio selective')
        elect_col(i,:) = cdcol.light_blue;       
    else
        elect_col(i,:) = [0 0 0];
    end
end

%% Plot electrodes as dots in native space 
marker_size = 10;
figureDim = [0 0 .4 1];
f1 = figure('units', 'normalized', 'outerposition', figureDim);

hemis = {'left', 'right', 'left', 'right', 'left', 'right'};

if overlay == false
    views = {'lateral', 'lateral', 'medial', 'medial', 'ventral', 'ventral'};
else
    cfg=[];
    cfg.elecCoord = 'n';
    cfg.view='l';
    cfg.overlayParcellation='Y7';
    cfg.surfType = 'pial';
    cfg.fsurfSubDir = dirs.freesurfer;
    cfg.ignoreDepthElec = 'n';
    cfg.title = [];
    views = {'l', 'r', 'lm', 'rm', 'li', 'ri'};
end


for i = 1:length(views)
    subplot(3,2,i)
    if strcmp(cortex_space, 'MNI')
        coords_plot = CorrectElecLoc(coords, views{i}, hemis{i}, correction_factor);
        ctmr_gauss_plot(cmcortex.(hemis{i}),[0 0 0], 0, hemis{i}, views{i})        
    elseif strcmp(cortex_space, 'native')
        coords_plot = CorrectElecLoc(coords, views{i}, hemis{i}, correction_factor);
        if overlay == false
            ctmr_gauss_plot(subjVar.cortex.(hemis{i}),[0 0 0], 0, hemis{i}, views{i})
        else
            cfg.view = views{i};
            plotPialSurfCustom(subj,cfg)
        end
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
% text(135,550,1,subjVar.sbj_name, 'Interpreter', 'none', 'FontSize', 30, 'HorizontalAlignment', 'Center')
text(135,550,1,'YEO_7', 'Interpreter', 'none', 'FontSize', 30, 'HorizontalAlignment', 'Center')

% savePNG(gcf, 300, [dirs.result_root filesep 'selectivity' filesep subjVar.sbj_name '_selectivity_' project_name '_' cortex_space '.png']); % ADD TASK AND CONDITION
% close all

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