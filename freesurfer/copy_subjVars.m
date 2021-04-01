function copy_subjVars(s)
% Import volumes in case there are none  volumes
dirs = InitializeDirs(' ', s); % 'Pedro_NeuroSpin2T'
load([dirs.original_data filesep  s filesep 'subjVar_'  s '.mat']);
save(['/Users/pinheirochagas/Desktop/subjVars' filesep 'subjVar_'  s '.mat'], 'subjVar');
end

