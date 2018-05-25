clear; clc; close all

initialize_dirs;

project_name = 'Calculia_production';
sbjs= {'S18_124'};

for si = 1:length(sbjs)
    sbj = sbjs{si};
    task = get_project_name(sbj,project_name);
    BN = block_by_subj(sbj,task);
    
    for bi = 1:length(BN)

        load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',data_root,sbj,task,sbj,BN{bi}))
        elecs = setdiff(1:globalVar.nchan,globalVar.refChan);

        dataDecompose_Norm_band(globalVar,elecs,'CAR')
    end
end