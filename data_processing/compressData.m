function []= compressData(globalVar,varargin)

% Dependencies:compressSignal
% Writen by Mohammad Dastjerdi, Parvizi Lab, Stanford
% Revision date SEP,2009

sbj_name= globalVar.sbj_name;
block_name= globalVar.block_name;
project_name= globalVar.project_name;

% Compressing data before referencing
if nargin==1
    elecs= 1:globalVar.nchan;
    allChan= zeros(globalVar.nchan,ceil(globalVar.chanLength/globalVar.compression),'single');
    for ci= elecs
        load(sprintf('%s/iEEG%s_%.2d.mat',globalVar.data_dir,block_name,ci)); %wave
        allChan(ci,:)= single(compressSignal(wave,globalVar.compression));
        clear wave
        fprintf('%.2d of %.3d channels\n',ci,globalVar.nchan)
    end
    save(sprintf('%s/allChan%s.mat',globalVar.Comp_dir,block_name),'allChan');
    fprintf('Compression is done and saved \n')
else
    elecs= varargin{:};
    allChan= zeros(globalVar.nchan,ceil(globalVar.chanLength/globalVar.compression),'single');
    for ci= elecs
        load(sprintf('%s/iEEG%s_%.2d.mat',globalVar.data_dir,block_name,ci)); %wave
        allChan(ci,:)= single(compressSignal(wave,globalVar.compression));
        clear wave
        fprintf('%.2d of %.3d channels\n',ci,globalVar.nchan)
    end
    save(sprintf('%s/allChan%s.mat',globalVar.Comp_dir,block_name),'allChan');
    fprintf('Compression is done and saved \n') 
end
