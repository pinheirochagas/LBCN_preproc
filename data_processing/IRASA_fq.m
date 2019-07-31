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
data = ConcatenateAll(sbj_name,project_name,block_names,dirs, el,'CAR','CAR','stim', concat_params);

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

%% plot the fractal component and the power spectrum
figure('units', 'normalized', 'outerposition', [0 0 .5 .5]) % [0 0 .6 .3]
fontsize = 16;

subplot(2,2,1)
plot(frac.freq, frac.powspctrm, ...
    'linewidth', 3, 'color', [0 0 0])
hold on; plot(orig.freq, orig.powspctrm, ...
    'linewidth', 3, 'color', [.6 .6 .6])
title(subjVar.labels_EDF{el})
set(gca,'fontsize',fontsize)
legend('Fractal component', 'Power spectrum');

% 
% % plot the full-width half-maximum of the oscillatory component
% f    = fit(osci.freq', osci.powspctrm', 'gauss1');
% mean = f.b1;
% std  = f.c1/sqrt(2)*2.3548;
% fwhm = [mean-std/2 mean+std/2];
%  yl   = get(gca, 'YLim');
% p = patch([fwhm flip(fwhm)], [yl(1) yl(1) yl(2) yl(2)], [1 1 1]);
% uistack(p, 'bottom');
% legend('FWHM oscillation', 'Fractal component', 'Power spectrum');
xlabel('Frequency'); ylabel('Power');
% set(gca, 'YLim', yl);
set(gca,'fontsize',fontsize)

% plot the fractal component and the power spectrum
subplot(2,2,2)
plot(frac.freq,orig.powspctrm - frac.powspctrm, 'linewidth', 3, 'color', [0 0 1])
xlabel('Frequency'); ylabel('Power');
set(gca,'fontsize',fontsize)
title('Power - Fractal (oscillatory component)')


subplot(2,2,3)
plot(frac.freq, frac.powspctrm, ...
    'linewidth', 3, 'color', [0 0 0])
hold on; plot(orig.freq, orig.powspctrm, ...
    'linewidth', 3, 'color', [.6 .6 .6])
title(subjVar.labels_EDF{el})
xlabel('Log(Frequency)'); ylabel('Log(Power)');
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
set(gca,'fontsize',fontsize)


subplot(2,2,4)
plot(log(frac.freq), log(orig.powspctrm) - log(frac.powspctrm), 'linewidth', 3, 'color', [0 0 1])
xlabel('Log(Frequency)'); ylabel('Log(Power)');
xlim([0 max(log(orig.freq))])
title('Power - Fractal (oscillatory component)')
set(gca,'fontsize',fontsize)

fout = sprintf('%s/%s/%s/signal_properties/oscillatory_%s.png', dirs.result_root, project_name, sbj_name, subjVar.labels_EDF{el});
savePNG(gcf, 300, fout)
close all
end
