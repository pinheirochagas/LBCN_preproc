initialize_dirs

sbj = 'S12_41_KS';
BN = 'KS_09';

oldstr = 'KS_09';
new_str = 'S12_41_09';

data_dir = [data_root,'/OriginalData/',sbj,'/',BN,'/'];
cd(data_dir)
mkdir('Anonymized')

EEGfiles = dir('*iEEG*');

for fi = 1:length(EEGfiles)
    currName = EEGfiles(1).name;
end

