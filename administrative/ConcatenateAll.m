function data_all = ConcatenateAll(sbj_name, project_name, block_names, dirs,elecs, datatype, freq_band, locktype, plot_params)

tag = [locktype,'lock'];
if plot_params.blc
    tag = [tag,'_bl_corr'];
end

%% Define electrodes
if nargin < 5 || isempty(elecs)
    % load globalVar (just to get ref electrode, # electrodes)
    load([dirs.data_root,'/OriginalData/',sbj_name,'/global_',project_name,'_',sbj_name,'_',block_names{1},'.mat'])
    elecs = setdiff(1:globalVar.nchan,globalVar.refChan);
end


%% loop through electrodes
data_all.trialinfo = [];


for ei = 1:length(elecs)
    el = elecs(ei);
    data_bn.wave = [];
    data_bn.trialinfo = [];
    %     column_data = cell(1,length(columns_to_keep));
    for bi = 1:length(block_names)
        bn = block_names{bi};
        
        % Load data
        dir_in = [dirs.data_root,filesep,datatype,'Data',filesep,freq_band,filesep,sbj_name,filesep,bn,filesep,'EpochData'];
        load(sprintf('%s/%siEEG_%s_%s_%.2d.mat',dir_in,freq_band,tag,bn,el));
        
        % Remove bad indices
        data = removeBadTimepts(data,plot_params.noise_fields_timepts);
        
        % concatenante EEG data
        if strcmp(datatype,'Spec')
            data_bn.wave = cat(2,data_bn.wave,data.wave);
        else
            data_bn.wave = cat(1,data_bn.wave,data.wave);
        end
        
        % Remove bad time points
        
        % concatenate trial info
        data_bn.trialinfo = [data_bn.trialinfo; data.trialinfo];
        
    end
    
    data_bn.time = data.time;
    data_bn.fsample = data.fsample;
    data_bn.label = data.label;
    
    % Concatenate all subjects all trials
    if strcmp(datatype,'Band')
        data_all.wave(:,ei,:) = data_bn.wave;
    elseif strcmp(datatype,'Spec')
        data_all.wave(:,:,ei,:) = data_bn.wave;
    end
    
    data_all.trialinfo{ei} = [data_bn.trialinfo];
    data_all.labels{ei} = data.label;
end

% Concatenate bad channels
badChan = [];
for bi = 1:length(block_names)
    % Load globalVar
    load([dirs.data_root,'/OriginalData/',sbj_name,'/global_',project_name,'_',sbj_name,'_',block_names{bi},'.mat'])
    badChan = [globalVar.badChan badChan];
end
% Finalize
data_all.time = data.time;
data_all.fsample = data.fsample;
data_all.badChan = unique(badChan);
data_all.project_name = project_name;

% Exlude bad channels and organize trialinfo
if strcmp(datatype,'Band')
    data_all.wave(:,data_all.badChan,:) = [];
else
    data_all.wave(:,:,data_all.badChan,:) = [];
end
data_all.labels(data_all.badChan) = [];
data_all.trialinfo = data_all.trialinfo{1};
data_all.trialinfo = data_all.trialinfo(:,~contains(data_all.trialinfo.Properties.VariableNames, 'bad'));
% data_all = rmfield(data_all, 'badChan');
end




