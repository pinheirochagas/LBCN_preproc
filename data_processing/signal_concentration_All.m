function sig_con = signal_concentration_All(sbj_name,project_name,block_names,dirs,elecs,freqband,column,conds)

%% INPUTS
%       sbj_name: subject name
%       project_name: name of task
%       block_names: blocks to be analyed (cell of strings)
%       dirs: directories pointing to files of interest (generated by InitializeDirs)
%       elecs: can select subset of electrodes to epoch (default: all)
%       freqband: 'CAR','HFB',or 'Spec'
%       locktype: 'stim' or 'resp' (which event epoched data is locked to)
%       column: column of data.trialinfo by which to sort trials for plotting
%       conds:  cell containing specific conditions to plot within column (default: all of the conditions within column)
%               can group multiple conds together by having a cell of cells
%               (e.g. conds = {{'math'},{'autobio','self-internal'}})
%       col:    colors to use for plotting each condition (otherwise will
%               generate randomly)
%       noise_method:   how to exclude data (default: 'trial'):
%                       'none':     no epoch rejection
%                       'trial':    exclude noisy trials (set to NaN)
%                       'timepts':  set noisy timepoints to NaN but don't exclude entire trials
%       ROLparams:    (see genROLParams.m script)


% load subjVar

if isempty(block_names)
    block_names = BlockBySubj(sbj_name,project_name);
else
end

load([dirs.original_data filesep  sbj_name filesep 'subjVar_'  sbj_name '.mat']);

%load elecs info.
if isempty(elecs)
    % load globalVar (just to get ref electrode, # electrodes)
    elecs = 1:size(subjVar.elinfo,1);
end

if isempty(freqband)
    freqband = 'HFB';
end


load([dirs.data_root,'/OriginalData/',sbj_name,'/global_',project_name,'_',sbj_name,'_',block_names{1},'.mat'])

% dir_in = [dirs.data_root,filesep,'BandData',filesep,freqband,filesep,sbj_name,filesep,block_names{1},'/EpochData/'];
% load(sprintf('%s/%siEEG_stimlock_bl_corr_%s_%.2d.mat',dir_in,freqband,block_names{1},1));
% % ntrials = size(data.trialinfo,1);
% nstim = size(data.trialinfo.allonsets,2); % (max) number of stim per trial
%
% if strcmp(freqband,'Spec') % if spectral data, will average across specified freq. range
%     freq_inds = find(data.freqs > ROLparams.freq_range(1) & data.freqs < ROLparams.freq_range(2));
% end
%
% % find onsets of each stim relative to first stim (in cases where each
% % trial has multiple stims)
%
% fs = data.fsample;
% winSize = floor(fs*ROLparams.smwin);
% gusWin= gausswin(winSize)/sum(gausswin(winSize));
%
% if isempty(conds)
%     conds = unique(data.trialinfo.(column));
% end
%
% % if multiple stim per trial, get onset of each stim (relative to 1st stim)
% stimtime = [0 cumsum(nanmean(diff(data.trialinfo.allonsets,1,2)))];
% stiminds = nan(size(stimtime));
% for i = 1:length(stimtime)
%     stiminds(i)= find(data.time>stimtime(i),1);
% end
%
% befInd = round(ROLparams.pre_event * fs);
% aftInd = round(ROLparams.dur * fs);
% time = (befInd:aftInd)/fs;
%
% %% loop
%
% for ci = 1:length(conds)
%     cond = conds{ci};
%     ROL.(cond).thr = cell(globalVar.nchan,nstim);
%     if ROLparams.linfit
%         ROL.(cond).fit = cell(globalVar.nchan,nstim);
%     end
% %     HFB_trace_bc.(cond) = cell(globalVar.nchan,nstim);
% %     ROL.(cond).HFB_trace_bc = cell(globalVar.nchan,nstim);
% %     ROL.(cond).traces = cell(globalVar.nchan,nstim);
% %     HFB_trace_bs.(cond) = cell(globalVar.nchan,nstim);
%     sig.(cond) = cell(globalVar.nchan,nstim);
% end
%
concatfield = {'wave'};
tag = 'stimlock';
tag = [tag,'_bl_corr'];

disp(['processing subject: ',sbj_name])

% chans = [105, 15, 61, 102, 81, 70];


for ei = 1:length(elecs)
    el = elecs(ei);
    disp(['Calculating signal concentration for electrode: ' num2str(el)])
    data_all = concatBlocks(sbj_name,project_name,block_names,dirs,el,freqband,'Band',concatfield,tag);
    sig_con_time = [];
    sig_con_auc_pct_tmp = cell(size(data_all.trialinfo,1),1,1);
    sig_con_time_tmp = cell(size(data_all.trialinfo,1),1,1);
    
    for itrials = 1:size(data_all.trialinfo,1)
        if isnan(data_all.trialinfo.RT(itrials)) | data_all.trialinfo.RT(itrials) == 0  | data_all.trialinfo.RT(itrials) > 5;
            sig_con_time_cross_tmp(itrials) = nan;
            sig_con_auc_tmp(itrials) = nan;
            sig_con_max_time_tmp(itrials) = nan;
            
        else
            data_tmp = data_all.wave(itrials, min(find(data_all.time>0)):min(find(data_all.time>data_all.trialinfo.RT(itrials))));
            %             data_tmp = data_all.wave(itrials, min(find(data_all.time>0)):min(find(data_all.time>1.5)));
            
            
            if sum(isnan(data_tmp))>0 || isempty(data_tmp) || data_all.trialinfo.RT(itrials)>5
                sig_con_time_cross_tmp(itrials) = nan;
                sig_con_auc_tmp(itrials) = nan;
                sig_con_max_time_tmp(itrials) = nan;
                sig_con_auc_pct_tmp{itrials} = nan;
                sig_con_time_tmp{itrials} = nan;
            else
                time_tmp = data_all.time(min(find(data_all.time>0)):min(find(data_all.time>data_all.trialinfo.RT(itrials))));
                data_tmp = data_all.wave(itrials, min(find(data_all.time>0)):min(find(data_all.time>data_all.trialinfo.RT(itrials))));
                [time_cross, auc, auc_pct] = signal_concentration(data_tmp, time_tmp, 50);
                
                sig_con_time_cross_tmp(itrials) = time_cross;
                sig_con_auc_tmp(itrials) = auc;
                sig_con_max_time_tmp(itrials) = data_all.trialinfo.RT(itrials);
                sig_con_auc_pct_tmp{itrials} = auc_pct;
                sig_con_time_tmp{itrials} = time_tmp;
                
            end
        end
    end
    
    [grouped_trials,grouped_condnames] = groupConds(conds,data_all.trialinfo,column,'none',{''},false);
    
    nconds = length(grouped_trials);
    for ci = 1:nconds
        cond = grouped_condnames{ci};
        sig_con.(cond).time_cross{el} = sig_con_time_cross_tmp(grouped_trials{ci});
        sig_con.(cond).auc{el} = sig_con_auc_tmp(grouped_trials{ci});
        sig_con.(cond).max_time{el} = sig_con_max_time_tmp(grouped_trials{ci});
        sig_con.(cond).auc_pct{el} = sig_con_auc_pct_tmp(grouped_trials{ci});
        sig_con.(cond).time{el} = sig_con_time_tmp(grouped_trials{ci});
    end
end





fname = sprintf('%ssignal_concentration/%s_%s_signal_concentration.mat',dirs.paper_results, sbj_name, project_name);
save(fname, 'sig_con');
disp(['saved signal_concentration for subject: ',sbj_name])

end
