function data_all = ConcatenateAvgTrials(sbj_names,project_name, conds_avg_field, conds_avg_conds,concat_params, bad_chan_reject, dirs)

%% Avg task
% conditions to average
data_all.wave = [];
for ii = 1:length(conds_avg_conds)
    % Initialize data_all
    data_all.wave.(conds_avg_conds{ii}) = [];
end

%% Group data
data_all.MNI_coord = [];
data_all.native_coord = [];
data_all.subjects = [];
 
for i = 1:length(sbj_names)
    disp(['concatenating subject ' sbj_names{i}])
    %% Concatenate trials from all blocks
    block_names = BlockBySubj(sbj_names{i},project_name);
    data_sbj = ConcatenateAll(sbj_names{i},project_name,block_names,dirs,[],'Band','HFB','stim', concat_params);
    % Average across trials, normalize and concatenate across subjects
    for ii = 1:length(conds_avg_conds)
%         data_tmp_avg = squeeze(nanmean(data_sbj.wave(strcmp(data_sbj.trialinfo.(conds_avg_field), conds_avg_conds{ii}),:,:),1)); % average trials by electrode
        data_tmp_avg = squeeze(trimmean(data_sbj.wave(strcmp(data_sbj.trialinfo.(conds_avg_field), conds_avg_conds{ii}),:,:),10,1)); % average trials by electrode
        
        data_all.wave.(conds_avg_conds{ii}) = [data_all.wave.(conds_avg_conds{ii});data_tmp_avg]; % concatenate across subjects
        % Reject bad channels
        if bad_chan_reject
            data_all.wave.(conds_avg_conds{ii})(data_sbj.badChan,:) = [];
        else
        end
        
    end
    
    %% Concatenate channel coordinates
    % Load subjVar and add additional info
    load([dirs.original_data filesep sbj_names{i} filesep 'subjVar_' sbj_names{i} '.mat']);
    if size(subjVar.MNI_coord,1) ~= size(data_sbj.wave,2)
        error('channel labels mismatch, double check ppt and freesurfer')
    else
    end
    
    MNI_coords = subjVar.MNI_coord;
    native_coords = subjVar.native_coord;
    elect_names = subjVar.elect_names;
    subjects_tmp = cellstr(repmat(sbj_names{i}, size(data_sbj.wave,2),1));

    if bad_chan_reject
        MNI_coords(data_sbj.badChan,:) = [];
        elect_names(data_sbj.badChan) = [];
        subjects_tmp(data_sbj.badChan) = [];
        native_coords(data_sbj.badChan,:) = [];
    else
    end
    
    data_all.MNI_coord = [data_all.MNI_coord;MNI_coords]; % concatenate electrodes across subjects
    data_all.native_coord = [data_all.native_coord;native_coords]; % concatenate electrodes across subjects
    data_all.elec_names{i} = elect_names;
    data_all.subjects = vertcat(data_all.subjects,subjects_tmp);
    
    if bad_chan_reject == false
        data_all.badchans{i} = data_sbj.badChan;
    else
    end
   
end
data_all.time = data_sbj.time;

end



