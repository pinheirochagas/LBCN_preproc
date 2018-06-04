function dirs = InitializeDirs(user,project_name)
% initialize directories

if strcmp(user, 'Pedro_iMAC')
    dirs.comp_root = sprintf('/Volumes/LBCN8T/Stanford/data'); % location of analysis_ECOG folder
elseif strcmp(user,'Pedro_NeuroSpin4T')
    dirs.comp_root = sprintf('/Volumes/NeuroSpin4T/Stanford/data'); % location of analysis_ECOG folder
elseif strcmp(user,'Amy_iMAC')
    dirs.comp_root = sprintf('/Volumes/LBCN8T/Stanford/data'); % location of analysis_ECOG folder
end

dirs.server_root = '/Volumes/neurology_jparvizi$/';
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

end

