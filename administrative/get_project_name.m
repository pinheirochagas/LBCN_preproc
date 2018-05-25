function task = get_project_name(sbj,project_name)

switch project_name
    case 'MMR'
        switch sbj
            case {'S09_07_CM','S11_23_MD','S11_26_SRa','S11_26_SRb','S11_28_LS','S11_29_RB','S11_20_RHb','S09_06_RM','S10_09_AP','S10_12_AC','S10_18_JBXa'}
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
            case {'S13_57_TVD','S14_62_JW','S13_52_FVV'}
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
    case 'LogoActive'
        task = 'LogoActive';
    case 'LogoPassive'
        task = 'LogoPassive';
    case 'Memoria'
        task = 'Memoria';
    otherwise 
        task = project_name;
end