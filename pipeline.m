% Branch 1. basic config - PEDRO
AddPaths('Pedro_iMAC')
% Manually edit this function to include the name of the blocks:
% BlockBySubj

%% Copy the data from the server

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
SaveDataNihonKohden(sbj_name, project_name, block_names, dirs, [], [])

%% Branch 3 - event identifier 
EventIdentifier(sbj_name, project_name, block_names, dirs) % maybe project dependent

%% Branch 4 - bad channel rejection
BadChanReject(sbj_name, project_name, block_names, dirs) 

%% Branch 5 - epoching and identification of bad epochs
lockevent = trailinfo.allonsets(:,1); % e.g. lock to stim onset
lockevent = trailinfo.RT_lock; % e.g. lock to RT

epoch_data 
get_bad_epochs_calculia_production

%% Branch 6 - time-frequency analyses - AMY
%substitute for wavelet filter 
data.wave   (freq x time)
	.fsample
	.time
	.label


% change output to fildtrip 
data.wave  (1 x time)
	.fsample
	.time
	.label

% Branch 3 - cleaning - AMY 
get_bad_epochs_calculia_production
% add su' method


% Branch 5 - epoching - AMY
% to be added
epoched
data.wave (freq x trial x time)
	.trialinfo (Pedro will provide code to convert to table)
	.fsample
	.time
	.label

epoched
data.wave (trial x time) - non decomposed
	.trialinfo (Pedro will provide code to convert to table)
	.fsample
	.time
	.label    
    
% Branch 6 - plotting OY AND YO
GammaAvg_calculia_production


%% Medium-long term projects
% 1. Creat subfunctions of the EventIdentifier specific to each project




% 2. Stimuli identity to TTL 
