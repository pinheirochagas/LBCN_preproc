function [n_initpulse_onset,n_initpulse_offset] = EventIdentifierExceptions(sbj_name,project_name, bn, n_initpulse_onset, n_initpulse_offset)

% default:

if strcmp(project_name, 'MMR')
    n_initpulse_onset=12;
    n_initpulse_offset=12; 
else
    if n_initpulse_onset == 0 && n_initpulse_offset == 0
    else
        n_initpulse_onset=12;
        n_initpulse_offset=12;
    end
end

% exceptions: 
if strcmp(sbj_name, 'S09_07_CM') && strcmp(project_name, 'UCLA') && strcmp(bn, 'ST07-07')
    n_initpulse_onset = 0; n_initpulse_offset = 0;
elseif strcmp(sbj_name, 'S12_36_SrS') && strcmp(project_name, 'MMR') && strcmp(bn, 'SrS_09')
    n_initpulse_onset = 8; n_initpulse_offset = 8;
elseif strcmp(sbj_name, 'S13_50_LGM') && strcmp(bn, 'LGM_13')
    n_initpulse_onset = 4; n_initpulse_offset = 4;    
elseif strcmp(sbj_name, 'S13_53_KS2') && strcmp(project_name, 'MMR') && strcmp(bn, 'KS2_02')
    n_initpulse_onset = 13; n_initpulse_offset = 13;
elseif strcmp(sbj_name, 'S14_64_SP') && strcmp(project_name, 'MMR') && strcmp(bn, 'S14_64_SP_02')
    n_initpulse_onset = 14; n_initpulse_offset = 14;   
elseif strcmp(sbj_name, 'S14_66_CZ') && strcmp(project_name, 'MMR') && strcmp(bn, 'S14_66_CZ_11')
    n_initpulse_onset = 14; n_initpulse_offset = 14;  
elseif strcmp(sbj_name,'S18_129') && strcmp(bn,'E18-767_0016')
    n_initpulse_onset = 11; n_initpulse_offset = 11; 
elseif strcmp(sbj_name,'S18_128') && strcmp(bn,'E18-739_0002')
    n_initpulse_onset = 0; n_initpulse_offset = 0;     
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
elseif strcmp(sbj_name, 'S13_56_THS') && strcmp(project_name, 'MMR') && strcmp(bn, 'ST33_07')
    n_initpulse_onset = 1; n_initpulse_offset = 1;
elseif strcmp(sbj_name, 'S13_56_THS') && strcmp(project_name, 'MMR') && strcmp(bn, 'ST33_08')
    n_initpulse_onset = 0; n_initpulse_offset = 0;
elseif strcmp(sbj_name, 'S14_69_RTa') && strcmp(project_name, 'MMR') && strcmp(bn, 'S14_69_RT_02')
    n_initpulse_onset = 13; n_initpulse_offset = 13;
elseif strcmp(sbj_name, 'S14_65_HN') && strcmp(project_name, 'MMR') && strcmp(bn, 'S14_65_HN_05')
    n_initpulse_onset = 14; n_initpulse_offset = 14;
elseif strcmp(sbj_name, 'S14_65_HN') && strcmp(project_name, 'MMR') && strcmp(bn, 'S14_65_HN_02')
    n_initpulse_onset = 8; n_initpulse_offset = 8;
elseif strcmp(sbj_name, 'S14_68_NB') && strcmp(project_name, 'MMR') && strcmp(bn, 'S14_68_NB_01')
    n_initpulse_onset = 13; n_initpulse_offset = 13;
elseif strcmp(sbj_name, 'S14_73_AY') && strcmp(project_name, 'MMR') && strcmp(bn, 'S14_73_AY_04')
    n_initpulse_onset = 13; n_initpulse_offset = 13;
elseif strcmp(sbj_name, 'S14_73_AY') && strcmp(project_name, 'MMR') && strcmp(bn, 'S14_73_AY_05')
    n_initpulse_onset = 14; n_initpulse_offset = 14;
elseif strcmp(sbj_name, 'S15_81_RM') && strcmp(project_name, 'MMR') && strcmp(bn, 'S15_81_RM_04')
    n_initpulse_onset = 13; n_initpulse_offset = 13;
elseif strcmp(sbj_name, 'S16_95_JOB') && strcmp(project_name, 'MMR') && strcmp(bn, 'E16-345_0012')
    n_initpulse_onset = 13; n_initpulse_offset = 13;
elseif strcmp(sbj_name, 'S11_20_RHa') && strcmp(project_name, 'UCLA') && strcmp(bn, 'RH0211-02')
    n_initpulse_onset = 13; n_initpulse_offset = 13;
elseif strcmp(sbj_name, 'S11_26_SRb') && strcmp(project_name, 'UCLA') && strcmp(bn, 'SRb-17')
    n_initpulse_onset = 16; n_initpulse_offset = 16;
elseif strcmp(sbj_name, 'S11_26_SRa') && strcmp(project_name, 'UCLA') && strcmp(bn, 'SR-10')
    n_initpulse_onset = 13; n_initpulse_offset = 13;
