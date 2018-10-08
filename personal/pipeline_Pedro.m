%% Branch 1. basic config - PEDRO
AddPaths('Pedro_iMAC')

parpool(16) % initialize number of cores

%% Initialize Directories
project_name = 'MMR'; 
project_name = 'UCLA';

project_name = 'MFA';
project_name = '7Heaven';

project_name = 'Scrambled';
project_name = 'Logo';
project_name = 'VTC_localizer';
project_name = 'Animal_localizer';

project_name = 'Calculia';
project_name = 'Context';

project_name = 'Memoria';

project_name = 'Calculia_production';
project_name = 'Calculia_China';

project_name = 'Number_comparison';

project_name = 'Flanker';
project_name = 'EglyDriver';
project_name = 'NumLet';
project_name = 'GradCPT';


%% Retrieve subject information
[DOCID,GID] = getGoogleSheetInfo(project_name);
googleSheet = GetGoogleSpreadsheet(DOCID, GID);
sbj_number = 17;
sbj_name = googleSheet.subject_name{sbj_number};
% sbj_name = 'S18_124';
% sbj_name = 'S18_127';

% sbj_name = 'S14_69b_RT';
% sbj_name = 'S14_64_SP';
% sbj_name = 'S13_57_TVD';
% sbj_name = 'S11_29_RB';
% sbj_name = 'S12_42_NC';
% sbj_name = 'S13_55_JJC';
% sbj_name = 'S18_126';
% sbj_name = 'S18_129';

% sbj_name = 'G18_19';
% sbj_name = 'G18_19';
% sbj_name = 'G18_21';

% sbj_name = 'S17_116';

% sbj_name = 'S16_94_DR';


% Center
% center = 'China'; or Stanford 
%center = 'Stanford'; 

center = googleSheet.center{sbj_number};

%% Get block names
block_names = BlockBySubj(sbj_name,project_name);
% Manually edit this function to include the name of the blocks:

% Make sure your are connected to CISCO and logged in the server
dirs = InitializeDirs('Pedro_iMAC', project_name, sbj_name); % 'Pedro_NeuroSpin2T'


%% Get iEEG and Pdio sampling rate and data format
[fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_name, center);

%% Create subject folders
CreateFolders(sbj_name, project_name, block_names, center, dirs, data_format, 1) 

%%% IMPROVE uigetfile to go directly to subject folder %%%

% this creates the fist instance of globalVar which is going to be
% updated at each step of the preprocessing accordingly
% At this stage, paste the EDF or TDT files into the originalData folder
% and the behavioral files into the psychData
% (unless if using CopyFilesServer, which is still under development)

%% Get marked channels and demographics
% [refChan, badChan, epiChan, emptyChan] = GetMarkedChans(sbj_name);
ref_chan = [];
epi_chan = [];
empty_chan = []; % INCLUDE THAT in SaveDataNihonKohden SaveDataDecimate
%LK 65 105 119 117 106 71 118 67 107 81 66 103 108 37 70 115 80 84 51 83 59 69 60 112 38 54 56 36 91 43 116 113 41 57 35 110 75 73 72 29 47 88 53 102 49 87 120 68 34 39 33 45 52 82 64 50 86 61 109 48 104 62 114 98 93 99 121 78 79 100 101 90 92 63 122 76 111 46 58 44 55 40 97 96 74 42 77 95 85 8 7 5 4


%% Copy the iEEG and behavioral files from server to local folders
% Login to the server first?
% Should we rename the channels at this stage to match the new naming?
% This would require a table with chan names retrieved from the PPT
parfor i = 1:length(block_names)
    CopyFilesServer(sbj_name,project_name,block_names{i},data_format,dirs)
end
% In the case of number comparison, one has also to copy the stim lists


%% Branch 2 - data conversion - PEDRO
if strcmp(data_format, 'edf')
    SaveDataNihonKohden(sbj_name, project_name, block_names, dirs, ref_chan, epi_chan, empty_chan) %
elseif strcmp(data_format, 'TDT')
    SaveDataDecimate(sbj_name, project_name, block_names, fs_iEEG, fs_Pdio, dirs, ref_chan, epi_chan, empty_chan) %% DZa 3051.76
else
    error('Data format has to be either edf or TDT format')
end

%% Convert berhavioral data to trialinfo
switch project_name
    case 'Calculia_SingleDigit'
