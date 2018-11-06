function all_stim_onset = EventIdentifierExceptions_extraTrialsMiddle(all_stim_onset, StimulusOnsetTime, sbj_name, project_name, bn)

if strcmp(sbj_name, 'S13_46_JDB') && strcmp(project_name, 'MMR') && strcmp(bn, 'JDB_01')
    all_stim_onset = StimulusOnsetTime;
    warning('using psychtoolbox output - diagnostic plots are meaningless')
else
end

end