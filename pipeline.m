%% Branch 1. basic config - PEDRO
AddPaths('Pedro_iMAC')
parpool(16) % initialize number of cores

%% Initialize Directories
project_name = 'Calculia_production';
project_name = 'MMR';
project_name = 'Memoria';

dirs = InitializeDirs('Pedro_iMAC', project_name);

%% Create folders
sbj_name = 'S18_124';
sbj_extended_name = 'S18_124_JR2'; % Why some subjects have these additional letters?
sbj_name = 'S14_69b_RT';
sbj_name = 'S14_64_SP';
sbj_extended_name = 'S14_64_SP';


block_names = BlockBySubj(sbj_name,project_name);
% Manually edit this function to include the name of the blocks:

% retrieve data format
data_format = 'TDT';
data_format = 'edf';

CreateFolders(sbj_name, project_name, block_names, dirs)
% this creates the fist instance of globalVar which is going to be
% updated at each step of the preprocessing accordingly



%% Copy the iEEG and behavioral files from server to local folders
% Login to the server first?
% Should we rename the channels at this stage to match the new naming?
% This would require a table with chan names retrieved from the PPT
parfor i = 1:length(block_names)
    CopyFilesServer(sbj_extended_name,project_name,block_names{i},data_format,dirs)
end


%% Branch 2 - data conversion - PEDRO
ref_chan = [];
epi_chan = [];
empty_chan = []; % INCLUDE THAT in SaveDataNihonKohden SaveDataDecimate
if strcmp(data_format, 'edf')
    SaveDataNihonKohden(sbj_name, project_name, block_names, dirs, ref_chan, epi_chan, empty_chan) %
elseif strcmp(data_format, 'nihon_kohden')
    SaveDataDecimate(sbj_name, project_name, block_names, fs, dirs, ref_chan, epi_chan, empty_chan) %
else
    error('Data format has to be either edf or nihon_kohden')
end

% Convert berhavioral data to trialinfo
OrganizeTrialInfoMMR(sbj_name, project_name, block_names, dirs)
OrganizeTrialInfoMemoria(sbj_name, project_name, block_names, dirs)

%%% FIX TIMING OF REST AND CHECK ACTUAL TIMING WITH PHOTODIODE!!! %%%

%%Plug into OrganizeTrialInfoCalculiaProduction, OrganizeTrialInfoNumberConcatActive, OrganizeTrialInfoCalculiaEBS

%% Segment audio from mic
% adapt: segment_audio_mic
switch project_name
    case 'Calculia_EBS'
    case 'Calculia_production'
        load(sprintf('%s/%s_%s_slist.mat',globalVar.psych_dir,sbj_name,bn))
        K.slist = slist;
end
%%%%%%%%%%%%%%%%%%%%%%%

%% Branch 3 - event identifier
EventIdentifier(sbj_name, project_name, block_names, dirs)


%% Branch 4 - bad channel rejection
% 1. Continuous data
%      Step 0. epileptic channels based on clinical evaluation (manually inputed in the SaveDataNihonKohden)
%      Step 1. based on the raw power
%      Step 2. based on the spikes in the raw signal
%      Step 3. based on the power spectrum deviation
BadChanReject(sbj_name, project_name, block_names, dirs)
% Creat a diagnostic panel unifying all the figures

%% Branch 5 - Time-frequency analyses - AMY
% Creates the first instance of data structure
parfor i = 1:length(block_names)
    WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, [], 'HFB', [], [], [], []) % only for HFB
    WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, [], 'Spec', [], [], true, false) % across frequencies of interest
end

%% Branch 6 - Epoching, identification of bad epochs and baseline correction
% Bad epochs identification
%      Step 1. based on the raw signal
%      Step 2. based on the spikes in the raw signal
%      Step 3. based on the spikes in the HFB signal
blc_params.run = true; % or false
blc_params.locktype = 'stim';
blc_params.win = [-.2 0];

parfor i = 1:length(block_names)
    EpochDataAll(sbj_name, project_name, block_names{i}, dirs,[],'stim', [], 5, 'HFB', [],[], blc_params)
    EpochDataAll(sbj_name, project_name, block_names{i}, dirs,[],'stim', [], 5, 'Spec', [],[], blc_params)
end

parfor i = 1:length(block_names)
    EpochDataAll(sbj_name, project_name, block_names{i}, dirs,[],'resp', -5, 1, 'HFB', [],[], blc_params)
    EpochDataAll(sbj_name, project_name, block_names{i}, dirs,[],'resp', -5, 1, 'Spec', [],[], blc_params)
end

% DONE PREPROCESSING. 
% Eventually replace globalVar to update dirs in case of working from an
% with an external hard drive
UpdateGlobalVarDirs(sbj_name, project_name, block_name, dirs)

%% Branch 7 - plotting OY AND YO
x_lim = [-.2 2];

PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','conds_addsub',[],[],'trials',[],x_lim)
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','resp','conds_addsub',[],[],'none',[],x_lim)

PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','conds_math_memory',[],[],'trials',[],x_lim)

PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',[],[],'trials',[],x_lim)


% Allow conds to be any kind of class, logical, str, cell, double, etc.
% Input baseline correction flag to have the option.
% Include the lines option

PlotERSPAll(sbj_name,project_name,block_names,dirs,39,'stim','condNames',[],'trials',[])
% cbrewer 2. FIX


%% Branch 8 - integrate brain and electrodes location MNI and native and other info
% Lin's help
% Save to globalVar

% demographics
% date of implantation
% birth data
% age
% gender
% handedness
% IQ full
% IQ verbal
% ressection?


%% Medium-long term projects
% 1. Creat subfunctions of the EventIdentifier specific to each project


% 2. Stimuli identity to TTL


