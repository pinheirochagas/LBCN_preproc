function ElectSelectivityStimRespAll(task, s, hypothesis, datatype, freq_band, dirs)

% Get parameters
cfg = [];
[cfg.column,cfg.conds] = getCondNames(task, hypothesis);
cfg.stats_params = genStatsParams(task, hypothesis);

fname = sprintf('%scomputation/%s/%s_%s_%s.mat',dirs.paper_results, hypothesis, task, s, hypothesis);

if ~exist(fname,'file')
    load([dirs.original_data filesep  s filesep 'subjVar_'  s '.mat']);
    fprintf('processing subject %s\n', s)
    block_names = BlockBySubj(s,task);
    
    % Try to run, but some subjects did not have resp lock epoched data, so...
    try
        elect_select = ElectSelectivityStimResp(s, task, block_names, dirs, cfg.column, cfg.conds, datatype, freq_band, cfg.stats_params);
    catch
        fprintf('epoching resp lock for subject %s\n', s)
        load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,s,task,s,block_names{1}),'globalVar');
        elecs = setdiff(1:globalVar.nchan,globalVar.refChan);
        epoch_params = genEpochParams(task, 'resp');
        for i = 1:length(block_names)
            bn = block_names{i};
            parfor ei = 1:length(elecs)
                EpochDataAll(s, task, bn, dirs,elecs(ei), 'HFB', [],[], epoch_params,'Band')
                %          EpochDataAll(sbj_name, project_name, bn, dirs, elecs(ei), 'SpecDense', [],[], epoch_params,'Spec')
            end
        end
        elect_select = ElectSelectivityStimResp(s, task, block_names, dirs, cfg.column, cfg.conds, datatype, freq_band, cfg.stats_params);
    end
    
    el_selectivity = [subjVar.elinfo elect_select];
    save(fname, 'el_selectivity');
else
end

end
