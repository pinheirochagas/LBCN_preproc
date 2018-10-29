% function data_all = ConcatenateAll(sbj_name, project_name, block_names, dirs,elecs, datatype, locktype, plot_params)
function data_all = ConcatenateAll(sbj_name, project_name, block_names, dirs,elecs, datatype, freq_band, locktype, plot_params)
% EpochDataAll(sbj_name, project_name, bn, dirs,el,freq_band,thr_raw,thr_diff,epoch_params,datatype)

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
%         dir_in = [dirs.data_root,'/',datatype,'Data/',sbj_name,'/',bn,'/EpochData/'];
        dir_in = [dirs.data_root,filesep,datatype,'Data',filesep,freq_band,filesep,sbj_name,filesep,bn,filesep,'EpochData',filesep];
        % Load data
        if plot_params.blc
            load(sprintf('%s/%siEEG_%slock_bl_corr_%s_%.2d.mat',dir_in,freq_band,locktype,bn,el))
        else
            load(sprintf('%s/%siEEG_%slock_%s_%.2d.mat',dir_in,freq_band,locktype,bn,el));
        end
        
        % concatenante EEG data
        if strcmp(datatype,'Spec')
            data_bn.wave = cat(2,data_bn.wave,data.wave);
        else
            data_bn.wave = cat(1,data_bn.wave,data.wave);
        end
        
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
    disp(['concatenating elec ',num2str(el)])
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
end

