sbj = 'S12_38_LK';
task = 'Rest';
%   BN = block_by_subj(sbj,task);
BN = {'LK_05','LK_11','LK_24'};

initialize_dirs;

new_root = '/Users/amydaitch/Documents/MATLAB/analysis_ECoG';

for bi = 1:length(BN)
    block_name = BN{bi};
    load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',data_root,sbj,task,sbj,block_name),'globalVar');

    
    globalVar.data_dir = [new_root,'/neuralData/originalData/',globalVar.sbj_name,'/',globalVar.block_name];
    globalVar.Comp_dir = [new_root,'/neuralData/CompData/',globalVar.sbj_name,'/',globalVar.block_name];
    globalVar.CAR_dir = [new_root,'/neuralData/CARData/',globalVar.sbj_name,'/',globalVar.block_name];
    globalVar.Filt_dir = [new_root,'/neuralData/FiltData/',globalVar.sbj_name,'/',globalVar.block_name];
    globalVar.reRef_dir = [new_root,'/neuralData/reRefData/',globalVar.sbj_name,'/',globalVar.block_name];
    globalVar.Spec_dir = [new_root,'/neuralData/SpecData/',globalVar.sbj_name,'/',globalVar.block_name];
    globalVar.psych_dir = [new_root,'/psych_data/',globalVar.sbj_name,'/',globalVar.block_name];
    globalVar.result_dir = [new_root,'/Results/',globalVar.project_name,'/',globalVar.sbj_name,'/',globalVar.block_name];
    
    fn=sprintf('%s/originalData/%s/global_%s_%s_%s.mat',data_root,sbj,task,sbj,block_name);
    save(fn,'globalVar');
end