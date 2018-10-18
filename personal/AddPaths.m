function AddPaths(user)

if strcmp(user, 'Pedro_iMAC')
    comp_root = sprintf('/Users/pinheirochagas/Pedro/Stanford/code/lbcn_preproc/'); 
elseif strcmp(user,'Pedro_NeuroSpin4T')
    comp_root = sprintf('/Users/pinheirochagas/Pedro/Stanford/code/lbcn_preproc/'); 
elseif strcmp(user,'Amy_iMAC')
    comp_root = sprintf('/Users/amydaitch/Dropbox/Code/MATLAB/lbcn_preproc'); 
end

addpath(genpath(comp_root))

end

