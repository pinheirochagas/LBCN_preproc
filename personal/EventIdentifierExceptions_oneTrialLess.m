function all_stim_onset = EventIdentifierExceptions_oneTrialLess(all_stim_onset, sbj_name,project_name, bn)


if strcmp(sbj_name, 'S14_62_JW') && strcmp(project_name, 'MMR')
    all_stim_onset = all_stim_onset(1:end-1); % DANGEROUS EXCEPTION
elseif strcmp(sbj_name, 'S14_66_CZ') && strcmp(project_name, 'MMR')
    all_stim_onset = all_stim_onset(1:end-1); % DANGEROUS EXCEPTION
elseif strcmp(sbj_name, 'S14_67_RH') && strcmp(bn, 'S14_67_RH_01')
    all_stim_onset = all_stim_onset(1:end-1); % DANGEROUS EXCEPTION
elseif strcmp(sbj_name, 'S14_67_RH') && strcmp(bn, 'S14_67_RH_04')
    all_stim_onset = all_stim_onset(1:end-2); % DANGEROUS EXCEPTION
end

end