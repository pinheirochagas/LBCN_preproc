function []=noiseFiltDataNK(globalVar)
% Filtering 60 Hz line noise
% Dependencies:notch.m .eeglab toolbox
% Writen by Mohammad Dastjerdi, Parvizi Lab, Stanford
% Revision date SEP,2009

block_name= globalVar.block_name;
compression = globalVar.compression;

elecnames = globalVar.elecnames;
numelecs= globalVar.nchan;
load(sprintf('%s/iEEG_%s_%s.mat',globalVar.data_dir,block_name,elecnames{1}))
tempwave = single(decimate(double(wave),compression));
allChanNotch= zeros(globalVar.nchan,length(tempwave),'single');
for ci= 1:numelecs
    load(sprintf('%s/iEEG_%s_%s.mat',globalVar.data_dir,block_name,elecnames{ci})); %wave
    % filtering 60 Hz
    [wave]= notch(wave, globalVar.iEEG_rate, 59, 61,1);
    [wave]= notch(wave, globalVar.iEEG_rate, 118,122,1); % Second harmonic of 60
    [wave]= notch(wave, globalVar.iEEG_rate, 178,182,1); % Third harmonic of 60
    %saving filtered data
    save(sprintf('%s/fiEEG_%s_%s.mat',globalVar.Filt_dir,block_name,elecnames{ci}),'wave')
    % saving compressed filtered data
%     disp(['Filtering chan ',chanlbl])
    disp([num2str(ci),' of ' num2str(numelecs),' channels'])
    allChanNotch(ci,:) = single(decimate(double(wave),compression));
    clear wave
end

save(sprintf('%s/allChanNotch%s.mat',globalVar.Comp_dir,block_name),'allChanNotch');
fprintf('Filtering and compression are done and saved \n')