elseif strcmp(sbj_name, 'S15_87_RL') && strcmp(project_name, 'Calculia') && strcmp(bn, 'E15-282_0016')
    n_initpulse_onset = 0; n_initpulse_offset = 0;
elseif strcmp(sbj_name, 'S15_92_MR') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 0; n_initpulse_offset = 0;
elseif strcmp(sbj_name, 'S16_93_MA') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 14; n_initpulse_offset = 14;  
elseif strcmp(sbj_name, 'S12_33_DA') && strcmp(bn, 'DA0112-_07')
    n_initpulse_onset = 5; n_initpulse_offset = 5;  
elseif strcmp(sbj_name, 'S11_26_SRa') && strcmp(bn, 'SR-03')
    n_initpulse_onset = 12; n_initpulse_offset = 12;  
elseif strcmp(sbj_name, 'S10_15_KB2') && (strcmp(bn, 'KB0510_01') || strcmp(bn, 'KB0510_03')) 
    n_initpulse_onset = 12; n_initpulse_offset = 12; 
elseif strcmp(sbj_name, 'S11_22_EG') && strcmp(bn, 'EG0311-23')
    n_initpulse_onset = 19; n_initpulse_offset = 19; 
elseif strcmp(sbj_name, 'S17_106_SD') && strcmp(bn, 'E17-107_0008')
    n_initpulse_onset = 11; n_initpulse_offset = 11; 
elseif strcmp(sbj_name, 'S17_106_SD') && strcmp(bn, 'E17-107_0010')
    n_initpulse_onset = 8; n_initpulse_offset = 8; 
elseif strcmp(sbj_name, 'S17_106_SD') && strcmp(bn, 'E17-107_0011')
    n_initpulse_onset = 10; n_initpulse_offset = 10; 
elseif strcmp(sbj_name, 'S11_23_MD') && strcmp(project_name, 'UCLA') && strcmp(bn, 'MD0311-01')
    n_initpulse_onset = 12; n_initpulse_offset = 12;    
elseif strcmp(sbj_name, 'S12_45_LR') && strcmp(bn, 'LR_06')
    n_initpulse_onset = 13; n_initpulse_offset = 13;
elseif strcmp(sbj_name, 'S14_74_OD') && strcmp(bn, 'S14_74_OD_03')
    n_initpulse_onset = 13; n_initpulse_offset = 13;
elseif strcmp(sbj_name, 'S17_106_SD') && strcmp(bn, 'E17-107_0016')
    n_initpulse_onset = 9; n_initpulse_offset = 9;
elseif strcmp(sbj_name,'S15_90_SO') && strcmp(bn, 'E15-579_0011')
    n_initpulse_onset = 8; n_initpulse_offset = 8;
% elseif strcmp(sbj_name,'S16_97_CHM') && strcmp(bn, 'E16-517_0014')
%     n_initpulse_onset = 13; n_initpulse_offset = 12;    
elseif strcmp(sbj_name,'S14_64_SP') && strcmp(bn, 'S14_64_SP_39')
    n_initpulse_onset = 14; n_initpulse_offset = 14;
    
elseif strcmp(sbj_name, 'S15_83_RR') && strcmp(bn, 'S15_83_RR_17') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 9; n_initpulse_offset = 9;
elseif strcmp(sbj_name, 'S15_83_RR') && strcmp(bn, 'S15_83_RR_18') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 4; n_initpulse_offset = 4;
elseif strcmp(sbj_name, 'S14_69_RTa') && strcmp(bn, 'S14_69_RT_05') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 14; n_initpulse_offset = 14;
elseif strcmp(sbj_name, 'S14_68_NB') && strcmp(bn, 'S14_68_NB_08') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 13; n_initpulse_offset = 13;
elseif strcmp(sbj_name, 'S14_68_NB') && strcmp(bn, 'S14_68_NB_10') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 13; n_initpulse_offset = 13;    
elseif strcmp(sbj_name, 'S14_68_NB') && strcmp(bn, 'S14_68_NB_14') && strcmp(project_name, 'Calculia')  % 01/29: last version
    n_initpulse_onset = 2; n_initpulse_offset = 2;    
elseif strcmp(sbj_name, 'S14_68_NB') && strcmp(bn, 'S14_68_NB_15') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 1; n_initpulse_offset = 1;
elseif strcmp(sbj_name, 'S14_74_OD') && strcmp(bn, 'S14_74_OD_07') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 13; n_initpulse_offset = 13;
elseif strcmp(sbj_name, 'S14_75_TB') && strcmp(bn, 'S14_75_TB_08') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 14; n_initpulse_offset = 14;
elseif strcmp(sbj_name, 'S14_75_TB') && strcmp(bn, 'S14_75_TB_19') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 13; n_initpulse_offset = 13;
elseif strcmp(sbj_name, 'S15_82_JB') && strcmp(bn, 'S15_82_JB_12') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 8; n_initpulse_offset = 8;
elseif strcmp(sbj_name,'S10_12_AC') && strcmp(bn, 'AC0210_07')
    n_initpulse_onset = 14; n_initpulse_offset = 14;
