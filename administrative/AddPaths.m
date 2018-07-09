function AddPaths(user)

if strcmp(user, 'Pedro_iMAC')
    comp_root = sprintf('/Users/pinheirochagas/Pedro/Stanford/code/lbcn_preproc/'); % location of analysis_ECOG folder
elseif strcmp(user,'Pedro_NeuroSpin4T')
    comp_root = sprintf('/Users/pinheirochagas/Pedro/Stanford/code/lbcn_preproc/'); % location of analysis_ECOG folder
elseif strcmp(user,'Amy_iMAC')
    comp_root = sprintf('/Users/pinheirochagas/Pedro/Stanford/code/lbcn_preproc/'); % location of analysis_ECOG folder
elseif strcmp(user,'Ying_iMAC')
    comp_root = sprintf('/Users/yingfang/Documents/toolbox/lbcn_preproc_v3/'); % location of analysis_ECOG folder
elseif strcmp(user,'Nico_laptop')
    comp_root = sprintf('/Users/parvizilab/Documents/code/lbcn_preproc/'); % location of analysis_ECOG folder
    
end

addpath(genpath(comp_root))


end
    