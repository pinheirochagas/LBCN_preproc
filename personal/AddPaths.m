function AddPaths(user)

if strcmp(user, 'Pedro_iMAC')
    comp_root = sprintf('/Users/pinheirochagas/Pedro/Stanford/code/lbcn_preproc/'); % location of analysis_ECOG folder
    addpath(genpath('/Users/pinheirochagas/Pedro/Stanford/code/iELVis/'))
elseif strcmp(user,'Pedro_NeuroSpin4T')
    comp_root = sprintf('/Users/pinheirochagas/Pedro/Stanford/code/lbcn_preproc/'); % location of analysis_ECOG folder
elseif strcmp(user,'Amy_iMAC')
    comp_root = sprintf('/Users/pinheirochagas/Pedro/Stanford/code/lbcn_preproc/'); % location of analysis_ECOG folder
elseif strcmp(user,'Ying_iMAC')
    comp_root = sprintf('/Users/yingfang/Documents/toolbox/lbcn_preproc/'); % location of analysis_ECOG folder
elseif strcmp(user,'Clara_iMAC')
    comp_root = sprintf('/Users/csava/Documents/code/lbcn_preproc/'); % location of analysis_ECOG folder
    addpath(genpath('/Users/csava/Documents/code/iELVis/'))
elseif strcmp(user,'Kevin_UCLA')
    comp_root = sprintf('/data/MMR/lbcn_preproc');
end

addpath(genpath(comp_root))


end
    