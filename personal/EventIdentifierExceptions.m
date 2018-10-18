function [n_initpulse_onset,n_initpulse_offset] = EventIdentifierExceptions(sbj_name,project_name, bn)

if strcmp(sbj_name, 'S17_110_SC') || strcmp(sbj_name,'S12_38_LK') || strcmp(sbj_name,'S13_47_JT2')
    n_initpulse_onset=12;
    n_initpulse_offset=12;
end

if strcmp(project_name, 'UCLA') || strcmp(project_name, 'Calculia_production') || strcmp(project_name, 'MMR')
    n_initpulse_onset = 12; n_initpulse_offset = 12;
else
end

if strcmp(sbj_name, 'S09_07_CM') && strcmp(project_name, 'UCLA') && strcmp(bn, 'ST07-07')
    n_initpulse_onset = 0; n_initpulse_offset = 0;
elseif strcmp(sbj_name, 'S12_36_SrS') && strcmp(project_name, 'MMR') && strcmp(bn, 'SrS_09')
    n_initpulse_onset = 10; n_initpulse_offset = 10;
elseif strcmp(sbj_name, 'S13_53_KS2') && strcmp(project_name, 'MMR') && strcmp(bn, 'KS2_02')
    n_initpulse_onset = 13; n_initpulse_offset = 13;
elseif strcmp(sbj_name, 'S14_64_SP') && strcmp(project_name, 'MMR') && strcmp(bn, 'S14_64_SP_02')
    n_initpulse_onset = 14; n_initpulse_offset = 14;   
elseif strcmp(sbj_name, 'S14_66_CZ') && strcmp(project_name, 'MMR') && strcmp(bn, 'S14_66_CZ_11')
    n_initpulse_onset = 14; n_initpulse_offset = 14;   
elseif strcmp(sbj_name, 'S14_67_RH') && strcmp(project_name, 'MMR') && strcmp(bn, 'S14_67_RH_01')
    n_initpulse_onset = 8; n_initpulse_offset = 8;     
elseif strcmp(sbj_name, 'S14_67_RH') && strcmp(project_name, 'MMR') && strcmp(bn, 'S14_67_RH_04')
    n_initpulse_onset = 14; n_initpulse_offset = 14;     
end
end

