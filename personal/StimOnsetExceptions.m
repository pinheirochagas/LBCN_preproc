function [stim_onset,stim_offset] = StimOnsetExceptions(sbj_name,bn,stim_onset,stim_offset)
% handles exception cases with missing photodiode pulses, etc.

switch sbj_name
    case 'S16_99_CJ'
        if strcmp(bn ,'E16-1107_0005')
            stim_onset = [stim_onset(1:97) NaN stim_onset(98:189) NaN stim_onset(190:end)];
            stim_offset = [stim_offset(1:97) NaN stim_offset(98:189) NaN stim_offset(190:end)];
        elseif strcmp(bn ,'E16-1107_0006')
            stim_onset = [stim_onset(1:107) NaN stim_onset(108:212) NaN stim_onset(213:end)];
            stim_offset = [stim_offset(1:107) NaN stim_offset(108:212) NaN stim_offset(213:end)];
        elseif strcmp(bn ,'E16-1107_0007')
            stim_onset = [stim_onset(1:56) NaN stim_onset(57:66) NaN stim_onset(67:end)];
            stim_offset = [stim_offset(1:56) NaN stim_offset(57:66) NaN stim_offset(67:end)];
        end
    case 'S17_105_TA'
        if strcmp(bn,'E17-58_0033')
            stim_onset = [stim_onset(1:62) NaN stim_onset(63:end)];
            stim_offset = [stim_offset(1:62) NaN stim_offset(63:end)];
        end
    case 'S16_100_AF'
        if strcmp(bn,'E16-950_0010')
            stim_onset = [stim_onset(1:200) NaN stim_onset(201:end)];
            stim_offset = [stim_offset(1:200) NaN stim_offset(201:end)];
        end
        
    case 'S14_67_RH'
        if strcmp(bn, 'S14_67_RH_08')
            stim_onset = [stim_onset(1:74) stim_onset(75:end)];
            stim_offset = [stim_offset(1:74) stim_offset(75:end)];
            stim_onset = stim_onset(1:end-2);
            stim_offset = stim_offset(1:end-2);
        elseif strcmp(bn, 'S14_67_RH_09')
            stim_onset = stim_onset(1:end-2);
            stim_offset = stim_offset(1:end-2);
        elseif strcmp(bn, 'S14_67_RH_12')
            stim_onset = stim_onset(1:end-2);
            stim_offset = stim_offset(1:end-2);
        elseif strcmp(bn, 'S14_67_RH_15')
            stim_onset = [stim_onset(1:120) stim_onset(122:end)];
            stim_offset = [stim_offset(1:120) stim_offset(122:end)];
            stim_onset = stim_onset(1:end-2);
            stim_offset = stim_offset(1:end-2);
        elseif strcmp(bn, 'S14_67_RH_16')
            stim_onset = [stim_onset(1:45) stim_onset(49:end)];
            stim_offset = [stim_offset(1:45) stim_offset(49:end)];
            stim_onset = stim_onset(1:end-2);
            stim_offset = stim_offset(1:end-2);
        end
        
    case 'S15_89_JQa'
        if strcmp(bn, 'E15-497_0008')
            stim_onset = [stim_onset(1:158) stim_onset(160:end)];
            stim_offset = [stim_offset(1:158) stim_offset(160:end)];
        elseif strcmp(bn, 'E15-497_0012')
            stim_onset = [stim_onset(1:20) stim_onset(22:44) stim_onset(46:end)];
            stim_offset = [stim_offset(1:20) stim_offset(22:44) stim_offset(46:end)];
        elseif strcmp(bn, 'E15-497_0013')
            stim_onset = [stim_onset(2:151) stim_onset(153:156)  stim_onset(158:160) stim_onset(161:end)];
            stim_offset = [stim_offset(2:151) stim_offset(153:156) stim_onset(158:160) stim_offset(161:end)];
        else
        end
        
    case 'S16_93_MA'
        if strcmp(bn, 'E16-022_0013')
            stim_onset = [stim_onset(1:23) stim_onset(25) stim_onset(26:end)];
            stim_offset = [stim_offset(1:23) stim_offset(25) stim_offset(26:end)];
        else
        end
    case 'S16_94_DR'
        if strcmp(bn, 'E16-168_0023')
            stim_onset = [stim_onset(9:112) stim_onset(114:end-48)];
            stim_offset = [stim_offset(9:112) stim_offset(114:end-48)];
        else
        end
        
    case 'S14_80_KBa'
        if strcmp(bn, 'S14_80_KB_22')
            stim_onset = [stim_onset(1:90) stim_onset(92:end)];
            stim_offset = [stim_offset(1:90) stim_offset(92:end)];
            stim_onset = [stim_onset(1:98) stim_onset(100:end)];
            stim_offset = [stim_offset(1:98) stim_offset(100:end)];
        end
    case 'S14_68_NB'
        if strcmp(bn, 'S14_68_NB_15')
            stim_onset = [stim_onset(1:235)];
            stim_offset = [stim_offset(1:235)];
        end
    case 'S14_74_OD'
        if strcmp(bn, 'S14_74_OD_06')
            stim_onset = [stim_onset(1:240)];
            stim_offset = [stim_offset(1:240)];
        elseif strcmp(bn, 'S14_74_OD_07')
            stim_onset = [stim_onset(1:240)];
            stim_offset = [stim_offset(1:240)];
        elseif strcmp(bn, 'S14_74_OD_08')
            stim_onset = [stim_onset(1:240)];
            stim_offset = [stim_offset(1:240)];
        end
    case 'S14_75_TB'
        if strcmp(bn, 'S14_75_TB_08')
            stim_onset = [stim_onset(1:100)];
            stim_offset = [stim_offset(1:100)];
        end
    case 'S14_76_AA'
        if strcmp(bn, 'S14_76_AA_06') || strcmp(bn, 'S14_76_AA_07') || strcmp(bn, 'S14_76_AA_08') || strcmp(bn, 'S14_76_AA_09') || strcmp(bn, 'S14_76_AA_11') || strcmp(bn, 'S14_76_AA_12') || strcmp(bn, 'S14_76_AA_13') || strcmp(bn, 'S14_76_AA_14')
            stim_onset = [stim_onset(1:240)];
            stim_offset = [stim_offset(1:240)];
        end
    case 'S14_78_RS'
        if strcmp(bn, 'S14_78_RS_13')
            stim_onset = [stim_onset(1:240)];
            stim_offset = [stim_offset(1:240)];
        elseif strcmp(bn, 'S14_78_RS_17')
            stim_onset = [stim_onset(1:24) stim_onset(26:62) stim_onset(64:end-1)];
            stim_offset = [stim_offset(1:24) stim_offset(26:62) stim_offset(64:end-1)];
        end
    case 'S14_66_CZ'
        if strcmp(bn, 'S14_66_CZ_30')
            stim_onset = [stim_onset(1:210) stim_onset(213:end)];
            stim_offset = [stim_offset(1:210) stim_offset(213:end)];
        end
    case 'S17_107_PR'
        if strcmp(bn,'E17-237_0013')
            stim_onset = [stim_onset(1:119) NaN stim_onset(120:end)];
            stim_offset = [stim_offset(1:119) NaN stim_offset(120:end)];
        end
    case 'S17_106_SD'
        if strcmp(bn,'E17-107_0017')
            stim_onset = [stim_onset(1) NaN stim_onset(2:end)];
            stim_offset = [stim_offset(1) NaN stim_offset(2:end)];
        end
        
        
end