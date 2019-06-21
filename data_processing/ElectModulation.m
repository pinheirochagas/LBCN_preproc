function [el_selectivity, sm_data, sc1c2, sc1b1, sc2b2] = ElectModulation(sbj_name,project_name, block_names, dirs, tag, column, conds, fields, datatype, freq_band, modulation_params)

% Get stats parameters
if isempty(modulation_params)
    modulation_params = genModulationParams(project_name);
end

% Concatenate all trials all channels
cfg = [];
cfg.decimate = false;
concat_params = genConcatParams(project_name, cfg);
data_sbj = ConcatenateAll(sbj_name,project_name,block_names,dirs,[],datatype,freq_band,tag, concat_params);

% get calc

if isempty(conds)
   conds = unique(data_sbj.trialinfo.(column)); 
else
end

% Average across conds
data_field = 'wave';
data_win = min(find(data_sbj.time>modulation_params.task_win(1))):max(find(data_sbj.time<modulation_params.task_win(2)));
baseline_win = min(find(data_sbj.time>modulation_params.bl_win(1))):max(find(data_sbj.time<modulation_params.bl_win(2)));
data_all_avg = [];
for ii = 1:length(conds)
    trial_idx = strcmp(data_sbj.trialinfo.(column), conds{ii});
    if strcmp(datatype, 'Band')
        data_tmp_avg = nanmean(data_sbj.(data_field)(trial_idx,:,data_win),3); % average time win by electrode
    else strcmp(datatype, 'Spec')
        data_tmp_avg = nanmedian(data_sbj.(data_field)(trial_idx,:,:,:),4); % average time win by electrode
    end
    data_all_avg.(conds{ii}).(data_field) = data_tmp_avg;
    data_all_avg.(conds{ii}).trialinfo = data_sbj.trialinfo(trial_idx,:);    
end

% Run regression across fields - 1 predictor! 
reg_stats = [];
for i = 1%:length(conds)
    data = data_all_avg.(conds{i}).(data_field);
    for ii = 1:length(fields.(conds{i}))
        pred = data_all_avg.(conds{i}).trialinfo.(fields.(conds{i}){ii});
        for iii = 1:size(data,2)
            try 
                reg_stats.(conds{i}).(fields.(conds{i}){ii}).all{iii} = regstats(data(:,iii),pred, 'linear', 'all');
                reg_stats.(conds{i}).(fields.(conds{i}){ii}).betas(iii,1) = reg_stats.(conds{i}).(fields.(conds{i}){ii}).all{iii}.beta(1);
                reg_stats.(conds{i}).(fields.(conds{i}){ii}).pvals(iii,1) = reg_stats.(conds{i}).(fields.(conds{i}){ii}).all{iii}.fstat.pval;
            catch
                reg_stats.(conds{i}).(fields.(conds{i}){ii}).all{iii} = {};
                reg_stats.(conds{i}).(fields.(conds{i}){ii}).betas(iii,1) = nan;
                reg_stats.(conds{i}).(fields.(conds{i}){ii}).pvals(iii,1) = nan;
            end
        end
        reg_stats.(conds{i}).(fields.(conds{i}){ii}).pvalsFDR = mafdr(reg_stats.(conds{i}).(fields.(conds{i}){ii}).pvals, 'bhfdr', true);        
    end
end

a = 1

end

