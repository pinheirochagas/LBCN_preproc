clear; clc; close all

initialize_dirs;

project_name = 'Memoria';
sbjs= {'S18_124'};

for si = 1:length(sbjs)
    sbj = sbjs{si};
    task = get_project_name(sbj,project_name);
    BN = block_by_subj(sbj,task);
end


for bi = 1:length(BN)
    
    dataDecompose_Norm_band(globalVar,elecs,'CAR')
end
