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
        
end