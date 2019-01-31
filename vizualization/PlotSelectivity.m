function PlotSelectivity(sbj_name,project_name, conds_avg_field, conds_avg_conds, cond_plot, colormap_plot, cortex_space, correction_factor, dirs)

%% Prepare data for heatmap
% Load subjVar 
if exist([dirs.original_data filesep sbj_name filesep 'subjVar_' sbj_name '.mat'], 'file')
    load([dirs.original_data filesep sbj_name filesep 'subjVar_' sbj_name '.mat']);
else
    warning('no subjVar, trying to create it')
    center = 'Stanford';
    fsDir_local = '/Applications/freesurfer/subjects/fsaverage';
    [fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_name, center);
    subjVar = CreateSubjVar(sbj_name, dirs, data_format, fsDir_local);
end


%% Load comon brain
load([dirs.code_root filesep 'vizualization/Colin_cortex_left.mat']);
cmcortex.left = cortex;
load([dirs.code_root filesep 'vizualization/Colin_cortex_right.mat']);
cmcortex.right = cortex;

% basic parameters:
decimate = false;
final_fs = 50;

concat_params = genConcatParams(project_name,decimate, final_fs);
concat_params.noise_method = 'trials';
block_names = BlockBySubj(sbj_name,project_name);
data_sbj = ConcatenateAll(sbj_name,project_name,block_names,dirs,[],'Band','HFB','stim', concat_params);

data_all = [];
baseline_all = [];
for ii = 1:length(conds_avg_conds)
    % Initialize data_all
    data_all.(conds_avg_conds{ii}) = [];
    baseline_all.(conds_avg_conds{ii}) = [];
end

% Average 1 second of each trial per electrode
for ii = 1:length(conds_avg_conds)
    data_tmp = data_sbj.wave(strcmp(data_sbj.trialinfo.(conds_avg_field), conds_avg_conds{ii}),:,:); % average trials by electrode
    
    data_tmp_avg = nanmean(data_tmp(:,:,min(find(data_sbj.time>0)): max(find(data_sbj.time<1))),3);
    data_all.(conds_avg_conds{ii}) = data_tmp_avg; 
    
    baseline_tmp_avg = nanmean(data_tmp(:,:,min(find(data_sbj.time>-200)): max(find(data_sbj.time<0))),3);
    baseline_all.(conds_avg_conds{ii}) = baseline_tmp_avg; 
    
end

% Calculate difference between 2 conditions
for ii = 1:size(data_sbj.wave,2)
    [H,P,CI,STATS] = ttest2(data_all.(conds_avg_conds{1})(:,ii),data_all.(conds_avg_conds{2})(:,ii)); STATS.H = H; STATS.P = P; STATS.CI = CI;
    sc1c2(ii) = STATS;
    [H,P,CI,STATS] = ttest2(data_all.(conds_avg_conds{1})(:,ii),baseline_all.(conds_avg_conds{1})(:,ii)); STATS.H = H; STATS.P = P; STATS.CI = CI;
    sc1b1(ii) = STATS;
    [H,P,CI,STATS] = ttest2(data_all.(conds_avg_conds{2})(:,ii),baseline_all.(conds_avg_conds{2})(:,ii)); STATS.H = H; STATS.P = P; STATS.CI = CI;
    sc2b2(ii) = STATS;    
end

% FDR correction
sc1c2_FDR = mafdr(vertcat(sc1c2.P));
sc1b1_FDR = mafdr(vertcat(sc1b1.P));
sc2b2_FDR = mafdr(vertcat(sc2b2.P));

for i = 1:length(sc1c2_FDR)
    sc1c2(i).P_FDR = sc1c2_FDR(i);
    sc1b1(i).P_FDR = sc1b1_FDR(i);
    sc2b2(i).P_FDR = sc2b2_FDR(i);
end

