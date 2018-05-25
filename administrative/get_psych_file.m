function fn = get_psych_file(sbj,BN)

switch sbj
    case 'S12_41_KS'
        switch BN
            case 'KS_25'
                fn = '73512368885_KS_1_all.mat';
            case 'KS_26'
                fn = '73512369331_KS_2_all.mat';
            case 'KS_27'
                fn = '73512369716_KS_3_all.mat';
            case 'KS_28'
                fn = '73512370098_KS_4_all.mat';
            case 'KS_29'
                fn = '73512541798_KS_5_all.mat';
        end
    case 'S12_45_LR'
        switch BN
            case 'LR_24'
                fn = '73519448257_LR_1_1.mat';
            case 'LR_27'
                fn = '73519449617_LR_2_2.mat';
            case 'LR_32'
                fn = '73519466566_LR_3_all.mat';
            case 'LR_33'
                fn = '73519467307_LR_4_all.mat';
        end
    case 'S13_53_KS2'
        switch BN
            case 'KS2_24'
                fn = 'KS2_dv2_1_all.mat';
            case 'KS2_25'
                fn = 'KS2_dv2_6_all.mat';
            case 'KS2_26'
                fn = 'KS2_dv2_3_all.mat';
            case 'KS2_27'
                fn = 'KS2_dv2_8_all.mat';
            case 'KS2_28'
                fn = 'KS2_dv2_2_all.mat';
            case 'KS2_29'
                fn = 'KS2_dv2_4_all.mat';
        end
    case 'S13_57_TVD'
        switch BN
            case 'TVD_22'
                fn = 'TVD_dv3_1_all.mat';
            case 'TVD_23'
                fn = 'TVD_dv3_2_all.mat';
            case 'TVD_24'
                fn = 'TVD_dv3_3_all.mat';
            case 'TVD_25'
                fn = 'TVD_dv3_4_all.mat';
            case 'TVD_26'
                fn = 'TVD_dv3_5_all.mat';
        end
    case 'S14_80_KB'
        switch BN
            case 'S14_80_KB_20'
                fn = 'sodata.S14_80_KB.15.12.2014.15.26.mat';
            case 'S14_80_KB_22'
                fn = 'sodata.S14_80_KB.15.12.2014.15.51.mat';
            case 'S14_80_KB_24'
                fn = 'sodata.S14_80_KB.15.12.2014.17.28.mat';
            case 'S14_80_KB_25'
                fn = 'sodata.S14_80_KB.15.12.2014.17.35.mat';
            case 'S14_80_KB_26'
                fn = 'sodata.S14_80_KB.15.12.2014.17.46.mat';
            case 'S14_80_KB_27'
                fn = 'sodata.S14_80_KB.15.12.2014.17.53.mat';
            case 'S14_80_KB_28'
                fn = 'sodata.S14_80_KB.15.12.2014.18.00.mat';
            case 'S14_80_KB_29'
                fn = 'sodata.S14_80_KB.15.12.2014.18.07.mat';
        end
                
end

