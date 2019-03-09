function [el_selectivity, sm_data, sc1c2, sc1b1, sc2b2] = ElectSelectivity(sbj_name,project_name, block_names, dirs, tag, column, conds, datatype, freq_band, stats_params)

%%
% Get stats parameters
if isempty(stats_params)
    stats_params = genStatsParams(project_name);
end

% Concatenate all trials all channels
cfg = [];
cfg.decimate = false;
concat_params = genConcatParams(project_name, cfg);
data_sbj = ConcatenateAll(sbj_name,project_name,block_names,dirs,[],datatype,freq_band,tag, concat_params);

% Average data and baseline windows
data_all = [];
for ii = 1:length(conds)
    % Initialize data_all
    data_all.(conds{ii}) = [];
end

data_field = 'wave';
data_win = min(find(data_sbj.time>stats_params.task_win(1))):max(find(data_sbj.time<stats_params.task_win(2)));
baseline_win = min(find(data_sbj.time>stats_params.bl_win(1))):max(find(data_sbj.time<stats_params.bl_win(2)));
for ii = 1:length(conds)
    trial_idx = strcmp(data_sbj.trialinfo.(column), conds{ii});
    if strcmp(datatype, 'Band')
        data_tmp_avg = nanmean(data_sbj.(data_field)(trial_idx,:,data_win),3); % average time win by electrode
    else strcmp(datatype, 'Spec')
        data_tmp_avg = nanmean(data_sbj.(data_field)(trial_idx,:,:,:),4); % average time win by electrode
    end 
        data_all.(conds{ii}) = data_tmp_avg; 
end

if strcmp(datatype, 'Band')
    baseline_all = nanmean(data_sbj.(data_field)(:,:,baseline_win),3);
else
    baseline_all = nanmean(data_sbj.(data_field)(:,:,:,baseline_win),4);
end


% Calculate difference between 2 conditions across channels
for ii = 1:size(data_sbj.wave,2)
    data_cond1 = data_all.(conds{1})(:,ii);
    data_cond2 = data_all.(conds{2})(:,ii);
    data_baseline = baseline_all(:,ii);
    
    fprintf('calculating stats for channel %d\n', ii)
    
    [H,P,CI,STATS] = ttest2(data_cond1,data_cond2); STATS.H = H; STATS.P = P; STATS.CI = CI;
    STATS.P_perm = permutation_unpaired(data_cond1, data_cond2, stats_params.nreps);
    sc1c2(ii,:) = STATS;

    [H,P,CI,STATS] = ttest2(data_cond1,data_baseline); STATS.H = H; STATS.P = P; STATS.CI = CI;
    STATS.P_perm = permutation_unpaired(data_cond1, data_baseline, stats_params.nreps);
    sc1b1(ii) = STATS;
    
    [H,P,CI,STATS] = ttest2(data_cond2,data_baseline); STATS.H = H; STATS.P = P; STATS.CI = CI;
    STATS.P_perm = permutation_unpaired(data_cond2, data_baseline, stats_params.nreps);
    sc2b2(ii) = STATS; 
    
    sm_data.mean(ii,:) = [nanmean(data_cond1) nanmean(data_cond2) nanmean(data_baseline)];
    sm_data.std(ii,:) = [nanstd(data_cond1) nanstd(data_cond2) nanstd(data_baseline)];
end

% FDR correction
sc1c2_FDR = mafdr(vertcat(sc1c2.P_perm));
sc1b1_FDR = mafdr(vertcat(sc1b1.P_perm));
sc2b2_FDR = mafdr(vertcat(sc2b2.P_perm));


for i = 1:length(sc1c2_FDR)
    sc1c2(i).P_FDR = sc1c2_FDR(i);
    sc1b1(i).P_FDR = sc1b1_FDR(i);
    sc2b2(i).P_FDR = sc2b2_FDR(i);
end

for ii = 1:size(data_sbj.wave,2)
    if sc1c2(ii).P_FDR <0.05 && sc1c2(ii).tstat > 0 && sc1b1(ii).P_FDR <0.05 && sc1b1(ii).tstat > 0 && sc2b2(ii).P_FDR > 0.05 
        elect_select{ii,1} = [conds{1} ' only'];
    elseif sc1c2(ii).P_FDR <0.05 && sc1c2(ii).tstat > 0 && sc1b1(ii).P_FDR <0.05 && sc1b1(ii).tstat > 0 && sc2b2(ii).P_FDR < 0.05 && sc2b2(ii).tstat > 0
        elect_select{ii,1} = [conds{1} ' selective'];
        
    elseif sc1c2(ii).P_FDR > 0.05 && sc1b1(ii).P_FDR <0.05 && sc1b1(ii).tstat > 0 && sc2b2(ii).P_FDR < 0.05 && sc2b2(ii).tstat > 0
        elect_select{ii,1} = [conds{1} ' and ' conds{2}];
        
    elseif sc1c2(ii).P_FDR <0.05 && sc1c2(ii).tstat < 0 && sc1b1(ii).P_FDR > 0.05 && sc2b2(ii).P_FDR < 0.05 && sc2b2(ii).tstat > 0
        elect_select{ii,1} = [conds{2} ' only'];
    elseif sc1c2(ii).P_FDR <0.05 && sc1c2(ii).tstat < 0 && sc1b1(ii).P_FDR < 0.05 && sc1b1(ii).tstat > 0 && sc2b2(ii).P_FDR < 0.05 && sc2b2(ii).tstat > 0
        elect_select{ii,1} = [conds{2} ' selective'];
        
    elseif sc1c2(ii).P_FDR > 0.05 && sc1c2(ii).P_perm < 0.05 && sc1c2(ii).tstat > 0 && sc1b1(ii).P_FDR <0.05 && sc1b1(ii).tstat > 0 && sc2b2(ii).P_perm > 0.05 && sc2b2(ii).tstat > 0
        elect_select{ii,1} = [conds{1} ' selective'];    
        
    elseif sc1c2(ii).P_FDR > 0.05 && sc1c2(ii).P_perm < 0.05 && sc1c2(ii).tstat < 0 && sc1b1(ii).P_perm > 0.05 && sc1b1(ii).tstat > 0 && sc2b2(ii).P_FDR < 0.05 && sc2b2(ii).tstat > 0
        elect_select{ii,1} = [conds{1} ' selective'];  
        
    else
        elect_select{ii,1} = 'no selectivity';  
    end
    
end

act = (sum([sc1b1_FDR < 0.05 sm_data.mean(:,1) > sm_data.mean(:,3)],2) == 2);
deact = (sum([sc1b1_FDR < 0.05 sm_data.mean(:,1) < sm_data.mean(:,3)],2) == 2) * -1;
act_deact_cond1 = sum([act, deact],2);
act = (sum([sc2b2_FDR < 0.05 sm_data.mean(:,1) > sm_data.mean(:,3)],2) == 2);
deact = (sum([sc2b2_FDR < 0.05 sm_data.mean(:,1) < sm_data.mean(:,3)],2) == 2) * -1;
act_deact_cond2 = sum([act, deact],2);

% organize output in a sinlge table
el_selectivity = table(elect_select, act_deact_cond1, act_deact_cond2, sc1c2_FDR, sc1b1_FDR, sc2b2_FDR);

end

