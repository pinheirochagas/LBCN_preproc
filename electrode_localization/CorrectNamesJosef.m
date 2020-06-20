function j_table = CorrectNamesJosef(j_table)

josef_names_corrected = readtable('/Volumes/LBCN8T/Stanford/data/electrode_localization/josef_names_update.xlsx');

for i = 1:size(j_table,1)
    
    idx_name = find(strcmp(josef_names_corrected.name,j_table.DK_long_josef{i}));
    if ~isempty(idx_name)
        j_table.DK_long_josef{i} = josef_names_corrected.name_corrected{idx_name};
    else
    end
    
end