% FDR correct at some point.
for ii = 1:size(data_sbj.wave,2)
    if sc1c2(ii).P_FDR <0.05 && sc1c2(ii).tstat > 0 && sc1b1(ii).P_FDR <0.05 && sc1b1(ii).tstat > 0 && sc2b2(ii).P_FDR > 0.05 
        elect_select{ii} = 'math only';
    elseif sc1c2(ii).P_FDR <0.05 && sc1c2(ii).tstat > 0 && sc1b1(ii).P_FDR <0.05 && sc1b1(ii).tstat > 0 && sc2b2(ii).P_FDR < 0.05 && sc2b2(ii).tstat > 0
        elect_select{ii} = 'math selective';
    elseif sc1c2(ii).P_FDR > 0.05 && sc1b1(ii).P_FDR <0.05 && sc1b1(ii).tstat > 0 && sc2b2(ii).P_FDR < 0.05 && sc2b2(ii).tstat > 0
        elect_select{ii} = 'math and memory';
    elseif sc1c2(ii).P_FDR <0.05 && sc1c2(ii).tstat < 0 && sc1b1(ii).P_FDR > 0.05 && sc2b2(ii).P_FDR < 0.05 && sc2b2(ii).tstat > 0
        elect_select{ii} = 'memory only';        
    elseif sc1c2(ii).P_FDR <0.05 && sc1c2(ii).tstat < 0 && sc1b1(ii).P_FDR < 0.05 && sc1b1(ii).tstat > 0 && sc2b2(ii).P_FDR < 0.05 && sc2b2(ii).tstat > 0
        elect_select{ii} = 'memory selective';         
    else
        elect_select{ii} = 'no selectivity';  
    end
    
end
% 
% ele = 30
% 
% plot(data_sbj.time, squeeze(nanmean(data_sbj.wave(strcmp(data_sbj.trialinfo.condNames, 'math'),ele,:),1))')
% hold on
% plot(data_sbj.time, squeeze(nanmean(data_sbj.wave(strcmp(data_sbj.trialinfo.condNames, 'autobio'),ele,:),1))')


% Exclude the nan values for electrodes
% native_coord = subjVar.native_coord(~isnan(subjVar.native_coord(:,1)),:);

if size(subjVar.LEPTO_coord,1) ~= size(data_sbj.wave,2)
    error('channel labels mismatch, double check ppt and freesurfer')
else
end

% Get color indices
[col_idx,colors_plot] = colorbarFromValues(data_all.(cond_plot), colormap_plot, [], true);

[DOCID,GID] = getGoogleSheetInfo('math_network', project_name);
googleSheet = GetGoogleSpreadsheet(DOCID, GID);
implant = googleSheet.implant{strcmp(googleSheet.subject_name, sbj_name)};

%% Plot electrodes as dots in native space 
marker_size = 10;
figureDim = [0 0 .4 1];
f1 = figure('units', 'normalized', 'outerposition', figureDim);
views = {'lateral', 'lateral', 'medial', 'medial', 'ventral', 'ventral'};
hemis = {'left', 'right', 'left', 'right', 'left', 'right'};
for i = 1:length(views)
    subplot(3,2,i)
    if strcmp(cortex_space, 'MNI')
        coords_plot = CorrectElecLoc(subjVar.MNI_coord, views{i}, hemis{i}, correction_factor);
        ctmr_gauss_plot(cmcortex.(hemis{i}),[0 0 0], 0, hemis{i}, views{i})        
    elseif strcmp(cortex_space, 'native')
        coords_plot = CorrectElecLoc(subjVar.LEPTO_coord, views{i}, hemis{i}, correction_factor);
        ctmr_gauss_plot(subjVar.cortex.(hemis{i}),[0 0 0], 0, hemis{i}, views{i})
    else
        error('you must specify the cortical space to plot, either MNI or native.')
    end
    

    for ii = 1:length(coords_plot)
        % Only plot on the relevant hemisphere
        if ~isnan(col_idx(ii))
            if (strcmp(hemis{i}, 'left') == 1 && coords_plot(ii,1) > 0) || (strcmp(hemis{i}, 'right') == 1 && coords_plot(ii,1) < 0)
            else
                plot3(coords_plot(ii,1),coords_plot(ii,2),coords_plot(ii,3), 'o', 'MarkerSize', marker_size, 'MarkerFaceColor', colors_plot(col_idx(ii),:), 'MarkerEdgeColor', 'k');
            end
%                 plot3(coords_plot(ii,1),coords_plot(ii,2),coords_plot(ii,3), 'o', 'MarkerSize', marker_size, 'MarkerFaceColor', colors_plot(col_idx(ii),:), 'MarkerEdgeColor', 'k');
        else
        end
    end
    if strcmp(implant, 'sEEG') || strcmp(implant, 'ECoG')
%     if strcmp(implant, 'sEEG') 
        alpha(0.5)
    else
    end
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

%     light('Position',[1 0 0])
conds_avg_conds_join = join(conds_avg_conds, '_');
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