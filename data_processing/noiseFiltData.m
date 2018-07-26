function []=noiseFiltData(globalVar, varargin)
% Filtering 60 Hz line noise
% Dependencies:notch.m .eeglab toolbox
% Writen by Mohammad Dastjerdi, Parvizi Lab, Stanford
% Revision date SEP,2009

elecs= 1:globalVar.nchan;
for ci= elecs
    load(sprintf('%s/iEEG%s_%.2d.mat',globalVar.originalData,globalVar.block_name,ci)); %wave
    % filtering 60 Hz
    if strcmp(globalVar.center, 'Stanford')
        
        [wave]= notch(wave, globalVar.iEEG_rate, 59, 61,1);
        [wave]= notch(wave, globalVar.iEEG_rate, 118,122,1); % Second harmonic of 60
        [wave]= notch(wave, globalVar.iEEG_rate, 178,182,1); % Third harmonic of 60
    elseif strcmp(globalVar.center, 'China')
        [wave]= notch(wave, globalVar.iEEG_rate, 49, 51,1);
        [wave]= notch(wave, globalVar.iEEG_rate, 98,102,1); % Second harmonic of 60
        [wave]= notch(wave, globalVar.iEEG_rate, 148,152,1); % Third harmonic of 60
    else
    end
    %saving filtered data
    save(sprintf('%s/fiEEG%s_%.2d.mat',globalVar.FiltData,globalVar.block_name,ci),'wave')
    % saving compressed filtered data
    clear wave
    fprintf('%.2d of %.3d channels\n',ci,globalVar.nchan)
end
fprintf('Filtering and compression are done and saved \n')

end