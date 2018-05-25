function []= dataDecompose_band_bipolar(globalVar)
% Function: decomposing signal into Ampilitude and Phase for different
% frequencies
% Input: CAR data
% ouput: per channel, amplitude and phase matrix
% Dependencies; signal processing tooolbox, band_pass.m
% Writen by Mohammad Dastjerdi, Parvizi Lab, Stanford
% Last revision date SEP,2009

% use eeglab package

%locutoff = [50]
%hicutoff = [150]
% locutoff= [30  30  30  30  30  30  30];
% hicutoff= [110 120 130 140 150 160 170];
% [1   2   3   4   5   6   7   8   9   10  11 12 13 14 15 16
locutoff= [30  30  30  40  40  40  50  50  65  65  1  4  8  13 30 65];
hicutoff= [170 180 100 180 160 140 120 150 120 150 3  7  12 29 55 180];

% for AP
%locutoff= [30  30  30  40  40  40  50  50];
%hicutoff= [170 180 100 180 160 140 120 150];


%%use 42 freq group in 5 groups

freq= [locutoff;hicutoff];
block_name= globalVar.block_name_bipolar;
fs_comp= globalVar.fs_comp;
compression= globalVar.compression;
chanLength= globalVar.chanLength;
iEEG_rate= globalVar.iEEG_rate;

% for ci= elecs
for ci = 1:length(globalVar.biElecNames)
    el = globalVar.biElecNames{ci};
    band=[];
    band.elec= el;
    band.freq= freq;
    band.block_name= block_name;
    %     if ~ismember(ci, globalVar.refChan)
    load(sprintf('%s/fiEEG%s_%s.mat',globalVar.Filt_dir_bipolar,block_name, el));
    wave= double(wave);
    input= decimate(wave,compression,'FIR');% Down-sampling
    clear wave
    
    amplitude= zeros(size(freq,2),ceil(chanLength/compression),'single');
    phase= zeros(size(freq,2),ceil(chanLength/compression),'single');
    
    for fi=1:size(freq,2)
        disp([ci freq(1,fi) freq(2,fi)])
        fc= (freq(1,fi) + freq(2,fi) )/2; % central frequency
        filtorder= floor(fs_comp*2/fc); % filter order
        % bandpass the data for each freq
        % tmp= eeg_filter(input ,fs_comp, freq(1,fi), freq(2,fi),filtorder);
        tmp= eegfilt(input ,fs_comp, freq(1,fi), freq(2,fi),0,filtorder);
        % Envelope of signal
        analytic= hilbert(tmp);
        amplitude(fi,:)= single(abs(analytic));
        phase(fi,:)= single(angle(analytic));
        
    end
    band.amplitude= amplitude;
    band.phase= phase;
    save(sprintf('%s/band_%s_%s',globalVar.Spec_dir_bipolar,block_name,el),'band')
    
    clear input
    %     end
end