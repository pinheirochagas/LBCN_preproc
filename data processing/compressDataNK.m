function []= compressDataNK(globalVar)

% Dependencies:compressSignal
% Writen by Mohammad Dastjerdi, Parvizi Lab, Stanford
% Revision date SEP,2009

sbj_name= globalVar.sbj_name;
block_name= globalVar.block_name;
project_name= globalVar.project_name;
elecnames = globalVar.elecnames;

% Compressing data before referencing
numelecs= globalVar.nchan;
load(sprintf('%s/iEEG_%s_%s.mat',globalVar.data_dir,block_name,elecnames{1}))
allChan= zeros(globalVar.nchan,length(wave),'single');
for ci= 1:numelecs
    load(sprintf('%s/iEEG_%s_%s.mat',globalVar.data_dir,block_name,elecnames{ci})); %wave
    allChan(ci,:)= wave;
    clear wave
    fprintf('%.2d of %.3d channels\n',ci,globalVar.nchan)
end
save(sprintf('%s/allChan%s.mat',globalVar.Comp_dir,block_name),'allChan');
fprintf('Compression is done and saved \n')