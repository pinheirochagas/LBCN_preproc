function data_all = concatenate_multiple_elect(elec_list, dirs, datatype, freq_band, locktype)
% function data_all = concatenate_multiple_elect(elec_list, project_name, dirs, datatype, freq_band, locktype)

%% Concatenates data for multiple electrodes within or across subjects







% Define data type
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

cfg = [];
cfg.decimate = false;


data_all.trialinfo = [];
concatfields = {'wave'}; % type of data to concatenate
for ie = 1:size(elec_list,1)
    % Get concat params
    concat_params = genConcatParams(elec_list.task{ie}, cfg);
    concat_params.noise_fields_trials(3)= {'spike_hfb'};

    s = elec_list.sbj_name{ie};
    % Load subject variable
    load([dirs.original_data filesep s filesep 'subjVar_' s '.mat'])
    block_names = BlockBySubj(s,elec_list.task{ie});
    el = elec_list.chan_num(ie);
    % Concat blocks of the same electrode
    if strcmp(datatype, 'Spec')
        data_bn = concatBlocks(s,elec_list.task{ie},block_names,dirs,el,'HFB','Band',concatfields,tag);
        trialinfo = spike_detector(data_bn,el,subjVar,elec_list.task{ie});
        data_bn = concatBlocks(s,elec_list.task{ie},block_names,dirs,el,freq_band,datatype,concatfields,tag);
        data_bn.wave = data_bn.wave(:,:,find(data_bn.time == -0.2):end);
        data_bn.time = data_bn.time(find(data_bn.time == -0.2):end);
    else
        data_bn = concatBlocks(s,elec_list.task{ie},block_names,dirs,el,freq_band,datatype,concatfields,tag);
        trialinfo = spike_detector(data_bn,el,subjVar,elec_list.task{ie});
    end
    
    
    % Filter bad trials
    if strcmp(concat_params.noise_method,'timepts')
        data_bn = removeBadTimepts(data_bn,concat_params.noise_fields_timepts);
    elseif strcmp(concat_params.noise_method,'none')
        
    elseif strcmp(concat_params.noise_method,'trials')
        bad_trials = [];
        for i = 1:length(concat_params.noise_fields_trials)
            bad_trials = union(bad_trials,find(trialinfo.(concat_params.noise_fields_trials{i})));
            %             bad_trials = unique([bad_trials find(data_bn.trialinfo.spike_hfb == true)]);
            bad_trials = reshape(bad_trials,length(bad_trials),1);
        end
    end
    
    % Decimate or not
    if concat_params.decimate % smooth and downsample (optional)
        if data_bn.fsample == 999
            ds_rate = 2; % FIX THIS, it assumes fs = 1000Hz.
            data_all.fsample =concat_params.fs_targ ;
            data_all.time = data_bn.time(1:ds_rate:end);
        else
            ds_rate = floor(data_bn.fsample/concat_params.fs_targ); % FIX THIS, it assumes fs = 1000Hz.
            data_all.fsample = data_bn.fsample/ds_rate;
            data_all.time = data_bn.time(1:ds_rate:end);
        end
        if strcmp(datatype,'Band') || strcmp(datatype,'CAR')
            data_bn.wave = data_bn.wave(:,1:ds_rate:end);
        elseif strcmp(datatype,'Spec')
            data_bn.wave = data_bn.wave(:,:,1:ds_rate:end);
        end
    else
        data_all.time = data_bn.time;
        data_all.fsample = data_bn.fsample;
    end
    
    if strcmp(datatype,'Band') || strcmp(datatype,'CAR')
        % smooth
        for it = 1:size(data_bn.wave,1)
            data_bn.wave(it,:) = smooth_wave_ieeg(data_bn.wave(it,:), data_bn.fsample, 0.1);
        end
        
    elseif strcmp(datatype,'Spec')
        for it = 1:size(data_bn.wave,1)
            for itf = 1:size(data_bn.wave,1)
                data_bn.wave(it,itf,:) = smooth_wave_ieeg(data_bn.wave(it,itf,:), data_bn.fsample, 0.1);
            end
        end
    end
    
    if strcmp(datatype,'Band') || strcmp(datatype,'CAR')
        
        % Exclude bad trials
        if strcmp(concat_params.noise_method,'trials')
            data_bn.wave(bad_trials,:) = [];
            data_bn.trialinfo(bad_trials,:) = [];
        else
        end
    elseif strcmp(datatype,'Spec')
        if strcmp(concat_params.noise_method,'trials')
            data_bn.wave(:,bad_trials,:) = [];
            data_bn.trialinfo(bad_trials,:) = [];
        else
        end
    end

    
    
    
    
    % Concatenate all subjects all trials
    if strcmp(datatype,'Band') || strcmp(datatype,'CAR')
        data_all.wave{ie} = data_bn.wave;
    elseif strcmp(datatype,'Spec')
            data_all.freqs = data_bn.freqs;

        
        %% ADATP TO MEMORIA!
        if strcmp(elec_list.task{1}, 'MMR') | strcmp(elec_list.task{1}, 'UCLA')
            t_math = find(strcmp(data_bn.trialinfo.conds_math_memory, 'math'));
            t_memory = find(strcmp(data_bn.trialinfo.conds_math_memory, 'memory'));
            data_all.wave.math(ie,:,:) = squeeze(mean(data_bn.wave(:,t_math,:),2));
            data_all.wave.memory(ie,:,:) = squeeze(mean(data_bn.wave(:,t_memory,:),2));
        elseif  strcmp(strcmp(elec_list.task{1}, 'Memoria'), 'Memoria')
            t_math = find(strcmp(data_bn.trialinfo.condNames, 'math'));
            t_memory = find(strcmp(data_bn.trialinfo.condNames, 'autobio'));
            data_all.wave.math(ie,:,:) = squeeze(mean(data_bn.wave(:,t_math,:),2));
            data_all.wave.autobio(ie,:,:) = squeeze(mean(data_bn.wave(:,t_memory,:),2));
        end


%         data_all.wave(:,:,ie,:) = data_bn.wave;
    end
    
    %     data_all.label = data_bn.label;
    
    data_all.trialinfo_all{ie} = [data_bn.trialinfo];
    %     data_all.labels{ei} = data_bn.label;
    disp(['concatenating elec ',num2str(el)])
    data_all.label(ie) = subjVar.elinfo.FS_label(el); % just modified that
    data_all.subj_name{ie} = s;
    data_all.chan_num(ie) = subjVar.elinfo.chan_num(el); % just modified that
    if strcmp(concat_params.noise_method,'trials')
        data_all.bad_trials{ie} = bad_trials;
    else
    end
    
    % Exclude bad trials
    
    
    
end

end


