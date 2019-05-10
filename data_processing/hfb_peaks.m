

hfa = ft_selectdata(cfg, hfa) - this is hfb epoched
data - this is the cardata epoched

cfg = [];
cfg.latency = [0.5 1.2];
data = ft_selectdata(cfg, data);
hfa = ft_selectdata(cfg, hfa);

trialinfo = hfa.trialinfo

 
% bring data into spike format
for CH = 1:length(hfa.label)
    
    spike.time{CH} = [];
    spike.trial{CH} = [];
    
    for tr = 1:size(trialinfo,2)
        
        currentdat = squeeze(hfa.trial{tr}(CH,:));
        
        % detect peaks on that
        [val idx] = findpeaks(currentdat);
        
        % limit to before target presentation
%         current_targ = nearest(hfa.time, hfa.trialinfo.int_cue_targ_time(tr,1)/1000);
        
        
        dist    = hfa.time{1} - trialinfo{1}(tr,1)/1000;
        dist(dist<0) = [];
        minDist = min(dist);
        current_targ = find(dist == minDist);
        
        
        val = val(find(idx < current_targ));
        idx = idx(find(idx < current_targ));
        
        spike.time{CH} = [spike.time{CH}, hfa.time{1}(idx)];
        spike.trial{CH} = [spike.trial{CH}, tr * ones(1,length(idx))];
        
    end
    
    spike.label{CH} = [hfa.label{CH}, '_sp'];
    
end

clear val idx

spike.trialtime = repmat([hfa.time{1}(1) hfa.time{1}(end)], size(trialinfo,2), 1);

% toggle spike presentation
spike = ft_checkdata(spike, 'datatype', 'raw', 'fsample', 1000);
% 
% cfg = [];
% cfg.latency = [0.5 1.2];
% data = ft_selectdata(cfg, data);


% fuse spike and LFP events
cfg = [];
cfg.keeptrials = 'yes';
spike = ft_timelockanalysis(cfg, spike)
% spike.time = data.time;

spike = rmfield(spike, 'avg')
spike = rmfield(spike, 'var')
spike = rmfield(spike, 'dof')

for i = 1:200
    spike3.trial{i} = squeeze(spike.trial(i,:,:))
end

data_all = ft_appenddata([], data, spike)




for CH = 1:length(data.label)
    
    cfg              = [];
    cfg.timwin       = [-0.5 0.5]; % take 400 ms
    cfg.spikechannel = spike.label{CH};
    cfg.channel      = data.label(CH);
    cfg.latency      = [0.3 1.7];
    sta_erp          = ft_spiketriggeredaverage(cfg, data_all);
    
    GAERP(CH,:) = sta_erp.avg;
    
    % fft this result
    cfg = [];
    cfg.taper = 'hanning';
    cfg.method = 'mtmfft';
    cfg.foilim = [0 40];
    sta_freq = ft_freqanalysis(cfg, sta_erp);
    
    GA(CH,:) = sta_freq.powspctrm;
    
end


% fuse
sta_erp.avg = GAERP; clear GAERP
sta_erp.label = data.label;

sta_freq.powspctrm = GA; clear GA
sta_freq.label = data.label;

% save out
save([pathname, subj{s}, '/', subj{s}, '_sta'], 'sta*')

clear sta* spike data hfa all

