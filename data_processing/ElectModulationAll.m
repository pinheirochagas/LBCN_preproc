function ElectModulationAll(task, s, hypothesis, dirs)

tag = 'stim';
[column,conds] = getCondNames(task, hypothesis);
mod_par = genModulationParams(task,hypothesis);

fname = sprintf('%smodulation/%s/%s_%s_%s.mat',dirs.paper_results, hypothesis, task, s, hypothesis);

if ~exist(fname,'file')
    load([dirs.original_data filesep  s filesep 'subjVar_'  s '.mat']);
    fprintf('processing subject %s\n', s)
    block_names = BlockBySubj(s,task);
    
    try
        reg_stats = ElectModulation(s,task, block_names, dirs, 'Band', 'HFB', mod_par);
        fname = sprintf('%smodulation/%s/%s_%s_%s.mat',dirs.paper_results, hypothesis, task, s, hypothesis);
        save(fname, 'reg_stats');
    catch
        
        error_subject = 1;
        fname = sprintf('%smodulation/%s/error_%s_%s_%s.csv',dirs.paper_results, hypothesis, task, s, hypothesis);
        csvwrite(fname, error_subject)
    end
else
    fprintf(' for subject %s were already computed', s)
    
end
end
