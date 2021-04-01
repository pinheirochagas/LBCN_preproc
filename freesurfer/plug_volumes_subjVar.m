function plug_volumes_subjVar(s)
% Import volumes in case there are none  volumes
dirs = InitializeDirs(' ', s); % 'Pedro_NeuroSpin2T'
load([dirs.original_data filesep  s filesep 'subjVar_'  s '.mat']);
if isfield(subjVar, 'V') == 0
    try
        fprintf('plugging volumes of subject %s\n', s)
        subjVar.V = importVolumes(dirs);
    catch
        fprintf('error in subject %s\n', s)
    end
else
end
save([dirs.original_data filesep  s filesep 'subjVar_'  s '.mat'], 'subjVar');

end

