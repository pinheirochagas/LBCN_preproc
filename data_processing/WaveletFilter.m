function [wave_out] = WaveletFilter(data,fsample,fs_targ,freqs, span, norm, avgfreq)

%% INPUTS
% data: EEG signal (1 x time)
% freqs (optional): vector containing frequencies at which wavelet is computed (in Hz), or 'HFB'
% span (optional): span of wavelet (i.e. width of gaussian that forms
%                  wavelet, in units of cycles- specific to each
%                  frequency)
% fs_targ (optional): target sampling rate of wavelet output
% norm (optional): normalize amplitude of timecourse within each frequency
%                  band (to eliminate 1/f power drop with frequency)
% avgfreq (optional): average across frequency dimension to yield single timecourse 
%                     (e.g. for computing HFB timecourse). If set to true,
%                     only amplitude information will remain (not phase, since 
%                     cannot average phase across frequencies)

if strcmp(freqs,'HFB')
    freqs = 2.^(6.2:0.1:7.5);
    norm = true;
    avgfreq = true;
elseif nargin < 2 || isempty(freqs)
    freqs = 2.^([0:0.5:2,2.3:0.3:5,5.2:0.2:8]);
end

if nargin < 3 || isempty(span)
    span = 1;
end

if ~strcmp(freqs,'HFB') && (nargin < 5 || isempty(norm))
    norm = false;
end

if ~strcmp(freqs,'HFB') && (nargin < 6 || isempty(avgfreq))
    avgfreq = false; 
end
%%

ds = round(fsample/fs_targ); % factor by which to downsample
data = data(:)'; % make sure signal is a row vector
time =(1:length(data))/fsample;
siglength_ds = length(time(1:ds:end));
wave_out.wave = zeros(numel(freqs),siglength_ds,'single');
wave_out.phase = zeros(numel(freqs),siglength_ds,'single');

% Spectral data, frequencies saved separately 
for f = 1:numel(freqs)
    freq = freqs(f);
    sigma = span/freq;
    t = -4*sigma:1/fsample:4*sigma;
    wavelet = exp(-(t.^2)/(2*sigma^2)).*exp(1i*2*pi*freq*t);    % wavelet = gaussian * complex sinusoid
    wave_tmp = conv(data,conj(wavelet),'same');                 % convolve signal with wavelet
    wave_out.wave(f,:) = abs(wave_tmp(:,1:ds:end));             % downsample and converting the complex to real numbers
    wave_out.phase(f,:) = angle(wave_tmp(:,1:ds:end)); 
end

% HFB or another frequency band (averaging across frequencies)
if (avgfreq)
    if (norm)
        amp = zscore(abs(wave_out.wave),[],2);
        wave_out.wave = nanmean(amp);
    else
        wave_out.wave = nanmean(abs(wave_out.wave));  % average amplitude across frequencies
    end
    
end

wave_out.freqs = freqs;
wave_out.wavelet_span = span;
wave_out.time = time(1:ds:end);
wave_out.fsample = round(fsample/ds);

