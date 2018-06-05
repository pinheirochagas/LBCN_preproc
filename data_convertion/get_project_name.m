function task = get_project_name(sbj,project_name)

switch project_name
    case 'MMR'
        switch sbj
            case {'S11_23_MD','S11_28_LS','S11_29_RB', 'S09_07_CM'}
                task = 'UCLA';
%             case {'S11_31_DZa','S12_32_JTa','S12_32_JTb','S12_36_SrS','S12_38_LK','S12_41_KS','S12_42_NC','S12_45_LR','S13_46_JDB',...
%                 'S13_47_JT2','S13_53_KS2','S13_57_TVD','S14_62_JW','S14_64_SP','S14_66_CZ','S14_80_KB','S15_83_RR','S15_90_SO'}
%                 task = 'MMR';
            otherwise
                task = 'MMR';
        end
    case 'Scrambled'
        switch sbj
            case {'S11_29_RB','S12_32_JTa'}
                task = 'AllCateg';
            case {'S13_57_TVD','S14_62_JW'}
                task = 'LogoPassive';
            otherwise
                task = 'Scrambled';
%                             case {'S11_28_LS','S11_31_DZa','S12_36_SrS','S12_38_LK','S12_41_KS','S12_45_LR','S13_53_KS2','S14_64_SP','S14_66_CZ','S14_80_KB','S15_83_RR'}
%                 task = 'Scrambled';
        end
    case 'ReadNumWord'
        task = 'ReadNumWord';
    case 'Rest'
        task = 'Rest';
    case 'calculia'
        switch sbj
            case {'S12_41_KS','S12_45_LR','S13_53_KS2','S13_57_TVD'}
                task = 'Context';
%             case {'S14_64_SP','S14_66_CZ','S14_80_KB','S15_83_RR'}
%                 task = 'calculia';           
            otherwise
                task = 'calculia';
        end
    case 'VTCLoc'
        task = 'VTCLoc';
    case 'MFA'
        task = 'MFA';
    otherwise 
        task = '';
end