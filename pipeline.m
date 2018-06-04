%% Branch 1. basic config - PEDRO
AddPaths('Pedro_iMAC')
parpool(16) % initialize number of cores

%% Initialize Directories
project_name = 'Calculia_production';
project_name = 'MMR';
dirs = InitializeDirs('Pedro_iMAC', project_name);

%% Create folders
sbj_name = 'S18_124';
sbj_name = 'S18_124_JR2'; % Why some subjects have these additional letters? 
sbj_name = 'S14_64_SP';

block_names = BlockBySubj(sbj_name,project_name);
% Manually edit this function to include the name of the blocks:

% retrieve data format
data_format = 'nihon_kohden';

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
empty_chan = []; % Do we need that? 
if strcmp(data_format, 'edf')
    SaveDataNihonKohden(sbj_name, project_name, block_names, dirs, ref_chan, epi_chan) %
elseif strcmp(data_format, 'nihon_kohden')
    SaveDataDecimate(sbj_name, project_name, block_names, dirs, ref_chan, epi_chan) %
else
    error('Data format has to be either edf or nihon_kohden') 
end

%% Branch 3 - event identifier
% For each class of tasks:
EventIdentifier(sbj_name, project_name, block_names, dirs) % maybe project dependent
% Make sure there is no nan in the last event (which in MMR is critical, since there is only one event per trial)
% Multiply pdio by -1?
% input the number of initial pulses - GET FUNCTION FROM YING.


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

%% Branch 6 - Epoching and identification of bad epochs
% Bad epochs identification
%      Step 1. based on the raw signal
%      Step 2. based on the spikes in the raw signal
%      Step 3. based on the spikes in the HFB signal
bl_correct.run = 'baseline_correct'; % or 'no_baseline_correct'
bl_correct.lockevent = 'stim';
bl_correct.window = [-.2 0];
bl_correct.noise_method = 'timestmps';


parfor i = 1:length(block_names)
%     EpochDataAll(sbj_name, project_name, block_names{i}, dirs,[],'stim', [], 5, 'HFB', [],[])
    EpochDataAll(sbj_name, project_name, block_names{i}, dirs,[],'stim', [], 5, 'Spec', [],[])
end

EpochDataAll(sbj_name, project_name, block_names, dirs,[],'stim', [], 6, 'HFB', [],[], bl_correct)
EpochDataAll(sbj_name, project_name, block_names, dirs,[],'resp', -6, 1, 'HFB', [],[], bl_correct)
% Baseline correction option

%% Branch 7 - plotting OY AND YO
plot_params = [];
plot_params.smooth =

PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','conds_addsub',[],[],'none',[])
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','resp','conds_addsub',[],[],'none',[])
%%%%%%%%%%%%%%%%%%%%
% Baseline correction has always to consider the stim lock, not the resp
% lock!
%%%%%%%%%%%%%%%%%%%%%%
% Allow conds to be any kind of class, logical, str, cell, double, etc.
% Input baseline correction flag to have the option.
% Include the lines option
%%%%%%%%%%%%%%%%%%%%%%%

PlotERSPAll(sbj_name,project_name,block_names,dirs,105,'stim','conds_addsub',[],'none',[])
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


%% Branch 6 - time-frequency analyses - AMY
%substitute for wavelet filter
% data.wave   (freq x time)
% 	.fsample
% 	.time
% 	.label


% change output to fildtrip
% data.wave  (1 x time)
% 	.fsample
% 	.time
% 	.label

% Branch 3 - cleaning - AMY
get_bad_epochs_calculia_production
% add su' method


% Branch 5 - epoching - AMY
% to be added
% epoched
% data.wave (freq x trial x time)
% 	.trialinfo (Pedro will provide code to convert to table)
%         trialinfo.bad_trial: 0 for bad and 1 for good.
% 	.fsample
% 	.time
% 	.label
%
% epoched
% data.wave (trial x time) - non decomposed
% 	.trialinfo (Pedro will provide code to convert to table)
% 	.fsample
% 	.time
% 	.label



%% Medium-long term projects
% 1. Creat subfunctions of the EventIdentifier specific to each project




% 2. Stimuli identity to TTL