elseif strcmp(sbj_name, 'S15_83_RR') && strcmp(bn, 'S15_83_RR_17') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 9; n_initpulse_offset = 9;
elseif strcmp(sbj_name, 'S15_83_RR') && strcmp(bn, 'S15_83_RR_18') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 4; n_initpulse_offset = 4;
elseif strcmp(sbj_name, 'S14_69_RTa') && strcmp(bn, 'S14_69_RT_05') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 14; n_initpulse_offset = 14;
elseif strcmp(sbj_name, 'S14_68_NB') && strcmp(bn, 'S14_68_NB_08') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 13; n_initpulse_offset = 13;
elseif strcmp(sbj_name, 'S14_68_NB') && strcmp(bn, 'S14_68_NB_10') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 13; n_initpulse_offset = 13;
elseif strcmp(sbj_name, 'S14_68_NB') && strcmp(bn, 'S14_68_NB_15') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 1; n_initpulse_offset = 1;
elseif strcmp(sbj_name, 'S14_73_AY') && strcmp(bn, 'S14_73_AY_20') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 14; n_initpulse_offset = 14;
elseif strcmp(sbj_name, 'S14_73_AY') && strcmp(bn, 'S14_73_AY_25') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 11; n_initpulse_offset = 11;
elseif strcmp(sbj_name, 'S14_74_OD') && strcmp(bn, 'S14_74_OD_07') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 13; n_initpulse_offset = 13;
elseif strcmp(sbj_name, 'S14_75_TB') && strcmp(bn, 'S14_75_TB_08') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 14; n_initpulse_offset = 14;
elseif strcmp(sbj_name, 'S14_75_TB') && strcmp(bn, 'S14_75_TB_19') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 13; n_initpulse_offset = 13;
elseif strcmp(sbj_name, 'S15_82_JB') && strcmp(bn, 'S15_82_JB_12') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 8; n_initpulse_offset = 8;
elseif strcmp(sbj_name, 'S17_105_TA') && strcmp(bn, 'E17-58_0013') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 4; n_initpulse_offset = 4;
elseif strcmp(sbj_name, 'S17_105_TA') && strcmp(bn, 'E17-58_0016') && strcmp(project_name, 'Calculia')
    n_initpulse_onset = 4; n_initpulse_offset = 4;
% 
% elseif strcmp(sbj_name, 'S14_66_CZ') && strcmp(bn, 'S14_66_CZ_26') && strcmp(project_name, 'Calculia')
%     n_initpulse_onset = 16; n_initpulse_offset = 16;
% elseif strcmp(sbj_name, 'S14_66_CZ') && strcmp(bn, 'S14_66_CZ_27') && strcmp(project_name, 'Calculia')
%     n_initpulse_onset = 14; n_initpulse_offset = 14;
% elseif strcmp(sbj_name, 'S14_66_CZ') && strcmp(bn, 'S14_66_CZ_30') && strcmp(project_name, 'Calculia')
%     n_initpulse_onset = 14; n_initpulse_offset = 14;
% elseif strcmp(sbj_name, 'S14_66_CZ') && strcmp(bn, 'S14_66_CZ_37') && strcmp(project_name, 'Calculia')
%     n_initpulse_onset = 8; n_initpulse_offset = 8;
% elseif strcmp(sbj_name, 'S14_66_CZ') && strcmp(bn, 'S14_66_CZ_39') && strcmp(project_name, 'Calculia')
%     n_initpulse_onset = 14; n_initpulse_offset = 14;
% elseif strcmp(sbj_name, 'S14_66_CZ') && strcmp(bn, 'S14_66_CZ_40') && strcmp(project_name, 'Calculia')
%     n_initpulse_onset = 14; n_initpulse_offset = 14;

elseif strcmp(sbj_name,'S14_66_CZ') && strcmp(project_name, 'Calculia') && strcmp(bn, 'S14_66_CZ_37')
    n_initpulse_onset = 8; n_initpulse_offset = 8;
elseif strcmp(sbj_name,'S14_66_CZ') && strcmp(project_name, 'Calculia') && strcmp(bn, 'S14_66_CZ_39')
    n_initpulse_onset = 14; n_initpulse_offset = 14;
elseif strcmp(sbj_name,'S14_66_CZ') && strcmp(project_name, 'Calculia') && strcmp(bn, 'S14_66_CZ_40')
    n_initpulse_onset = 14; n_initpulse_offset = 14;




elseif strcmp(sbj_name, 'S11_29_RB') && strcmp(project_name, 'UCLA')
    n_initpulse_onset = 12; n_initpulse_offset = 12;    
elseif strcmp(sbj_name, 'S13_56_THS') && strcmp(bn, 'THS_08')
    n_initpulse_onset = 13; n_initpulse_offset = 13;  
elseif strcmp(sbj_name, 'S11_28_LS') && strcmp(bn, 'LS0911-08')
    n_initpulse_onset = 12; n_initpulse_offset = 12;  

end
end

