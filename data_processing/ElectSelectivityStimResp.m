function [el_selectivity, sm_data, sc1c2, sc1b1, sc2b2] = ElectSelectivityStimResp(sbj_name,project_name, block_names, dirs, column, conds, datatype, freq_band, stats_params)

%%
% Get stats parameters
if isempty(stats_params)
    stats_params = genStatsParams(project_name, 'lock_type');
end

% Concatenate all trials all channels
cfg = [];
cfg.decimate = false;
concat_params = genConcatParams(project_name, cfg);
if ~isfield(concat_params, 'data_format')
    concat_params.data_format = 'regular';
else
end


locktype = {'stim', 'resp'};

for il = 1:length(locktype)
    data_sbj = ConcatenateAll(sbj_name,project_name,block_names,dirs,[],datatype,freq_band,locktype{il}, concat_params);
    
    % Average data and baseline windows
    data_all_avg = [];
    data_all = [];
    for ii = 1:length(conds)
        % Initialize data_all
        data_all_avg.(conds{ii}) = [];
        data_all.(conds{ii}) = [];
    end
    
    data_field = 'wave';
    data_win = min(find(data_sbj.time>stats_params.([locktype{il} '_win'])(1))):max(find(data_sbj.time<stats_params.([locktype{il} '_win'])(2)));
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
    data.(locktype{il}) = data_all;
    data_avg.(locktype{il}) = data_all_avg;
end



% Calculate difference between 2 conditions across channels
for ii = 1:size(data_sbj.wave,2)
    if ii == 1
        fprintf('calculating stats for subject %s\n', sbj_name)
    else
    end
    trialinfo_tmp = data_sbj.trialinfo_all{ii};

    trialinfo_tmp_cond1 = trialinfo_tmp(strcmp(trialinfo_tmp.(column), conds{1}),:);
    goodtrials_cond1 = trialinfo_tmp_cond1.bad_epochs_HFO == 0 & trialinfo_tmp_cond1.spike_hfb == 0;
    
    trialinfo_tmp_cond2 = trialinfo_tmp(strcmp(trialinfo_tmp.(column), conds{2}),:);
    goodtrials_cond2 = trialinfo_tmp_cond2.bad_epochs_HFO == 0 & trialinfo_tmp_cond2.spike_hfb == 0;

    
    data_cond1_avg_stim = data_avg.stim.(conds{1})(goodtrials_cond1,ii); % well, we actually want to be fare here with deactivations. 
    data_cond2_avg_stim = data_avg.stim.(conds{2})(goodtrials_cond2,ii);
    
    data_cond1_avg_resp = data_avg.resp.(conds{1})(goodtrials_cond1,ii);
    data_cond2_avg_resp = data_avg.resp.(conds{2})(goodtrials_cond2,ii);


    fprintf('calculating stats for channel %d\n', ii)

    
    [H,P,CI,STATS] = ttest2(data_cond1_avg_stim,data_cond1_avg_resp); STATS.H = H; STATS.P = P; STATS.CI = CI;
    try
        STATS.P_perm = permutation_unpaired(data_cond1_avg_stim,data_cond1_avg_resp, stats_params.nreps);
        sc1c1(ii,:) = STATS;
    catch
        STATS.P_perm = 999
        sc1c1(ii,:) = STATS;
    end

    [H,P,CI,STATS] = ttest2(data_cond2_avg_stim,data_cond2_avg_resp); STATS.H = H; STATS.P = P; STATS.CI = CI;
    try
        STATS.P_perm = permutation_unpaired(data_cond2_avg_stim,data_cond2_avg_resp, stats_params.nreps);
        sc2c2(ii,:) = STATS;
    catch
        STATS.P_perm = 999
        sc2c2(ii,:) = STATS;
    end
    
end

% FDR correction
sc1c1_FDR = mafdr(vertcat(sc1c1.P_perm), 'BHFDR', true);
sc2c2_FDR = mafdr(vertcat(sc2c2.P_perm), 'BHFDR', true);
sc1c1_Pperm = vertcat(sc1c1.P_perm);
sc2c2_Pperm = vertcat(sc2c2.P_perm);



sc1c1_tstat = vertcat(sc1c1.tstat);
sc2c2_tstat = vertcat(sc2c2.tstat);


for i = 1:length(sc1c1_FDR)
    sc1c1(i).P_FDR = sc1c1_FDR(i);
    sc2c2(i).P_FDR = sc2c2_FDR(i);
end

%% Selectivity

for ii = 1:size(data_sbj.wave,2)
    if sc1c1(ii).P_FDR <0.05 && sc2c2(ii).P_FDR >= 0.05 && sc1c1(ii).tstat > 0 
        elect_select{ii,1} = [conds{1} ' stim locked'];
    elseif sc1c1(ii).P_FDR <0.05 && sc2c2(ii).P_FDR >= 0.05 && sc1c1(ii).tstat < 0 
        elect_select{ii,1} = [conds{1} ' resp locked'];

    elseif sc2c2(ii).P_FDR <0.05 && sc1c1(ii).P_FDR >= 0.05 && sc2c2(ii).tstat > 0 
        elect_select{ii,1} = [conds{2} ' stim locked'];
    elseif sc2c2(ii).P_FDR <0.05 && sc1c1(ii).P_FDR >= 0.05 && sc2c2(ii).tstat < 0 
        elect_select{ii,1} = [conds{1} ' resp locked'];

    elseif sc1c1(ii).P_FDR <0.05 && sc2c2(ii).P_FDR < 0.05 && sc1c1(ii).tstat > 0 && sc2c2(ii).tstat > 0 
        elect_select{ii,1} = [conds{1} ' and ' conds{2} ' stim locked'];

    elseif sc1c1(ii).P_FDR <0.05 && sc2c2(ii).P_FDR < 0.05 && sc1c1(ii).tstat < 0 && sc2c2(ii).tstat < 0 
        elect_select{ii,1} = [conds{1} ' and ' conds{2} ' resp locked'];

    elseif sc1c1(ii).P_FDR < 0.05 && sc2c2(ii).P_FDR < 0.05 && sc1c1(ii).tstat > 0 && sc2c2(ii).tstat < 0 
        elect_select{ii,1} = [conds{1} ' stim locked' ' and ' conds{2} ' resp locked'];

    elseif sc1c1(ii).P_FDR < 0.05 && sc2c2(ii).P_FDR < 0.05 && sc1c1(ii).tstat < 0 && sc2c2(ii).tstat > 0 
        elect_select{ii,1} = [conds{1} ' resp locked' ' and ' conds{2} ' stim locked'];

    else
        elect_select{ii,1} = 'no selectivity for lock type';
    end
    
end



% organize output in a sinlge table
el_selectivity = table(elect_select, sc1c1_FDR, sc2c2_FDR, sc1c1_Pperm, sc2c2_Pperm, sc1c1_tstat, sc2c2_tstat);

end

