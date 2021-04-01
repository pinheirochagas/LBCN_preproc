function ElecSelectivityAll(task, s, hypothesis, locktype, datatype, freq_band, dirs)

% Get parameters
cfg = [];
[cfg.column,cfg.conds] = getCondNames(task, hypothesis);
cfg.stats_params = genStatsParams(task, hypothesis);

fname = sprintf('%scomputation/%s/%s_%s_%s.mat',dirs.paper_results, hypothesis, task, s, hypothesis);

if ~exist(fname,'file')
    load([dirs.original_data filesep  s filesep 'subjVar_'  s '.mat']);
    fprintf('processing subject %s\n', s)
    
    block_names = BlockBySubj(s,task);

    try
        elect_select = ElectSelectivity(s, task, block_names, dirs, locktype, cfg.column, cfg.conds, datatype, freq_band, cfg.stats_params);
        el_selectivity = [subjVar.elinfo elect_select];
        save(fname, 'el_selectivity');
    catch
        error_subject = 1;
        fname = sprintf('%scomputation/%s/error_%s_%s_%s.csv',dirs.paper_results, hypothesis, task, s, hypothesis);
        csvwrite(fname, error_subject)
    end
else
end
end
