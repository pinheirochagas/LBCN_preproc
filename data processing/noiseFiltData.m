function []=noiseFiltData(globalVar,varargin)
% Filtering 60 Hz line noise
% Dependencies:notch.m .eeglab toolbox
% Writen by Mohammad Dastjerdi, Parvizi Lab, Stanford
% Revision date SEP,2009

elecs= 1:globalVar.nchan;
for ci= elecs
    load(sprintf('%s/iEEG%s_%.2d.mat',globalVar.data_dir,globalVar.block_name,ci)); %wave
    % filtering 60 Hz
    [wave]= notch(wave, globalVar.iEEG_rate, 59, 61,1);
    [wave]= notch(wave, globalVar.iEEG_rate, 118,122,1); % Second harmonic of 60
    [wave]= notch(wave, globalVar.iEEG_rate, 178,182,1); % Third harmonic of 60
    %saving filtered data
    save(sprintf('%s/fiEEG%s_%.2d.mat',globalVar.Filt_dir,globalVar.block_name,ci),'wave')
    % saving compressed filtered data
    clear wave
    fprintf('%.2d of %.3d channels\n',ci,globalVar.nchan)
end
fprintf('Filtering and compression are done and saved \n')

end