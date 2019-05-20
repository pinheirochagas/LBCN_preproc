function data_all = ConcatenateAll(sbj_name, project_name, block_names, dirs,elecs, datatype, freq_band, locktype, concat_params)
%% Define electrodes
if isempty(elecs)
    % load globalVar (just to get ref electrode, # electrodes)
    load([dirs.original_data, filesep, sbj_name,'/global_',project_name,'_',sbj_name,'_',block_names{1},'.mat'])    
    elecs = setdiff(1:globalVar.nchan,globalVar.refChan);
end
if isempty(concat_params)
    concat_params = genConcatParams(false); % default: no downsampling
end

% Load subjectVar
load([dirs.original_data filesep sbj_name filesep 'subjVar_' sbj_name '.mat'])


if strcmp(datatype,'Spec')
    tdim = 4; % time dimension after concatenating
    tag = [locktype,'lock_bl_corr']; % specifies type of data to load

elseif strcmp(datatype,'Band')
    tdim = 3;
    tag = [locktype,'lock_bl_corr']; % specifies type of data to load
elseif strcmp(datatype,'CAR')
    tdim = 3;
    tag = [locktype,'lock']; % specifies type of data to load
end
%% loop through electrodes
data_all.trialinfo = [];
concatfields = {'wave'}; % type of data to concatenate

for ei = 1:length(elecs)
    el = elecs(ei);

    data_bn = concatBlocks(sbj_name,project_name,block_names,dirs,el,freq_band,datatype,concatfields,tag);
    
    if strcmp(concat_params.noise_method,'timepts')
        data_bn = removeBadTimepts(data_bn,concat_params.noise_fields_timepts);
    elseif strcmp(concat_params.noise_method,'none')
    else
        bad_trials = [];
        for i = 1:length(concat_params.noise_fields_trials)
            bad_trials = union(bad_trials,find(data_bn.trialinfo.(concat_params.noise_fields_trials{i})));
        end
        if strcmp(datatype,'Band') || strcmp(datatype,'CAR')
            data_bn.wave(bad_trials,:) = NaN;
        else
            data_bn(bad_trials,:,:) = NaN;
        end
    end
    
    if concat_params.decimate % smooth and downsample (optional)
        ds_rate = floor(data_bn.fsample/concat_params.fs_targ); % FIX THIS, it assumes fs = 1000Hz. 
        data_all.fsample = data_bn.fsample/ds_rate;
        data_all.time = data_bn.time(1:ds_rate:end);
        if concat_params.sm_win > 0 % if smoothing first
            winSize = floor(data_bn.fsample*concat_params.sm_win);
            gusWin= gausswin(winSize)/sum(gausswin(winSize));
            data_bn.wave = convn(data_bn.wave,shiftdim(gusWin,-tdim),'same'); % convolve data w/gaussian along time dimension
        else
        end
        % downsample
        if strcmp(datatype,'Band') || strcmp(datatype,'CAR')
            data_bn.wave = data_bn.wave(:,1:ds_rate:end);
        elseif strcmp(datatype,'Spec')
            data_bn.wave = data_bn.wave(:,:,1:ds_rate:end);
        end
        
    else
        data_all.time = data_bn.time;
        data_all.fsample = data_bn.fsample;
    end
    
    % Concatenate all subjects all trials
    if strcmp(datatype,'Band') || strcmp(datatype,'CAR')
        data_all.wave(:,ei,:) = data_bn.wave;   
    elseif strcmp(datatype,'Spec')
        data_all.wave(:,:,ei,:) = data_bn.wave;
    end
    
%     data_all.label = data_bn.label;
    
    data_all.trialinfo = [data_bn.trialinfo];
    data_all.trialinfo_all{el} = [data_bn.trialinfo];
%     data_all.labels{ei} = data_bn.label;
    disp(['concatenating elec ',num2str(el)])
end


%% Correct for the actual recorded channels
nchan_fs = size(subjVar.elinfo,1);
in_chan_cmp = false(1,nchan_fs);
for i = 1:nchan_fs
    in_chan_cmp(i) = ismember(subjVar.elinfo.FS_label(i),globalVar.channame);
end

nchan_cmp = size(globalVar.channame,2);
in_fs = false(1,nchan_cmp);
for i = 1:nchan_cmp
    in_fs(i) = ismember(globalVar.channame(i),subjVar.elinfo.FS_label);
end


data_all.wave = data_all.wave(:, in_fs, :);
data_all.trialinfo_all = data_all.trialinfo_all(in_fs);
data_all.label = subjVar.elinfo.FS_label;

% Concatenate bad channels
badChan = [];
for bi = 1:length(block_names)
    % Load globalVar
    load([dirs.data_root,'/OriginalData/',sbj_name,'/global_',project_name,'_',sbj_name,'_',block_names{bi},'.mat'])
    badChan = [globalVar.badChan badChan];
end
% Finalize
% data_all.time = data.time;
% data_all.fsample = data.fsample;
data_all.badChan = unique(badChan);
data_all.project_name = project_name;

if isfield(concat_params, 'fieldtrip') && concat_params.fieldtrip
    
    % Reshape to trials and then channelsXtimes
    for i = 1:size(data_all.wave,1)
        waveOrg{i} = squeeze(data_all.wave(i,:,:));
    end
    
    data_all.trial =  waveOrg;
    data_all = rmfield(data_all, 'wave');
    data_all = rmfield(data_all, 'badChan');
    data_all = rmfield(data_all, 'project_name');
    data_all = rmfield(data_all, 'trialinfo_all');
    
    trialinfo = data_all.trialinfo.int_cue_targ_time; % be carefull with that, simple solution for EglyDriver, only including one column
    time = data_all.time;
    ntrials = size(data_all.trialinfo,1);
    data_all =  rmfield(data_all, 'trialinfo');
    data_all =  rmfield(data_all, 'time');
    
    for i = 1:ntrials
        data_all.trialinfo{i} = trialinfo;
        data_all.time{i} = time;
    end
    
    data_all.label = data_all.label';
       
else
    
end



end

