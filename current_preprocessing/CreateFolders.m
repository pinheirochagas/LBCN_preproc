function CreateFolders(sbj_name, project_name, block_name, dirs)
% Create folders LBCN
folder_names = {'originalData', 'CARData', 'CompData', 'FiltData', ...
                'reRefData', 'SpecData', 'NormData'};
            
dir_names = {'data_dir', 'CAR_dir', 'Comp_dir', 'Filt_dir', ...
              'reRef_dir', 'Spec_dir', 'HFB_dir'};         
            

%% Per subject
for i = 1:length(folder_names)
    folders.(dir_names{i}) = sprintf('%s/%s/%s',dirs.data_root,folder_names{i},sbj_name);
end
folders.psych_dir = sprintf('%s/%s',dirs.psych_root,sbj_name);
folders.result_dir = sprintf('%s/%s/%s',dirs.result_root,project_name,sbj_name);

fieldname_folders = fieldnames(folders);

for i = 1:length(fieldname_folders)
    if ~exist(folders.(fieldname_folders{i}));
        mkdir(folders.(fieldname_folders{i}));
    end
end

%% Per block - create folders and globalVar
globalVar.sbj_name = sbj_name;
globalVar.project_name = project_name;

for bn = 1:length(block_name)
    globalVar.block_name = block_name{bn}; 
    for i = 1:length(fieldname_folders)
    globalVar.(fieldname_folders{i}) = [folders.(fieldname_folders{i}) '/' block_name{bn}];
    if ~exist(globalVar.(fieldname_folders{i}))
        mkdir(globalVar.(fieldname_folders{i}));
    end
    end
    % Save globalVariable
    fn = [folders.data_dir '/' sprintf('global_%s_%s_%s.mat',project_name,sbj_name,block_name{bn})];
    save(fn,'globalVar');
end
    
 
end




