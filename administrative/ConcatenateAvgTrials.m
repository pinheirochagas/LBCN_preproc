function data_all = ConcatenateAvgTrials(sbj_names,project_name, conds_avg_field, conds_avg_conds,concat_params, dirs)

%% Avg task
% conditions to average
data_all = [];
for ii = 1:length(conds_avg_conds)
    % Initialize data_all
    data_all.(conds_avg_conds{ii}) = [];
end

%% Group data
plot_params = genPlotParams(project_name,'timecourse');
chan_plot = [];
for i = 1:length(sbj_names)
    disp(['concatenating subject ' sbj_names{i}])
    %% Concatenate trials from all blocks
    block_names = BlockBySubj(sbj_names{i},project_name);
    data_sbj = ConcatenateAll(sbj_names{i},project_name,block_names,dirs,[],'Band','HFB','stim', concat_params);
    % Average across trials, normalize and concatenate across subjects
    for ii = 1:length(conds_avg_conds)
%         data_tmp_avg = squeeze(nanmean(data_sbj.wave(strcmp(data_sbj.trialinfo.(conds_avg_field), conds_avg_conds{ii}),:,:),1)); % average trials by electrode
        data_tmp_avg = squeeze(trimmean(data_sbj.wave(strcmp(data_sbj.trialinfo.(conds_avg_field), conds_avg_conds{ii}),:,:),10,1)); % average trials by electrode
        
        data_all.(conds_avg_conds{ii}) = [data_all.(conds_avg_conds{ii});data_tmp_avg]; % concatenate across subjects
    end
    
    %% Concatenate channel coordinates
    % Load subjVar
    if exist([dirs.original_data filesep sbj_names{i} filesep 'subjVar_' sbj_names{i} '.mat'], 'file')
        load([dirs.original_data filesep sbj_names{i} filesep 'subjVar_' sbj_names{i} '.mat']);
    else
        warning('no subjVar, trying to create it')
        center = 'Stanford';
        fsDir_local = '/Applications/freesurfer/subjects/fsaverage';
        [fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_names{i}, center);
        subjVar = CreateSubjVar(sbj_names{i}, dirs, data_format, fsDir_local);
    end
    chan_plot = [chan_plot;subjVar.MNI_coord]; % concatenate electrodes across subjects
    if size(subjVar.MNI_coord,1) ~= size(data_sbj.wave,2) 
        error('channel labels mismatch, double check ppt and freesurfer')
    else
    end
end
data_all.chan_plot = chan_plot;


end



