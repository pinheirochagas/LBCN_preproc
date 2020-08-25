function ElecSelectivityAll(s, dirs, task, locktype, datatype, freq_band)

    % Get parameters
    [column,conds] = getCondNames(task);
    stats_params = genStatsParams(task);

    load([dirs.original_data filesep  s filesep 'subjVar_'  s '.mat']);
    fprintf('processing subject %s\n', s)
    block_names = BlockBySubj(s,task);
    try
        elect_select = ElectSelectivity(s, task, block_names, dirs, locktype, column, conds, datatype, freq_band, stats_params);
        el_selectivity = [subjVar.elinfo elect_select];
        fname = sprintf('%sel_selectivity/el_selectivity_%s_%s.mat',dirs.result_dir, s, task);
        save(fname, 'el_selectivity');
    catch
        fname = sprintf('%sel_selectivity/%s_%s_error.csv',dirs.result_dir, task, s);
        csvwrite(fname, 's')
    end
end
