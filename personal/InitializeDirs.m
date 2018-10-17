function dirs = InitializeDirs(user,project_name,sbj_name,serverPath)
%% Initialize directories

% Stanford neurology server is default
if ~exist('serverPath', 'var')
    serverPath = '/Volumes/neurology_jparvizi$/';
end


% Get generic name without lower case to match the server 
if isstrprop(sbj_name(end),'lower')
    sbj_name_generic = sbj_name(1:end-1);
else
    sbj_name_generic = sbj_name;
end

if strcmp(user, 'Pedro_iMAC')
    dirs.comp_root = sprintf('/Volumes/LBCN8T/Stanford/data'); % location of analysis_ECOG folder
elseif strcmp(user,'Pedro_NeuroSpin4T')
    dirs.comp_root = sprintf('/Volumes/NeuroSpin4T/Stanford/data'); % location of analysis_ECOG folder
elseif strcmp(user,'Pedro_NeuroSpin2T')
    dirs.comp_root = sprintf('/Volumes/NeuroSpin2T/Stanford/data'); % location of analysis_ECOG folder
elseif strcmp(user,'Amy_iMAC')
    dirs.comp_root = sprintf('/Users/amydaitch/Documents/MATLAB/analysis_ECoG');
elseif strcmp(user,'Ying_iMAC')
    dirs.comp_root = sprintf('/Users/Ying/Documents/MATLAB/analysis_ECoG');
elseif strcmp(user,'Kevin_UCLA')
    dirs.comp_root = sprintf('/data/MMR/data');
end

dirs.server_root = serverPath;
dirs.data_root = sprintf('%s/neuralData',dirs.comp_root);
dirs.result_root = sprintf('%s/Results',dirs.comp_root);
dirs.psych_root = sprintf('%s/psychData',dirs.comp_root);
dirs.project = sprintf('%s/Results/%s',dirs.comp_root,project_name);
dirs.elec = sprintf('%s/ECoG Patient Info/Electrodes/Native_elecs',dirs.comp_root);
dirs.mni_elec = sprintf('%s/ECoG Patient Info/Electrodes/MNI_elecs',dirs.comp_root);
dirs.mni_cortex = sprintf('%s/ECoG Patient Info/Cortex/ColinCortex',dirs.comp_root);
dirs.cortex = sprintf('%s/ECoG Patient Info/Cortex/Native_cortex',dirs.comp_root);
dirs.ROI = sprintf('%s/ECoG Patient Info/ROIs',dirs.comp_root);
dirs.original_data = [dirs.data_root '/originalData'];

% Set freesurfer folder
all_folders = dir(fullfile(serverPath));
if isempty(all_folders)
    warning('You are not connected to the server, therefore no Fressurfer folder will be specified.')
else
    for i = 1:length(all_folders)
        tpm(i) = contains(all_folders(i).name, sbj_name_generic);
    end
    sbj_folder_name = all_folders(find(tpm == 1)).name;
    
    all_folders_sbj = dir(fullfile([serverPath sbj_folder_name]));
    for i = 1:length(all_folders_sbj)
        tpm_2(i) = contains(all_folders_sbj(i).name, 'surfer');
    end
    if sum(tpm_2) == 0
        warning('There is no Freesurfer folder')
        dirs.freesurfer = [];
    else
        dirs.freesurfer = [serverPath sbj_folder_name '/' all_folders_sbj(tpm_2).name '/'];
    end
end

end



