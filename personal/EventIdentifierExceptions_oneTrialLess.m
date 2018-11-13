function all_stim_onset = EventIdentifierExceptions_oneTrialLess(all_stim_onset, sbj_name,project_name, bn)


if strcmp(sbj_name, 'S14_62_JW') && strcmp(project_name, 'MMR')
    all_stim_onset = all_stim_onset(1:end-1); % DANGEROUS EXCEPTION
elseif strcmp(sbj_name, 'S14_66_CZ') && strcmp(project_name, 'MMR')
    all_stim_onset = all_stim_onset(1:end-1); % DANGEROUS EXCEPTION
elseif strcmp(sbj_name, 'S14_67_RH') && strcmp(bn, 'S14_67_RH_01')
    all_stim_onset = all_stim_onset(1:end-1); % DANGEROUS EXCEPTION
elseif strcmp(sbj_name, 'S14_67_RH') && strcmp(bn, 'S14_67_RH_04')
    all_stim_onset = all_stim_onset(1:end-2); % DANGEROUS EXCEPTION
elseif strcmp(sbj_name, 'S15_83_RR') && strcmp(bn, 'S15_83_RR_08')
    all_stim_onset = all_stim_onset(1:end-1); % DANGEROUS EXCEPTION  
elseif strcmp(sbj_name, 'S15_92_MR') && strcmp(bn, 'E15-770_0018')
    all_stim_onset = all_stim_onset(1:end-1); % DANGEROUS EXCEPTION 
elseif strcmp(sbj_name, 'S12_34_TC') && strcmp(bn, 'TC0212-10')
    all_stim_onset = all_stim_onset(1:end-4); % DANGEROUS EXCEPTION  
elseif strcmp(sbj_name, 'S13_54_KDH') && strcmp(project_name, 'MMR') && strcmp(bn, 'KDH_04')
    all_stim_onset = all_stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S14_65_HN') && strcmp(project_name, 'MMR') && strcmp(bn, 'S14_65_HN_02')
    all_stim_onset = all_stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S14_68_NB') && strcmp(project_name, 'MMR') && strcmp(bn, 'S14_68_NB_01')
    all_stim_onset = all_stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S15_89_JQa') && strcmp(project_name, 'MMR') && (strcmp(bn, 'E15-497_0007') ||  strcmp(bn,'E15-497_0006'))
    all_stim_onset = all_stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S16_100_AF') && strcmp(project_name, 'MMR') && strcmp(bn, 'E16-950_0003')
    all_stim_onset = all_stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S16_97_CHM') && strcmp(project_name, 'MMR') && strcmp(bn, 'E16-517_0008')
    all_stim_onset = all_stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S15_84_KG') && strcmp(project_name, 'MMR') && strcmp(bn, 'S15_84_KG_02')
    all_stim_onset = all_stim_onset(1:end-2);
elseif strcmp(sbj_name, 'S15_84_KG') && strcmp(project_name, 'MMR') && strcmp(bn, 'S15_84_KG_04')
    all_stim_onset = all_stim_onset(1:end-1);    
end

end