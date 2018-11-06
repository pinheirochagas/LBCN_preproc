function stim_onset = EventIdentifierExceptions_moreTriggersCalculia(sbj_name,project_name, bn)

if strcmp(sbj_name, 'S15_87_RL') && strcmp(project_name, 'Calculia') && (strcmp(bn, 'E15-282_0025') || strcmp(bn, 'E15-282_0026') || strcmp(bn, 'E15-282_0027'))
    stim_onset = stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S15_92_MR') && strcmp(project_name, 'Calculia')
    stim_onset = stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S16_93_MA') && strcmp(project_name, 'Calculia')
    stim_onset = stim_onset(1:end-1);
end

end

