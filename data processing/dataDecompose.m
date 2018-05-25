function []= dataDecompose(globalVar,elecs)
% Function: decomposing signal into Ampilitude and Phase for different
% frequencies
% Input: CAR data
% ouput: per channel, amplitude and phase matrix 
% Dependencies; signal processing tooolbox, band_pass.m
% Writen by Mohammad Dastjerdi, Parvizi Lab, Stanford
% Last revision date SEP,2009

block_name= globalVar.block_name;
freq= globalVar.freq;
fs_comp= globalVar.fs_comp;
compression= globalVar.compression;
chanLength= globalVar.chanLength;
iEEG_rate= globalVar.iEEG_rate;
for ci= elecs
    
    load(sprintf('%s/CARiEEG%s_%.2d.mat',globalVar.CAR_dir,block_name, ci));
    wave= double(wave);
    input= fft(wave,[],2); % FFT transform
    clear wave
    amplitude= zeros(length(freq),ceil(chanLength/compression),'single');
    phase= zeros(length(freq),ceil(chanLength/compression),'single');
    
    for fi=1:length(freq)
        f= freq(fi);
        disp([ci fi])

        % bandpass the data for each freq
        tmp= band_pass(input ,iEEG_rate ,f-0.1*f, f+0.1*f, 0); 
        analytic= hilbert(tmp);
        amplitude(fi,:)= single(decimate(abs(analytic),compression,'FIR'));
        phase(fi,:)= single(decimate(angle(analytic),compression,'FIR'));

    end
    save(sprintf('%s/amplitude_%s_%.3d',globalVar.Spec_dir,block_name,ci),'amplitude')
    save(sprintf('%s/phase_%s_%.3d',globalVar.Spec_dir,block_name,ci),'phase')
    
    clear input
end