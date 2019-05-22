%% Decoding pipeline
server_root = '/Volumes/neurology_jparvizi$/';
comp_root = '/Volumes/LBCN8T/Stanford/data';
code_root = '/Users/pinheirochagas/Pedro/Stanford/code/lbcn_preproc/';

sbj_name = 'S19_137_AF';
block_names = BlockBySubj(sbj_name,project_name);

dirs = InitializeDirs(project_name, sbj_name, comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'


%% Export data to MNE
% Load subjVar

% Load single channel with Spec
chan = find(strcmp(subjVar.labels_EDF, 'LK10'));
data_all = concatBlocks(sbj_name, project_name, block_names,dirs,chan,'SpecDense','Spec',{'wave'},'stimlock_bl_corr')

data_all.wave = permute(data_all.wave,[2,1,3]);

trialinfo = removevars(data_all.trialinfo, {'bad_epochs_raw_LFspike', 'bad_epochs_raw_HFspike' 'bad_epochs_raw_jump', 'bad_epochs_spec_HFspike', 'bad_epochs','bad_epochs_HFO', 'bad_inds_raw_LFspike', 'bad_inds_raw_HFspike', 'bad_inds_raw_jump', 'bad_inds_spec_HFspike', 'bad_inds_HFO', 'bad_inds', 'block', 'allonsets', 'StimulusOnsetTime'});
data_all.label = cellstr(num2str(data_all.freqs'));
data_all.project_name = project_name;

dirs.MVPAData = '/Volumes/LBCN8T_2/Stanford/data/MVPAData';
save([dirs.MVPAData '/data_all_' sbj_name '_' project_name '.mat'], 'data_all');

% save([dirs.MVPAData '/data_specdense_' sbj_name '_' project_name '_' '.mat'], 'data');

% Export trialinfo to csv
% data_all.wave = data_all.wave(~contains(trialinfo.wlist, 'Ê'),:,:); % correct that for MMR
% trialinfo = trialinfo(~contains(trialinfo.wlist, 'Ê'),:); % correct that for MMR
writetable(trialinfo,[dirs.MVPAData '/trialinfo_' sbj_name '_' project_name '.csv'])






for i = 1:200
    hold on
    plot(data_all.trial{i}(108,:))
end







cols = viridis(size(data_all.wave,2))

for i = 1:size(data_all.wave,2)
    hold on
    plot(squeeze(mean(data_all.wave(:,i,:))), 'Color', cols(i,:), 'LineWidth', 2)
end
set(gca,'color',[.7 .7 .7])
set(gcf,'color',[.7 .7 .7])
set(gca, 'FontSize', 20)
% ylim([data_all.freqs(1) data_all.freqs(end)])






% % excluse bad channels
% data_all.wave(:,data_all.badChan,:) = [];
% data_all.labels(data_all.badChan) = [];
% data_all.trialinfo(data_all.badChan) = [];

% check for channels with nan
nan_channel = [];
for i = 1:size(data_all.wave,2)
    nan_channel(i) = sum(sum(isnan(data_all.wave(:,i,:))));
end

% Interpolate nans channels witgh nan
% loop across dimensions
nanx = isnan(x);
t    = 1:numel(x);
x(nanx) = interp1(t(~nanx), x(~nanx), t(nanx));


%% Select some channels 
chan_indices = find(contains(data_all.labels, 'LPG'));
data_all.wave = data_all.wave(:,chan_indices,:);
data_all.labels = data_all.labels(chan_indices);
bad_chan_HFO = [17:23, 25:31, 37:39];
data_all.wave(:,bad_chan_HFO,:) = [];
data_all.labels(bad_chan_HFO) = [];


data_all.wave(:,data_all.badChan,:) = [];
data_all.labels(data_all.badChan) = [];


%Randomly select the same number of conditions

% Save
dirs.MVPAData = '/Volumes/LBCN8T_2/Stanford/data/MVPAData';
% save([dirs.MVPAData '/data_all_' sbj_name '_' project_name '_' 'HFB' '.mat'], 'data_all', '-v7.3');
save([dirs.MVPAData '/data_all_' sbj_name '_' project_name '_' '.mat'], 'data_all');

% Export trialinfo to csv
% data_all.wave = data_all.wave(~contains(trialinfo.wlist, 'Ê'),:,:); % correct that for MMR
% trialinfo = trialinfo(~contains(trialinfo.wlist, 'Ê'),:); % correct that for MMR
writetable(trialinfo,[dirs.MVPAData '/trialinfo_' sbj_name '_' project_name '.csv'])