%         OrganizeTrialInfoMMR(sbj_name, project_name, block_names, dirs) %%% FIX TIMING OF REST AND CHECK ACTUAL TIMING WITH PHOTODIODE!!! %%%
        OrganizeTrialInfoCalculia(sbj_name, project_name, block_names, dirs) %%% FIX ISSUE WITH TABLE SIZE, weird, works when separate, loop clear variable issue
    case 'UCLA'
        OrganizeTrialInfoUCLA(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds? INCLUDE REST!!!
    case 'MMR'
%         OrganizeTrialInfoMMR(sbj_name, project_name, block_names, dirs) %%% FIX TIMING OF REST AND CHECK ACTUAL TIMING WITH PHOTODIODE!!! %%%
        OrganizeTrialInfoMMR_rest(sbj_name, project_name, block_names, dirs) %%% FIX ISSUE WITH TABLE SIZE, weird, works when separate, loop clear variable issue
    case 'Memoria'
        OrganizeTrialInfoMemoria(sbj_name, project_name, block_names(2), dirs)
    case 'Calculia_China'
        OrganizeTrialInfoCalculiaChina(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case 'Calculia_production'
        OrganizeTrialInfoCalculia_production(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?
    case 'Number_comparison'
        OrganizeTrialInfoNumber_comparison(sbj_name, project_name, block_names, dirs) % FIX 1 trial missing from K.conds?        
end


% segment_audio_mic(sbj_name,project_name, dirs, block_names{1}) 


% ADD segment_audio_mic

%Plug into OrganizeTrialInfoCalculiaProduction
%OrganizeTrialInfoNumberConcatActive
%OrganizeTrialInfoCalculiaEBS
% %% Segment audio from mic
% % adapt: segment_audio_mic
% switch project_name
%     case 'Calculia_EBS'
%     case 'Calculia_production'
%         load(sprintf('%s/%s_%s_slist.mat',globalVar.psych_dir,sbj_name,bn))
%         K.slist = slist;
% end
% %%%%%%%%%%%%%%%%%%%%%%%

%% Branch 3 - event identifier
if strcmp(project_name, 'Number_comparison')
    event_numcomparison_current(sbj_name, project_name, block_names, dirs, 9) %% MERGE THIS
else
    EventIdentifier(sbj_name, project_name, block_names, dirs, 2, 0) % new ones, photo = 1; old ones, photo = 2; china, photo = varies, depends on the clinician, normally 9.
end
% Fix it for UCLA
% subject 'S11_29_RB' exception = 1 for block 2 


%% Branch 4 - bad channel rejection
BadChanRejectCAR(sbj_name, project_name, block_names, dirs)
% 1. Continuous data
%      Step 0. epileptic channels based on clinical evaluation from table_.xls
%      Step 1. based on the raw power
%      Step 2. based on the spikes in the raw signal
%      Step 3. based on the power spectrum deviation
%      Step 4. Bad channel detection based on HFOs

% Creates the first instance of data structure inside car() function
% TODO: Create a diagnostic panel unifying all the figures

%% Branch 5 - Time-frequency analyses
% Load elecs info
load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,block_names{1}),'globalVar');
elecs = setdiff(1:globalVar.nchan,globalVar.refChan);

for i = 1:length(block_names)
    parfor ei = 1:length(elecs)
        WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei), 'HFB', [], [], [], 'Band') % only for HFB
        WaveletFilterAll(sbj_name, project_name, block_names{i}, dirs, elecs(ei), 'SpecDense', [], [], true, 'Spec') % across frequencies of interest
    end
end

%% Branch 6 - Epoching, identification of bad epochs and baseline correction
epoch_params = genEpochParams(project_name, 'stim'); 

for i = 1:length(block_names)
    bn = block_names{i};
    parfor ei = 1:length(elecs) 
        EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'HFB', [],[], epoch_params,'Band')
        EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'SpecDense', [],[], epoch_params,'Spec')
    end
end

% epoch_params = genEpochParams(project_name, 'resp'); 
% for i = 1:length(block_names)
%     parfor ei = 1:length(elecs)
%         EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'HFB', [],[], epoch_params,'Band')
%         %         EpochDataAll(sbj_name, project_name, bn, dirs,elecs(ei), 'SpecDense', [],[], epoch_params,'Spec')
%     end
% end


% Delete non epoch data after epoching
deleteContinuousData(sbj_name, dirs, project_name, block_names, 'HFB', 'Band')
deleteContinuousData(sbj_name, dirs, project_name, block_names, 'SpecDense', 'Spec')


