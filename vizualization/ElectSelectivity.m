function elect_select = ElectSelectivity(sbj_name,project_name, conds_avg_field, conds_avg_conds, dirs)

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

% Get average parameters
switch project_name
    case 'MMR'
        avg_init = 0;
        avg_end = 1;
        bs_init = -0.200;
        bs_end = 0;        
    case 'Memoria'
        event_onsets = [0 cumsum(nanmean(diff(data_sbj.trialinfo.allonsets,1,2)))];
        avg_init = event_onsets(3);
        avg_end = event_onsets(4);
        bs_init = -0.500;
        bs_end = 0;        
end



for ii = 1:length(conds_avg_conds)
    data_tmp = data_sbj.wave(strcmp(data_sbj.trialinfo.(conds_avg_field), conds_avg_conds{ii}),:,:); % average trials by electrode
    
    data_tmp_avg = nanmean(data_tmp(:,:,min(find(data_sbj.time>avg_init)): max(find(data_sbj.time<avg_end))),3);
    data_all.(conds_avg_conds{ii}) = data_tmp_avg; 
    
    baseline_tmp_avg = nanmean(data_tmp(:,:,min(find(data_sbj.time>bs_init)): max(find(data_sbj.time<bs_end))),3);
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
