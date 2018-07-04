function []= dataDecompose_Norm_band(globalVar,elecs,str)
% Function: decomposing signal into Ampilitude
% frequencies
% Input: CAR data
% ouput: per channel, amplitude only
% Dependencies; signal processing tooolbox, band_pass.m
% Writen by Mohammad Dastjerdi, Parvizi Lab, Stanford
% BF edit Oct, 2011: Modified band ranges.
% BF edit Sep, 2013: Many edits for improved normalization

%% Variables
%freqs - 70-180Hz with 10Hz steps
locutoff= [70:10:170];
hicutoff= [80:10:180];
freq= [locutoff;hicutoff];

block_name= globalVar.block_name;
fs_comp= globalVar.fs_comp;
compression= globalVar.compression;
chanLength= globalVar.chanLength;

%% Loop - load data, downsample, and filter/normalize
for ci= elecs
    
    %create structure for band info
    band=[];
    band.elec= ci;
    band.freq= freq;
    band.block_name= block_name;
        
        %load data and downsample
        if strcmp(str,'CAR')
        load(sprintf('%s/CARiEEG%s_%.2d.mat',globalVar.CAR_dir,block_name, ci));
        end
        
        if strcmp(str,'BP')
        load(sprintf('%s/BPiEEG%s_%.2d.mat',globalVar.BP_dir,block_name, ci));
        end
    
    %if the compression is not an integer
    if globalVar.compression == floor(globalVar.compression)
        wave = double(wave);
        input = decimate(wave,compression,'FIR');% Down-sampling
        clear wave
    else %for NK data
        wave = double(wave);
        input = resample(wave,ceil(globalVar.iEEG_rate/globalVar.compression),globalVar.iEEG_rate);
        clear wave
    end
        
        
        %get data edges - for normalizing
        if exist('globalVar.exp_start_time') == 0
            exp_start_pt = floor(10*globalVar.fs_comp);
            exp_end_pt = ceil(length(input)-(10*globalVar.fs_comp));

        else
            exp_start_pt = floor(globalVar.exp_start_time*globalVar.fs_comp);
            exp_end_pt = ceil(globalVar.exp_end_time*globalVar.fs_comp);
        end
        
    %initialize
    %amplitude_norm= zeros(size(freq,2),ceil(chanLength/compression),'single');
    amplitude_norm= [];
    
    %loop frequencies
    for fi=1:size(freq,2)
        %show current step
        disp([ci freq(1,fi) freq(2,fi)])
        
        %assign filt order -needed?
        %fc= (freq(1,fi) + freq(2,fi) )/2; % central frequency
        %filtorder= floor(fs_comp*2/fc); % filter order
        
        %bandpass the data for each freq
        tmp= eegfilt(input ,fs_comp, freq(1,fi), []); 
        tmp= eegfilt(tmp ,fs_comp, [], freq(2,fi)); 
        
        %apply Hilbert, get envelope of signal
        analytic= hilbert(tmp);
        amplitude= single(abs(analytic));
        
        %get mean of time series - excluding bad data points
        amp_bad = amplitude;
        %make outliers NaN
        amp_bad(ceil(globalVar.bad_epochs(1,ci).timepoints.*fs_comp)) = NaN;
        %take average of only the data within experiment time
        amp_mean = nanmean(amp_bad(exp_start_pt:exp_end_pt));

        %normalize, store band
        %amplitude_norm(fi,:) = zscore(amplitude);
        amplitude_norm(fi,:) = (amplitude./amp_mean)*100; %percentage of mean
        
        clear amplitude
    end
    
    %average each band for normalize signal
    amplitude_norm_mean = mean(amplitude_norm);
    
    %add to band structure
    band.amplitude= amplitude_norm_mean; 
    %save band structure
    save(sprintf('%s/Normband_%s_%.3d',globalVar.Spec_dir,block_name,ci),'band')
    
    clear input
end

