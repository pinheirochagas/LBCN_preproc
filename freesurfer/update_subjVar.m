function update_subjVar(s, dirs)
% Import volumes in case there are none  volumes
load([dirs.original_data filesep  s filesep 'subjVar_'  s '.mat']);

% load regstats
[DOCID,GID] = getGoogleSheetInfo('outlier_electrodes_activity_profille','both');
ac_out = GetGoogleSpreadsheet(DOCID, GID);
% Correct from activity profile outliers

updates = [];
for i = 1:size(ac_out,1)
    if strcmp(s, ac_out.sbj_name{i}) & sum(strcmp(subjVar.elinfo.FS_label, ac_out.FS_label{i})) > 0
        chan_up = find(strcmp(s, ac_out.sbj_name{i}) & strcmp(subjVar.elinfo.FS_label, ac_out.FS_label{i}))
        subjVar.elinfo.DK_long_josef(chan_up) = ac_out.Change(i);
        sprintf('channel %s updated to %s', subjVar.elinfo.FS_label{chan_up},ac_out.Change{i})
        updates(i)=1;
    else
        
    end
    
end


if ~isempty(updates)
    sprintf('%s updateds for subject %s', num2str(sum(updates)), s)
    save([dirs.original_data filesep  s filesep 'subjVar_'  s '.mat'], 'subjVar');
else
end

end

