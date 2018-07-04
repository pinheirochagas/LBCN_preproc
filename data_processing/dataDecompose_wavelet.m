function []= dataDecompose_wavelet(globalVar,elecs)
% Function: decomposing signal into Ampilitude and Phase for different
% frequencies
% Input: CAR data
% ouput: per channel, amplitude and phase matrix 
% Dependencies; signal processing tooolbox, band_pass.m
% Writen by Mohammad Dastjerdi, Parvizi Lab, Stanford
% Last revision date SEP,2009

if (~exist(sprintf('%s/wavelets',globalVar.Spec_dir),'dir'))
    mkdir(sprintf('%s/wavelets',globalVar.Spec_dir))
end

block_name= globalVar.block_name;
% freq= globalVar.freq;
freqs = 2.^(0:0.2:8); %frequencies at which to compute wavelets
% freqs = 2.^([0:0.5:1.5,2:0.25:4.75,5:0.2:8]);
fs_comp= globalVar.fs_comp;
compression= globalVar.compression;
chanLength= globalVar.chanLength;
iEEG_rate= globalVar.iEEG_rate;
for ci= elecs
    
    load(sprintf('%s/CARiEEG%s_%.2d.mat',globalVar.CAR_dir,block_name, ci));
    wave= double(wave);
%     input= fft(wave,[],2); % FFT transform
%     clear wave
%     amplitude= zeros(length(freq),ceil(chanLength/compression),'single');
%     phase= zeros(length(freq),ceil(chanLength/compression),'single');
    gabor = gabor_response(wave,freqs,iEEG_rate);
    disp(ci)
    gabor = gabor(:,1:compression:end);
    save(sprintf('%s/wavelets/wavelet_%s_%.3d.mat',globalVar.Spec_dir,block_name,ci),'gabor','freqs')
%     save(sprintf('%s/phase_%s_%.3d',globalVar.Spec_dir,block_name,ci),'phase')
    
%     clear input
end