%% DONE PREPROCESSING. 
% Eventually replace globalVar to update dirs in case of working from an
% with an external hard drive
%UpdateGlobalVarDirs(sbj_name, project_name, block_name, dirs)

%% Branch 7 - Plotting
% plot avg. HFB timecourse for each electrode separately
% plot individual trials (to visualize bad trials)
% plot_params = genPlotParams(project_name,'timecourse');
% plot_params.single_trial = true;
% plot_params.noise_method = 'trials'; %'trials','timepts','none'
% % plot_params.noise_fields_timepts = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
% plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
% plot_params.textsize = 10;
% PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',[],plot_params,'Band')

% plot avg. HFB timecourse for each electrode separately
plot_params = genPlotParams(project_name,'timecourse');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',[],plot_params,'Band') % condNames

% plot ERSP (event-related spectral perturbations) for each electrode
plot_params = genPlotParams(project_name,'ERSP');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
% elecs = {'LP7'};
PlotERSPAll(sbj_name,project_name,block_names,dirs,[],'SpecDense','stim','conds_math_memory',{'math', 'memory'},plot_params)% condNames


% plot HFB timecourse, grouping multiple conds together
plot_params = genPlotParams(project_name,'timecourse');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,61,'HFB','stim','condNames',{{'math','autobio'},{'math'}},plot_params,'Band')

% plot HFB timecourse for multiple elecs on same plot
plot_params = genPlotParams(project_name,'timecourse');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
plot_params.multielec = true;
elecs = {'61','15'}; %S14_69b
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,'HFB','stim','condNames',{'math'},plot_params,'Band')

% plot inter-trial phase coherence for each electrode
plot_params = genPlotParams(project_name,'ITPC');
plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
PlotITPCAll(sbj_name,project_name,block_names,dirs,61,'SpecDense','stim','conds_math_memory',{'math', 'memory'},plot_params)

%%


plot_params = genPlotParams(project_name,'timecourse');
plot_params.xlim = [-.2 2]
plot_params.single_trial = true;

plot_params.noise_method = 'trials'; %'trials','timepts','none'
plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};


elecs = {'61'};
PlotTrialAvgAll(sbj_name,project_name,block_names(2:3),dirs,elecs,'HFB','stim','conds_math_memory',[],plot_params)

ChanNamesToNums(globalVar, {'LPC6'})

noise_method = 'timepts'; %'trials','timepts','none'

% plot HFB timecourse for each electrode separately
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs, [] ,'HFB','stim','condNames',[],'none',[])


PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',[],[],'trials',[],x_lim)
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','resp','conds_addsub',[],[],'none',[],x_lim)
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','conds_math_memory',[],[],'trials',[],x_lim)


baPlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',[],col,'trials',[],x_lim)

x_lim = [-tmax 1];
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',[],col,'trials',[],x_lim)

col = cool(15)
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','Operand2',[],col,'trials',[],x_lim)
PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',[],col,'trials',[],x_lim)


% Number comparison
% load a given trialinfo
load([dirs.result_root,'/',project_name,'/',sbj_name,'/',block_names{1},'/trialinfo_',block_names{1},'.mat'])
conds_dist = unique(trialinfo.conds_num_lum_digit_dot_distance)
conds_number_digit = conds_dist(contains(conds_dist, 'number_digit'));
conds_number_dot = conds_dist(contains(conds_dist, 'number_dot'));
conds_brightness_dot = conds_dist(contains(conds_dist, 'brightness_dot'));
conds_brightness_digit= conds_dist(contains(conds_dist, 'brightness_digit'));


col = gray(4)
col = col*0.85

PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','conds_num_lum_digit_dot_distance',conds_number_digit,col,'trials',[],x_lim)

% TODO: 
% Allow conds to be any kind of class, logical, str, cell, double, etc.
% Input baseline correction flag to have the option.
% Include the lines option

PlotERSPAll(sbj_name,project_name,block_names,dirs,[],'stim','condNames',[],'trials',[])
PlotERSPAll(sbj_name,project_name,block_names,dirs,[],'stim','conds_calc',[],'trials',[])
PlotERSPAll(sbj_name,project_name,block_names,dirs,[],'stim','conds_math_memory',[],'trials',[])

% TODO: Fix cbrewer 2


%% Branch 8 - integrate brain and electrodes location MNI and native and other info
% Load and convert Freesurfer to Matlab
% load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,block_names{1}),'globalVar');
% elecs = setdiff(1:globalVar.nchan,globalVar.refChan);

