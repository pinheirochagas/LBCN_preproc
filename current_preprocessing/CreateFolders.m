function CreateFolders(sbj_name, project_name, block_name, center, dirs)
% Create folders LBCN
folder_names = {'originalData', 'CARData', 'CompData', 'FiltData', ...
    'SpecData', 'HFBData'};

%% Per subject
for i = 1:length(folder_names)
    folders.(folder_names{i}) = sprintf('%s/%s/%s',dirs.data_root,folder_names{i},sbj_name, data_format);
end
folders.psych_dir = sprintf('%s/%s',dirs.psych_root,sbj_name);
folders.result_dir = sprintf('%s/%s/%s',dirs.result_root,project_name,sbj_name);

fieldname_folders = fieldnames(folders);

for i = 1:length(fieldname_folders)
    if ~exist(folders.(fieldname_folders{i}))
        mkdir(folders.(fieldname_folders{i}));
    end
end

%% Per block - create folders and globalVar
globalVar.sbj_name = sbj_name;
globalVar.project_name = project_name;
globalVar.center = center;


for bn = 1:length(block_name)
    globalVar.block_name = block_name{bn};
    for i = 1:length(fieldname_folders)
        globalVar.(fieldname_folders{i}) = [folders.(fieldname_folders{i}) '/' block_name{bn}];
        if ~exist(globalVar.(fieldname_folders{i}))
            mkdir(globalVar.(fieldname_folders{i}));
        end
        if strcmp(fieldname_folders{i}, 'psych_dir') || strcmp(fieldname_folders{i}, 'result_dir') || strcmp(fieldname_folders{i}, 'originalData') 
        else
            if ~exist([globalVar.(fieldname_folders{i}) '/EpochData'])
                mkdir([globalVar.(fieldname_folders{i}) '/EpochData']);
            end
        end
    end
    %% Original folders from the server
    % iEEG data
    if strcmp(data_format, 'TDT')
        msgbox(['Choose server folder for iEEG data of block ' block_name{bn}])
        globalVar.iEEG_data_server_path = [uigetdir('/Volumes/neurology_jparvizi$/') '/'];
    elseif strcmp(data_format, 'edf')
        msgbox(['Choose server folder for iEEG data of block ' block_name{bn}])
        [FILENAME, PATHNAME] = uigetfile(['/Volumes/neurology_jparvizi$/' '/']);
        globalVar.iEEG_data_server_path = [FILENAME, PATHNAME];
    else
    end
    % Behavioral data
    msgbox(['Choose file path for behavioral data on the server for block' block_name{bn}])
    [FILENAME, PATHNAME] = uigetfile(['/Volumes/neurology_jparvizi$/' '/']);
    globalVar.behavioral_data_server_path = [PATHNAME, FILENAME];

    % Save globalVariable
    fn = [folders.originalData '/' sprintf('global_%s_%s_%s.mat',project_name,sbj_name,block_name{bn})];
    save(fn,'globalVar');
end



end




