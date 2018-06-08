function CopyFilesServer(sbj_name,project_name, block_name,data_format,dirs)


% Load globalVar
sbj_name_split = strsplit(sbj_name, '_');
sbj_name_anno = [sbj_name_split{1} '_' sbj_name_split{2}];

    
fn = sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name_anno,project_name,sbj_name_anno,block_name);
load(fn,'globalVar');
% Data path server

if strcmp(data_format, 'nihon_kohden')
    
    data_ieeg_path = sprintf('%sSHICEP_%s/%s(Data ECoG)/TDT Data/%s/%s',dirs.server_root,sbj_name, sbj_name, sbj_name, block_name);
    data_behavior_path = sprintf('%sSHICEP_%s/Analyzed Data/%s/Beh/',dirs.server_root,sbj_name, project_name);
    
    % List all iEEG files
    iEEG_names = dir(fullfile(data_ieeg_path, '*.mat')); % actually take all channels, including pdio
    % Copy iEEG files to corresponding folder
    for i = 1:length(iEEG_names)
        fn = [iEEG_names(i).folder '/' iEEG_names(i).name];
        copyfile(fn, globalVar.originalData)
        disp(sprintf('Copied iEEG file %s to %s', fn, globalVar.originalData))
    end
    
    % Copy behavioral file
    soda_name = dir(fullfile(data_behavior_path, sprintf('sodata.%s*.mat', block_name)));
    fn = [soda_name.folder '/' soda_name.name];
    copyfile(fn, globalVar.psych_dir)
    disp(sprintf('Copied behavioral file %s to %s', fn, globalVar.originalData))
    
elseif strcmp(data_format, 'edf')
    
    data_ieeg_path = sprintf('%sSHICEP_%s/Data_ECoG/%s/%s/%s',dirs.server_root,sbj_name, project_name);
    data_behavior_path = sprintf('%sSHICEP_%s/Data_Behavioral/%s/Beh/',dirs.server_root,sbj_name, project_name);
    
    iEEG_name = dir(fullfile(data_ieeg_path, sprintf('%s*.edf', block_name)));
    fn = [iEEG_name.folder '/' iEEG_name.name];
    copyfile(fn, globalVar.originalData)

    soda_name = dir(fullfile(data_behavior_path, sprintf('sodata.%s*.mat', block_name)));
    % for the moment let it manual to complete
else
end


end

