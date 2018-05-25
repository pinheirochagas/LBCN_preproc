function hemi = get_hemi(sbj)

if ismember(sbj,{'S09_07_CM','S11_20_RHb','S11_28_LS','S11_29_RB','S11_31_DZa','S11_31_DZb','S12_32_JTa','S12_32_JTb','S12_36_SrS','S12_41_KS','S13_47_JT2','S14_64_SP','S14_66_CZ'});
    hemi = 'r';
elseif ismember(sbj,{'S09_06_RM','S10_09_AP','S10_12_AC','S10_18_JBXa','S11_23_MD','S11_26_SRb','S12_33_DA','S12_38_LK','S12_42_NC','S12_45_LR','S13_46_JDB','S13_53_KS2','S13_55_JJC','S13_56_THS','S13_57_TVD','S14_62_JW','S14_74_OD','S14_80_KB','S15_83_RR'})
    hemi = 'l';
end