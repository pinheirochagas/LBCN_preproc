function stim_onset = EventIdentifierExceptions_moreTriggersCalculia(stim_onset, stim_offset, sbj_name,project_name, bn)

if strcmp(sbj_name, 'S15_87_RL') && strcmp(project_name, 'Calculia') && (strcmp(bn, 'E15-282_0025') || strcmp(bn, 'E15-282_0026') || strcmp(bn, 'E15-282_0027'))
    stim_onset = stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S15_92_MR') && strcmp(project_name, 'Calculia')
    stim_onset = stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S16_93_MA') && strcmp(project_name, 'Calculia')
    stim_onset = stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S16_94_DR') && (strcmp(bn, 'E16-168_0021'))
    stim_onset = stim_onset(1:end-1);    
elseif strcmp(sbj_name, 'S16_94_DR') && (strcmp(bn, 'E16-168_0022'))
    stim_onset = stim_onset(3:end);
    % elseif strcmp(sbj_name, 'S16_94_DR') && (strcmp(bn, 'E16-168_0023'))
    %     stim_onset = stim_onset(9:end-4);
elseif strcmp(sbj_name, 'S14_62_JW') && (strcmp(bn, 'S14_62_42'))
    stim_onset = stim_onset(2:end);
elseif strcmp(sbj_name, 'S14_62_JW') && (strcmp(bn, 'S14_62_43'))
    stim_onset = stim_onset(2:end);
elseif strcmp(sbj_name, 'S14_62_JW') && (strcmp(bn, 'S14_62_44'))
    stim_onset = stim_onset(3:end);
elseif strcmp(sbj_name, 'S14_64_SP') && (strcmp(bn, 'S14_64_SP_12'))
    stim_onset = stim_onset(3:end);
elseif strcmp(sbj_name, 'S14_64_SP') && (strcmp(bn, 'S14_64_SP_15'))
    stim_onset = stim_onset(2:end);
elseif strcmp(sbj_name, 'S15_89_JQa') && (strcmp(bn, 'E15-497_0008'))
    stim_onset = stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S15_89_JQa') && (strcmp(bn, 'E15-497_0009'))
    stim_onset = stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S15_89_JQa') && (strcmp(bn, 'E15-497_0010'))
    stim_onset = stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S15_89_JQa') && (strcmp(bn, 'E15-497_0011'))
    stim_onset = stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S15_89_JQa') && (strcmp(bn, 'E15-497_0012'))
    stim_offset = stim_offset(1:end-1);
    stim_onset = stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S15_89_JQa') && (strcmp(bn, 'E15-497_0013'))
    stim_onset = stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S15_89_JQa') && (strcmp(bn, 'E15-497_0014'))
    stim_onset = stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S15_89_JQa') && (strcmp(bn, 'E15-497_0015'))
    stim_onset = stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S15_91_RP') && (strcmp(bn, 'E15_695_0017')) || (strcmp(bn, 'E15_695_0018'))
    stim_onset = stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S16_96_LF') && (strcmp(bn, 'E16-429_0006'))
    stim_onset = stim_onset(1:end-2);
elseif strcmp(sbj_name, 'S16_96_LF') && (strcmp(bn, 'E16-429_0007'))
    stim_onset = stim_onset(1:end-3);
elseif strcmp(sbj_name, 'S15_90_SO') && (strcmp(bn, 'E15-579_0011'))
    stim_onset = stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S15_90_SO') && (strcmp(bn, 'E15-579_0015'))
    stim_onset = stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S16_97_CHM') && (strcmp(bn, 'E16-517_0015'))
    stim_onset = stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S16_97_CHM') && (strcmp(bn, 'E16-517_0016'))
    stim_onset = stim_onset(1:end-1);
% elseif strcmp(sbj_name, 'S16_97_CHM') && (strcmp(bn, 'E16-517_0014'))
%     stim_onset = stim_onset(1:end-1);  '

elseif strcmp(sbj_name, 'S17_105_TA') && (strcmp(bn, 'E17-58_0014'))
    stim_onset = stim_onset(1:end-4);
elseif strcmp(sbj_name, 'S14_66_CZ') && (strcmp(bn, 'S14_66_CZ_26'))
    stim_onset = stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S14_66_CZ') && (strcmp(bn, 'S14_66_CZ_30'))
    stim_onset = stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S14_66_CZ') && (strcmp(bn, 'S14_66_CZ_37'))
    stim_onset = stim_onset(1:end-1);
elseif strcmp(sbj_name, 'S14_66_CZ') && (strcmp(bn, 'S14_66_CZ_40'))
    stim_onset = stim_onset(1:end-1);



end
end

