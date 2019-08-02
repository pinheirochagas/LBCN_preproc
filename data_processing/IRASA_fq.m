function IRASA_fq(sbj_name, project_name, electrode, dirs)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MATLAB script for the extraction of rhythmic spectral features
% from the electrophysiological signal based on Irregular Resampling
% Auto-Spectral Analysis (IRASA, Wen & Liu, Brain Topogr. 2016)
%
% Ensure FieldTrip is correcty added to the MATLAB path:
%   addpath <path to fieldtrip home directory>
%   ft_defaults
%
% From Stolk et al., Electrocorticographic dissociation of alpha and
% beta rhythmic activity in the human sensorimotor system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  project_name = 'MMR';
% sbj_name = 'S13_57_TVD';

block_names = BlockBySubj(sbj_name,project_name);
load([dirs.original_data filesep  sbj_name filesep 'subjVar_'  sbj_name '.mat']);

cfg = [];
cfg.decimate = false;
concat_params = genConcatParams(project_name, cfg);
concat_params.decimate = true;
concat_params.fs_targ = 500;
concat_params.data_format = 'fieldtrip_raw'; %'fieldtrip_fq' fieldtrip_raw
concat_params.trialinfo_var = 'int_cue_targ_time'; % '' isCalc int_cue_targ_time

if isempty(electrode)
    elects = 1:length(subjVar.labels_EDF);
else
    elects = find(strcmp(subjVar.labels_EDF, electrode));
end

for el = elects
data = ConcatenateAll(sbj_name,project_name,block_names,dirs, 25,'CAR','CAR','stim', concat_params);

if strcmp(project_name, 'MMR')
    % filter math trials
    data.trialinfo = data.trialinfo(data.trialinfo ==1);
    data.trial = data.trial(data.trialinfo ==1);
    data.time = data.time(data.trialinfo ==1);
    data = rmfield(data, 'fsample');
else
    data = rmfield(data, 'fsample');
end


% partition the data into ten overlapping sub-segments
w = data.time{1}(end)-data.time{1}(1); % window length
cfg               = [];
cfg.length        = w*.9;
cfg.overlap       = 1-((w-cfg.length)/(10-1));
data_r = ft_redefinetrial(cfg, data);

% perform IRASA and regular spectral analysis
cfg               = [];
cfg.foilim        = [1 50];
cfg.taper         = 'hanning';
cfg.pad           = 'nextpow2';
cfg.keeptrials    = 'yes';
cfg.method        = 'irasa';
frac_r = ft_freqanalysis(cfg, data_r);
cfg.method        = 'mtmfft';
orig_r = ft_freqanalysis(cfg, data_r);

% average across the sub-segments
frac_s = {};
orig_s = {};
for rpt = unique(frac_r.trialinfo)'
    cfg               = [];
    cfg.trials        = find(frac_r.trialinfo==rpt);
    cfg.avgoverrpt    = 'yes';
    frac_s{end+1} = ft_selectdata(cfg, frac_r);
    orig_s{end+1} = ft_selectdata(cfg, orig_r);
end
frac_a = ft_appendfreq([], frac_s{:});
orig_a = ft_appendfreq([], orig_s{:});

% average across trials
cfg               = [];
cfg.trials        = 'all';
cfg.avgoverrpt    = 'yes';
frac = ft_selectdata(cfg, frac_a);
orig = ft_selectdata(cfg, orig_a);

% subtract the fractal component from the power spectrum
cfg               = [];
cfg.parameter     = 'powspctrm';
cfg.operation     = 'x2-x1';
osci = ft_math(cfg, frac, orig);
osci.powspctrm(osci.powspctrm < 0) = 0;

% Fit the gaussian to find the peaks
f    = fit(osci.freq', osci.powspctrm', 'gauss2');
% See why negative, if negative set to 0. 

mean1= f.b1;
mean2= f.b2;

std1  = f.c1/sqrt(2)*2.3548;
std2  = f.c2/sqrt(2)*2.3548;

%% Calculate the average power within each peak:
oscipeaks.peak1.meanfreq = mean1;
oscipeaks.peak1.stdfreq = std1;
oscipeaks.peak1.meanpower = mean(orig.powspctrm(min(find(orig.freq>=mean1-std1)):max(find(orig.freq<=mean1+std1))));
oscipeaks.peak2.meanfreq = mean2;
oscipeaks.peak2.stdfreq = std2;
oscipeaks.peak2.meanpower = mean(orig.powspctrm(min(find(orig.freq>=mean2-std2)):max(find(orig.freq<=mean2+std2))));
oscipeaks.powspctrm = osci.powspctrm';
oscipeaks.freq =osci.freq'; 
fout = sprintf('%s/%s/%s/signal_properties/oscillatory_%s.mat', dirs.result_root, project_name, sbj_name, subjVar.labels_EDF{el});
save(fout, 'oscipeaks', 'osci', 'orig')


end
