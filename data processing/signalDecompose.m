%% INPUT, loading global variables
sbj_name= 'CM';
block_name= 'ST07-07';
project_name= 'rest';
load(sprintf('global_%s_%s_%s.mat',project_name,sbj_name,block_name));

fs_comp= globalVar.fs_comp;
compression= globalVar.compression;
chanLength= globalVar.chanLength;
iEEG_rate= globalVar.iEEG_rate;

%% Electrodes of interest
elecs= sort([10 16 26 50 51 52 13 40]);

f= [4 12 ;30 150];

for ci= elecs
    
    load(sprintf('%s/CARiEEG%s_%.2d.mat',globalVar.CAR_dir,block_name, ci));
    wave= double(wave);
    input= fft(wave,[],2); % FFT transform
    clear wave
    
    signal= zeros(size(f,1),ceil(chanLength/compression),'single');
    amplitude= zeros(size(f,1),ceil(chanLength/compression),'single');
    phase= zeros(size(f,1),ceil(chanLength/compression),'single');
    
    % Bandpass the data for each freq
    for ii=1:size(f,1)
        disp([ci f(ii,1),f(ii,2) ])
        bp_input= band_pass(input ,iEEG_rate,f(ii,1),f(ii,2),0);
        signal(ii,:)= single(decimate(bp_input,compression,'FIR'));
        analytic= hilbert(bp_input);
        amplitude(ii,:)= single(decimate(abs(analytic),compression,'FIR'));
        phase(ii,:)= single(decimate(angle(analytic),compression,'FIR'));

    end
    
    BF.frequency= f;
    BF.fs_comp= fs_comp;
    BF.elecs= elecs;
    
    BF.signal= signal;
    BF.amplitude= amplitude;
    BF.phase= phase;
    
    save(sprintf('%s/BF_%s_%.3d',globalVar.Spec_dir,block_name,ci),'BF')
  
    clear input BF

end

