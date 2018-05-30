% Branch 1. basic config - PEDRO
AddPaths('Pedro_iMAC')
% Manually edit this function to include the name of the blocks:
% BlockBySubj

%% Copy the data from the server
% EDF file to 

%% Initialize Directories
project_name = 'Calculia_production';
dirs = InitializeDirs('Pedro_iMAC', project_name);

%% Create folders
sbj_name = 'S18_124';
block_names = BlockBySubj(sbj_name,project_name); 
CreateFolders(sbj_name, project_name, block_names, dirs) 
% this creates the fist instance of globalVar which is going to be 
% updated at each step of the preprocessing accordingly

%% Branch 2 - data conversion - PEDRO
ref_chan = [];
epi_chan = [];
SaveDataNihonKohden(sbj_name, project_name, block_names, dirs, ref_chan, epi_chan) %

%% Branch 3 - event identifier 
% For each class of tasks: 
EventIdentifier(sbj_name, project_name, block_names, dirs) % maybe project dependent
% RT from voice in case
%   plug the voice RT to the trailinfo

%% Branch 4 - bad channel rejection 
% 1. Continuous data
%      Step 0. epileptic channels based on clinical evaluation (manually inputed in the SaveDataNihonKohden)
%      Step 1. based on the raw power
%      Step 2. based on the spikes in the raw signal
%      Step 3. based on the power spectrum deviation
BadChanReject(sbj_name, project_name, block_names, dirs) 

%% Branch 5 - Time-frequency analyses - AMY
% Creates the first instance of data structure 
WaveletFilterAll(sbj_name, project_name, block_names, dirs, [], 'HFB', [], [], [], []) % only for HFB
WaveletFilterAll(sbj_name, project_name, block_names, dirs, [], [], [], [], true, false) % across frequencies of interest


%% Branch 6 - Epoching and identification of bad epochs
% Bad epochs identification
%      Step 1. based on the raw signal
%      Step 2. based on the spikes in the raw signal
%      Step 3. based on the spikes in the HFB signal

EpochDataAll(sbj_name, project_name, block_names, dirs,[],'stim', [], 5, 'HFB', [],[])

%% Branch 7 - plotting OY AND YO
for i = 1:elect
[data()] = LoadDataAnalyze(subj, etc);
end
data.mni_coordinates
data.native_coordinates

GammaAvg_calculia_production (data, clomun)


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
