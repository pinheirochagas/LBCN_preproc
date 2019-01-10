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