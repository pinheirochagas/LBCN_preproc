function PlotCoverageHeatmap(sbj_name,project_name, conds_avg_field, conds_avg_conds, colormap_plot, dirs)

%% Prepare data for heatmap
% Load subjVar 
if exist([dirs.original_data filesep sbj_name filesep 'subjVar_' sbj_name '.mat'], 'file')
    load([dirs.original_data filesep sbj_name filesep 'subjVar_' sbj_name '.mat']);
else
    center = 'Stanford';
    fsDir_local = '/Applications/freesurfer/subjects/fsaverage';
    [fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_name, center);
    subjVar = CreateSubjVar(sbj_name, dirs, data_format, fsDir_local);
end

% basic parameters:
decimate = true;
final_fs = 50;

concat_params = genConcatParams(decimate, final_fs);
concat_params.noise_method = 'trials';
block_names = BlockBySubj(sbj_name,project_name);
data_sbj = ConcatenateAll(sbj_name,project_name,block_names,dirs,[],'Band','HFB','stim', concat_params);

data_all = [];
for ii = 1:length(conds_avg_conds)
    % Initialize data_all
    data_all.(conds_avg_conds{ii}) = [];
end

for ii = 1:length(conds_avg_conds)
    data_tmp_avg = squeeze(nanmean(data_sbj.wave(strcmp(data_sbj.trialinfo.(conds_avg_field), conds_avg_conds{ii}),:,:),1)); % average trials by electrode
    % Calculate integral of averaged trials.
    data_tmp_integral = trapz(data_tmp_avg,2);
    data_tmp_integral_norm = data_tmp_integral/max(data_tmp_integral(:));
    data_all.(conds_avg_conds{ii}) = data_tmp_integral_norm; 
    % Exclude the nan values for channels
    data_all.(conds_avg_conds{ii}) = data_all.(conds_avg_conds{ii})(~isnan(subjVar.native_coord(:,1)),:);
end
% Exclude the nan values for electrodes
native_coord = subjVar.native_coord(~isnan(subjVar.native_coord(:,1)),:);


% Get color indices
[col_idx,colors_plot] = colorbarFromValues(data_all.math, colormap_plot);

[DOCID,GID] = getGoogleSheetInfo('math_network', project_name);
googleSheet = GetGoogleSpreadsheet(DOCID, GID);
hemisphere = googleSheet.hemi{strcmp(googleSheet.subject_name, sbj_name)};
implant = googleSheet.implant{strcmp(googleSheet.subject_name, sbj_name)};

%% Plot electrodes as dots in native space
if ~strcmp(hemisphere, 'left') && ~strcmp(hemisphere, 'right')
    warning([ sbj_name ' skipped: coverage was in both hemi - do it manually.'])
else 
    figureDim = [0 0 1 .4];
    figure('units', 'normalized', 'outerposition', figureDim)
    views = {'lateral', 'medial', 'ventral'};
    for i = 1:length(views)
        subplot(1,length(views),i)
        coords_plot = CorrectElecLoc(native_coord, views{i}, hemisphere);
        ctmr_gauss_plot(subjVar.cortex.(hemisphere),[0 0 0], 0, hemisphere(1), views{i})
        for ii = 1:length(coords_plot)
            plot3(coords_plot(ii,1),coords_plot(ii,2),coords_plot(ii,3), 'o', 'MarkerSize', 15, 'MarkerFaceColor', colors_plot(col_idx(ii),:), 'MarkerEdgeColor', 'k');
        end
        if strcmp(implant, 'sEEG')
            alpha(0.5)
        else
        end
        if i == 2
            yl = ylim;
            xl = xlim;
            zl = zlim;
            text(sum(xl)/2,sum(yl)/2,zl(2)+zl(2)*0.1,sbj_name, 'Interpreter', 'none', 'FontSize', 30, 'HorizontalAlignment', 'Center')
        else
        end
    end
%     light('Position',[1 0 0])
    conds_avg_conds_join = join(conds_avg_conds, '_')
    savePNG(gcf, 300, [dirs.result_root filesep project_name filesep sbj_name filesep 'Figures' filesep 'heatmap_' project_name '_' conds_avg_conds_join{1} '.png']); % ADD TASK AND CONDITION
    close all
end


end

%% Function to optimize electrode location for plotting
function coords_plot = CorrectElecLoc(coords, views, hemisphere)
coords_plot = coords;
correction_factor = 10;
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