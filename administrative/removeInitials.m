function sbj_name_noinit = removeInitials(s)

sbj_name_noinit = strsplit(s, '_');
sbj_name_noinit = strjoin(sbj_name_noinit(1:2),'_');

end