% Plot coverage of all subjects
[DOCID,GID] = getGoogleSheetInfo(project_name);
googleSheet = GetGoogleSpreadsheet(DOCID, GID);
sbj_names = googleSheet.subject_name;
sbj_names = sbj_names(~cellfun(@isempty, sbj_names));

for i = 1:length(sbj_names)
    PlotCoverage(sbj_names{i}, project_name)
end


sbj_name = 'S12_36_SrS'
dirs = InitializeDirs('Pedro_iMAC', project_name, sbj_name, 1); % 'Pedro_NeuroSpin2T'
fsDir_local = '/Applications/freesurfer/subjects/fsaverage';
cortex = getcort(dirs);
coords = importCoordsFreesurfer(dirs);
elect_names = importElectNames(dirs);
% V = importVolumes(dirs);

% Convert electrode coordinates from native to MNI space
% [MNI_coords, elecNames, isLeft, avgVids, subVids] = sub2AvgBrainCustom([],dirs, fsDir_local);

% Plot brain and coordinates
% transform coords
% coords(:,1) = coords(:,1) + 5;
% coords(:,2) = coords(:,2) + 5;
% coords(:,3) = coords(:,3) - 5;

%% Plot electrodes as dots in native space
figureDim = [0 0 1 .4];
figure('units', 'normalized', 'outerposition', figureDim)

views = [1 2 4];
if isLeft(1) == 1
    hemisphere = 'left';
else
    hemisphere = 'right';
end

hemisphere = 'right';

for i = 1:length(views)
    subplot(1,length(views),i)
    ctmr_gauss_plot(cortex.(hemisphere),[0 0 0], 0, hemisphere(1), views(i))
    f1 = plot3(coords(:,1),coords(:,2),coords(:,3), 'o', 'MarkerSize', 10, 'MarkerFaceColor', cdcol.light_cadmium_red, 'MarkerEdgeColor', cdcol.light_cadmium_red);
    alpha(0.7)
end
light('Position',[1 0 0])
text(350,90,sbj_name, 'Interpreter', 'none', 'FontSize', 30)
savePNG(gcf, 600, [dirs.result_root '/coverage/' sbj_name '.png']);
close all

%% Plot electrodes as text
views = [1 4];

for v = 1:length(views)
    subplot(1,length(views),v)
    ctmr_gauss_plot(cortex.(hemisphere),[0 0 0], 0, hemisphere(1), views(v))
    for i = 1:length(elecs)
        hold on
        text(coords(i,1),coords(i,2),coords(i,3), num2str(elecs(i)), 'FontSize', 20);
    end
    alpha(0.5)
end

for i = 1:9
    subplot(3,3,i)
    ctmr_gauss_plot(cortex.left,[0 0 0], 0, 'left', i)
end
% Plot two hemispheres
ctmr_gauss_plot(cortex.left,[0 0 0], 0, 'left', 1)
ctmr_gauss_plot(cortex.right,[0 0 0], 0, 'right', 1)
f1 = plot3(coords(:,1),coords(:,2),coords(:,3), '.', 'Color', 'k', 'MarkerSize', 40);
f1 = plot3(coords(e,1),coords(e,2),coords(e,3), '.', 'Color', 'r', 'MarkerSize', 40);
text(coords(e,1),coords(e,2),coords(e,3), num2str(elecs(e)), 'FontSize', 20);



%% Create subjVar
subjVar = [];
subjVar.cortex = cortex;
subjVar.V = V;
subjVar.elect_native = coords;
subjVar.elect_MNI = MNI_coords;
subjVar.elect_names = elect_names;
subjVar.demographics = GetDemographics(sbj_name, dirs);
save([dirs.original_data '/' sbj_name '/subjVar.mat' ], 'subjVar')

% demographics
% date of implantation
% birth data
% age
% gender
% handedness
% IQ full
% IQ verbal
% ressection?

%% Behavioral analysis
% Load behavioral data
load()

datatype = 'HFB'
plot_params.blc = true
locktype = 'stim'
data_all.trialinfo = [];
for i = 1:length(block_names)
    bn = block_names {i};
    dir_in = [dirs.data_root,'/','Band','Data/HFB/',sbj_name,'/',bn,'/EpochData/'];
    
    if plot_params.blc
        load(sprintf('%s/%siEEG_%slock_bl_corr_%s_%.2d.mat',dir_in,datatype,locktype,bn,1));
    else
        load(sprintf('%s/%siEEG_%slock_%s_%.2d.mat',dir_in,datatype,locktype,bn,1));
    end
    % concatenate trial info
    data_all.trialinfo = [data_all.trialinfo; data.trialinfo]; 
