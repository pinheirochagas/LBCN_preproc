function [n_initpulse_onset,n_initpulse_offset] = EventIdentifierExceptions(sbj_name,project_name, bn)

% default:
n_initpulse_onset=12;
n_initpulse_offset=12;

% exceptions: 
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
elseif strcmp(sbj_name,'S18_129') && strcmp(bn,'E18-767_0016')
    n_initpulse_onset = 11; n_initpulse_offset = 11;
elseif strcmp(sbj_name, 'S14_67_RH') && strcmp(project_name, 'MMR') && strcmp(bn, 'S14_67_RH_01')
    n_initpulse_onset = 8; n_initpulse_offset = 8;     
elseif strcmp(sbj_name, 'S14_67_RH') && strcmp(project_name, 'MMR') && strcmp(bn, 'S14_67_RH_04')
    n_initpulse_onset = 14; n_initpulse_offset = 14;
elseif strcmp(sbj_name, 'S12_33_DA') && strcmp(project_name, 'MMR') && strcmp(bn, 'DA0112-15')
    n_initpulse_onset = 13; n_initpulse_offset = 13; 
elseif strcmp(sbj_name, 'S12_34_TC') && strcmp(project_name, 'MMR') && strcmp(bn, 'TC0212-10')
    n_initpulse_onset = 13; n_initpulse_offset = 13;      
elseif strcmp(sbj_name, 'S15_87_RL') && strcmp(project_name, 'Calculia') && strcmp(bn, 'E15-282_0016')
    n_initpulse_onset = 0; n_initpulse_offset = 0;
elseif strcmp(sbj_name, 'S15_92_MR') && strcmp(project_name, 'Calculia') 
    n_initpulse_onset = 0; n_initpulse_offset = 0;   
elseif strcmp(sbj_name, 'S16_93_MA') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 14; n_initpulse_offset = 14;
end
end

