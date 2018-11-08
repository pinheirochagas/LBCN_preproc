function UpdateGlobalVarDirs(sbj_name, project_name, block_names, dirs)

% List folders to replace
folder_names1 = {'originalData', 'CARData', 'BandData',...
    'SpecData', 'psych_dir', 'result_dir'};
folder_names2 = {'BandData','SpecData'};

for i = 1:length(block_names)
    bn = block_names{i};
    % Load globalVar
    fn = sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn);
    load(fn,'globalVar');
    
    for ii = 1:length(folder_names1)
        globalVar.(folder_names1{ii}) = sprintf('%s/%s/%s/%s',dirs.data_root,folder_names1{ii},sbj_name, bn);
    end
    
    for ii = 1:length(folder_names2)
        globalVar.(folder_names2{ii}) = sprintf('%s/%s/',dirs.data_root,folder_names2{ii});
    end
    
    % Save globalVar
    save(fn,'globalVar');
end

end