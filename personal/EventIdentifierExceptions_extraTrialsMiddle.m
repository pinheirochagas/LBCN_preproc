function all_stim_onset = EventIdentifierExceptions_extraTrialsMiddle(all_stim_onset, StimulusOnsetTime, sbj_name, project_name, bn)

if strcmp(sbj_name, 'S13_46_JDB') && strcmp(project_name, 'MMR') && strcmp(bn, 'JDB_01')
    all_stim_onset = StimulusOnsetTime;
    warning('using psychtoolbox output - diagnostic plots are meaningless')
elseif strcmp(sbj_name, 'S13_54_KDH') && strcmp(project_name, 'MMR') && strcmp(bn, 'KDH_03')
    all_stim_onset = StimulusOnsetTime;
    warning('using psychtoolbox output - diagnostic plots are meaningless')
elseif  strcmp(sbj_name, 'S13_59_SRR') && strcmp(project_name, 'MMR') && strcmp(bn, 'SRR_02')
    all_stim_onset = StimulusOnsetTime;
    warning('using psychtoolbox output - diagnostic plots are meaningless')
elseif strcmp(sbj_name, 'S14_65_HN') && strcmp(project_name, 'MMR') && strcmp(bn, 'S14_65_HN_05')
    all_stim_onset = StimulusOnsetTime;
    warning('using psychtoolbox output - diagnostic plots are meaningless')
elseif strcmp(sbj_name, 'S15_81_RM') && strcmp(project_name, 'MMR') && strcmp(bn, 'S15_81_RM_04')
    all_stim_onset = StimulusOnsetTime;
    warning('using psychtoolbox output - diagnostic plots are meaningless')
elseif strcmp(sbj_name, 'S11_26_SRb') && strcmp(project_name, 'UCLA') && strcmp(bn, 'SRb-17')
    all_stim_onset = StimulusOnsetTime;
    warning('using psychtoolbox output - diagnostic plots are meaningless')
elseif strcmp(sbj_name, 'S15_89_JQa') && strcmp(project_name, 'Calculia') && strcmp(bn, 'E15-497_0008')
    all_stim_onset = StimulusOnsetTime;
    warning('using psychtoolbox output - diagnostic plots are meaningless')
elseif strcmp(sbj_name, 'S10_15_KB2') && strcmp(bn, 'KB0510_01')
    all_stim_onset = StimulusOnsetTime;
    warning('using psychtoolbox output - diagnostic plots are meaningless')
elseif strcmp(sbj_name, 'S12_41_KS') && strcmp(project_name, 'MMR') && strcmp(bn, 'KS_13')
    all_stim_onset = StimulusOnsetTime;
    warning('using psychtoolbox output - diagnostic plots are meaningless')  
elseif strcmp(sbj_name, 'S11_25_DL') && strcmp(project_name, 'UCLA') && strcmp(bn, 'dl_44')
    all_stim_onset = StimulusOnsetTime;
    warning('using psychtoolbox output - diagnostic plots are meaningless')  
elseif strcmp(sbj_name, 'S09_07_CM') && strcmp(project_name, 'UCLA') && strcmp(bn, 'ST07-07')
    all_stim_onset = StimulusOnsetTime;
    warning('using psychtoolbox output - diagnostic plots are meaningless')    
    
end

end