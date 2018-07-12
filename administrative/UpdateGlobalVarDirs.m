function UpdateGlobalVarDirs(sbj_name, project_name, block_names, dirs)

% List folders to replace
folder_names = {'originalData', 'CARData', 'CompData', 'FiltData', ...
    'SpecData', 'HFBData', 'psych_dir', 'result_dir'};

for i = 1:length(block_names)
    bn = block_names{i};
    % Load globalVar
    fn = sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn);
    load(fn,'globalVar');
    
    for ii = 1:length(folder_names)
        globalVar.(folder_names{ii}) = sprintf('%s/%s/%s/%s',dirs.data_root,folder_names{ii},sbj_name, bn);
    end
    
    % Save globalVar
    save(fn,'globalVar');
end

end