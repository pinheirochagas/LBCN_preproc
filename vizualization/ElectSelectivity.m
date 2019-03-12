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
data_all_avg = [];
data_all = [];
for ii = 1:length(conds)
    % Initialize data_all
    data_all_avg.(conds{ii}) = [];
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
        data_tmp_avg = nanmedian(data_sbj.(data_field)(trial_idx,:,:,:),4); % average time win by electrode
    end
    data_tmp = data_sbj.(data_field)(trial_idx,:,data_win);
    data_all_avg.(conds{ii}) = data_tmp_avg;
    data_all.(conds{ii}) = data_tmp;
end

if strcmp(datatype, 'Band')
    baseline_all = nanmean(data_sbj.(data_field)(:,:,baseline_win),3);
else
    baseline_all = nanmedian(data_sbj.(data_field)(:,:,:,baseline_win),4);
end

% Define channele neighbourhood - WORK ON THAT! 
if strcmp (datatype,'Band')
    chan_hood=[];
elseif strcmp (datatype,'Spec')
    fnn=eye(size(data.wave,1));
    fnn_indx=find(fnn==1);
    fnn_indx1=fnn_indx-1;
    fnn_indx2=fnn_indx+1;
    fnn(fnn==1)=nan;
    chan_hood=fnn;
    chan_hood(fnn_indx1(2:end))=1;
    chan_hood(fnn_indx2(1:end-1))=1;  % define the adjacency
end

% Calculate difference between 2 conditions across channels
for ii = 1:size(data_sbj.wave,2)
    data_cond1_avg = data_all_avg.(conds{1})(:,ii);
    data_cond2_avg = data_all_avg.(conds{2})(:,ii);
    data_baseline = baseline_all(:,ii);
    
    fprintf('calculating stats for channel %d\n', ii)
    
    [H,P,CI,STATS] = ttest2(data_cond1_avg,data_cond2_avg); STATS.H = H; STATS.P = P; STATS.CI = CI;
    STATS.P_perm = permutation_unpaired(data_cond1_avg, data_cond2_avg, stats_params.nreps);
    sc1c2(ii,:) = STATS;
    
%     % ---------------------------------------------------------------------
%     %Cluster based
%     data_cond1 = permute(data_all.(conds{1})(:,61,:), [2,3,1]);
%     data_cond2 = permute(data_all.(conds{2})(:,61,:), [2,3,1]);
%     
%     % Remove bad trials (the ones set to nan)
%     for inan = 1:size(data_cond1,3)
%         nan_trials1(inan) = sum(sum(isnan(data_cond1(:,:,inan))));
%     end
%     data_cond1(:,:,nan_trials>0) = [];
%     for inan = 1:size(data_cond2,3)
%         nan_trials2(inan) = sum(sum(isnan(data_cond2(:,:,inan))));
%     end
%     data_cond2(:,:,nan_trials2>0) = [];    
%     
%     
%     tn1 = size(data_cond1,3);
%     tn2 = size(data_cond2,3);
%     tm  = min(tn1,tn2);
%     
%     if tn1 > tn2
%         data_cond1 = data_cond1(:,:,randsample(1:tn1,tn2));  
%     elseif tn1 < tn2
%         data_cond2 = data_cond2(:,:,randsample(1:tn2,tn1));  
%     end
%     
%     [pval, t_orig, clust_info, seed_state, est_alpha] = clust_perm2(data_cond1, data_cond2,chan_hood);
%     % ---------------------------------------------------------------------
    
    [H,P,CI,STATS] = ttest2(data_cond1_avg,data_baseline); STATS.H = H; STATS.P = P; STATS.CI = CI;
    STATS.P_perm = permutation_unpaired(data_cond1_avg, data_baseline, stats_params.nreps);
    sc1b1(ii) = STATS;
    
    [H,P,CI,STATS] = ttest2(data_cond2_avg,data_baseline); STATS.H = H; STATS.P = P; STATS.CI = CI;
    STATS.P_perm = permutation_unpaired(data_cond2_avg, data_baseline, stats_params.nreps);
    sc2b2(ii) = STATS;
    
    sm_data.mean(ii,:) = [nanmean(data_cond1_avg) nanmean(data_cond2_avg) nanmean(data_baseline)];
    sm_data.std(ii,:) = [nanstd(data_cond1_avg) nanstd(data_cond2_avg) nanstd(data_baseline)];
end

% FDR correction
sc1c2_FDR = mafdr(vertcat(sc1c2.P_perm));
sc1b1_FDR = mafdr(vertcat(sc1b1.P_perm));
sc2b2_FDR = mafdr(vertcat(sc2b2.P_perm));
sc1c2_Pperm = vertcat(sc1c2.P_perm);
sc1b1_Pperm = vertcat(sc1b1.P_perm);
sc2b2_Pperm = vertcat(sc2b2.P_perm);

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
        
        %     elseif sc1c2(ii).P_FDR > 0.05 && sc1c2(ii).P_perm < 0.05 && sc1c2(ii).tstat > 0 && sc1b1(ii).P_FDR <0.05 && sc1b1(ii).tstat > 0 && sc2b2(ii).P_perm > 0.05 && sc2b2(ii).tstat > 0
        %         elect_select{ii,1} = [conds{1} ' selective'];
        %
        %     elseif sc1c2(ii).P_FDR > 0.05 && sc1c2(ii).P_perm < 0.05 && sc1c2(ii).tstat < 0 && sc1b1(ii).P_perm > 0.05 && sc1b1(ii).tstat > 0 && sc2b2(ii).P_FDR < 0.05 && sc2b2(ii).tstat > 0
        %         elect_select{ii,1} = [conds{1} ' selective'];
        
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
el_selectivity = table(elect_select, act_deact_cond1, act_deact_cond2, sc1c2_FDR, sc1b1_FDR, sc2b2_FDR, sc1c2_Pperm, sc1b1_Pperm, sc2b2_Pperm);

end

