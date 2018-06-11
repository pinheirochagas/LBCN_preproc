function UpdateGlobalVarDirs(sbj_name, project_name, block_name, dirs)

% List folders to replace
folder_names = {'originalData', 'CARData', 'CompData', 'FiltData', ...
    'SpecData', 'HFBData', 'psych_dir', 'result_dir'};

% Load globalVar
fn = sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,block_name);
load(fn,'globalVar');

for i = 1:length(folder_names)
    globalVar.(folder_names{i}) = sprintf('%s/%s/%s/%s',dirs.data_root,folder_names{i},sbj_name, block_name);
end

% Save globalVar
save(fn,'globalVar');

end