end

data_calc = data_all.trialinfo(data_all.trialinfo.isCalc == 1,:)
acc = sum(data_calc.Accuracy)/length(data_calc.Accuracy);
mean_rt = mean(data_calc.RT(data_calc.Accuracy == 1));
sd_rt = std(data_calc.RT(data_calc.Accuracy == 1));

boxplot(data_calc.RT(data_calc.Accuracy == 1), data_calc.OperandMin(data_calc.Accuracy == 1))
set(gca,'fontsize',20)
ylabel('RT (sec.)')
xlabel('Min operand')


%% Copy subjects
subjs_to_copy = {'S09_07_CM'};
parfor i = 1:lenght(subjs_to_copy)
    CopySubject(subjs_to_copy{i}, dirs.psych_root, '/Volumes/NeuroSpin2T/data/psychData', dirs.data_root, '/Volumes/NeuroSpin2T/data/neuralData')
    UpdateGlobalVarDirs(subjs_to_copy{i}, project_name, block_names, dirs) % after reruning
end
%% Medium-long term projects
% 1. Creat subfunctions of the EventIdentifier specific to each project
% 2. Stimuli identity to TTL

%% Concatenate all trials all channels
plot_params.blc = true;
data_all = ConcatenateAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim', plot_params);
data_all_spec = ConcatenateAll(sbj_name,project_name,block_names,dirs,[],'Spec','stim', plot_params);

exportDataMNE(data_all_spec)


trialinfo = removevars(data_all.trialinfo{1}, {'bad_epochs_raw', 'bad_epochs_HFO' 'bad_epochs', 'bad_inds_raw', 'bad_inds_HFO', 'bad_inds'}); 

% excluse bad channels
data_all.wave(:,data_all.badChan,:) = [];
data_all.labels(data_all.badChan) = [];
data_all.trialinfo(data_all.badChan) = [];

% check for channels with nan
nan_channel = [];
for i = 1:size(data_all.wave,2)
    nan_channel(i) = sum(sum(isnan(data_all.wave(:,i,:))));
end

% Exclude channels witgh nan 
data_all.wave = data_all.wave(:,find(nan_channel == 0),:);
data_all.labels(find(nan_channel ~= 0)) = [];
data_all.trialinfo(find(nan_channel ~= 0)) = [];

%Randomly select the same number of conditions

% Save 
save([dirs.data_mvpa '/data_all_' sbj_name '_' project_name '_' 'Spec' '.mat'], 'data_all_spec', '-v7.3');

% Export trialinfo to csv 
data_all.wave = data_all.wave(~contains(trialinfo.wlist, 'Ê'),:,:); % correct that for MMR
trialinfo = trialinfo(~contains(trialinfo.wlist, 'Ê'),:); % correct that for MMR
writetable(trialinfo,[dirs.data_mvpa '/trialinfo_' sbj_name '_' project_name '.csv'])                      

%% Prepare data for cluster-based stats
% to do
% add the sem plot to the mean 
% adapt the clust_perm2 to independent sample t-test
% adapt the clust_perm2 to f-test

data_math = data_all.wave(data_all.trialinfo{1}.isCalc == 1, 61, :);
data_math = permute(data_math, [2,3,1]);
data_autobio = data_all.wave(data_all.trialinfo{1}.isCalc == 0, 61, :);
data_autobio = permute(data_autobio, [2,3,1]);

% Example stats for one sample t-test
[pval, t_orig, clust_info, seed_state, est_alpha] = clust_perm1(data_math,[]);
pval(pval>0.05) = nan;
pvalsig = find(pval<0.05);
% Plot
hold on
plot(squeeze(mean(data_math,3)))
plot(pvalsig, zeros(length(pvalsig),1)', '*')

% Example stats for two sample t-test
[pval, t_orig, clust_info, seed_state, est_alpha] = clust_perm2(data_math, data_autobio(:,:,1:size(data_math,3)),[]);
pval(pval>0.05) = nan;
pvalsig = find(pval<0.05);

hold on
plot(squeeze(mean(data_math,3)))
plot(squeeze(mean(data_autobio,3)))
plot(pvalsig, zeros(length(pvalsig),1)', '*')




%% MMR
data_calc = data_all.trialinfo(strcmp(data_all.trialinfo.condNames, 'math'),:)




