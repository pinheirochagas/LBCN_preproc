function data_blc = BaselineCorrect(data,bl_win,noise_params)
% This function baseline corrects epoched data based on specified baseline
% window. It also rejects noisy trials or noisy timepts (i.e. sets to NaN)
% if specified in noise_method variable

%% INPUTS:
%   data: can be either freq x trial x time  or trial x time
%   bl_win: either a 2-element vector specifying time to be considered for baseline (in s)
%           or another data structure containing the baseline data (if the
%           baseline window isn't within the epoched data)
%   noise_params.method: 'trials','timepts', or 'none' (which baseline data to
%                       exclude before baseline correction)
%               .noise_fields_trials  (which trials to exclude- if method = 'trials')
%               .noise_fields_timepts (which timepts to exclude- if method = 'timepts')

if isempty(noise_params)
    noise_params.method = 'trials';
    noise_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
    noise_params.noise_fields_timepts = {'bad_inds_HFO','bad_inds_raw_HFspike'};
end

% bl_reject_thr = 2; % reject bad timepoints within baseline period (that weren't rejected by prev methods)

if ndims(data.wave)==3
    datatype = 'Spec';
    [nfreq,ntrials,ntime]=size(data.wave);
else
    datatype = 'NonSpec';
    [ntrials,ntime]=size(data.wave);
end

%% If baseline data is a separate input, eliminate noisy timepts
if isstruct(bl_win)
    sep_bl = true;
    if (strcmp(datatype,'Spec'))
        [~,~,ntime_bl]=size(bl_win.wave);
    else
        [~,ntime_bl]=size(bl_win.wave);
    end
%     
%     noisy_inds_bl = false(ntrials,ntime);
%     for ti = 1:ntrials
%         noisy_inds_bl(ti,bl_win.trialinfo.bad_inds{ti})=true;
%     end
%     if strcmp(datatype,'Spec')
%         noisy_inds_bl = reshape(noisy_inds_bl,[1,ntrials,ntime]);
%         noisy_inds_bl = repmat(noisy_inds_bl,[nfreq,1,1]);
%     end

else
    sep_bl = false;
    bl_inds = data.time >= bl_win(1) & data.time <= bl_win(2);
    ntime_bl = length(bl_inds);
end

%% create matrix the same size as data.wave with 1s for noisy timepts, 0 otherwise

if strcmp(noise_params.method,'trials')
    bad_trials = [];
    for i = 1:length(noise_params.noise_fields_trials)
        if sep_bl
            bad_trials = union(bad_trials,find(bl_win.trialinfo.(noise_params.noise_fields_trials{i})));
        else
            bad_trials = union(bad_trials,find(data.trialinfo.(noise_params.noise_fields_trials{i})));
        end
    end
elseif strcmp(noise_params.method,'timepts')
    bad_inds = cell(ntrials,1);
    for i = 1:length(noise_params.noise_fields_timepts)
        if sep_bl
            bad_inds = cellfun(@union,bad_inds,bl_win.trialinfo.(noise_params.noise_fields_timepts{i}),'UniformOutput',false);
        else
            bad_inds = cellfun(@union,bad_inds,data.trialinfo.(noise_params.noise_fields_timepts{i}),'UniformOutput',false);
        end
    end
    if ~sep_bl % only count bad inds within baseline period
        bad_inds = cellfun(@intersect,bad_inds,bl_inds,'UniformOutput',false); 
    end
    % create array of size of baseline data, where all noisy inds are set to 1, 0 elsewhere
    bad_inds2 = false(ntrials,ntime_bl);
    for ti = 1:ntrials
        bad_inds2(ti,bad_inds{ti})=true;
    end
    if strcmp(datatype,'Spec')
        bad_inds2 = reshape(bad_inds2,[1,ntrials,ntime_bl]);
        bad_inds2 = repmat(bad_inds2,[nfreq,1,1]);
    end
end



%% Extract data from baseline period and compute baseline
if strcmp(datatype,'Spec')
    if sep_bl
        bl_data = bl_win.wave;
%         bl_data(noisy_inds_bl)=NaN;
    else
        bl_data = data.wave(:,:,bl_inds);
%         bl_data(noisy_inds)=NaN;
%         bl_data = bl_data(:,:,bl_inds);
    end
    if strcmp(noise_params.method,'trials')
        bl_data(:,bad_trials,:) = NaN;
    elseif strcmp(noise_params.method,'timepts')
        bl_data(bad_inds2) = NaN;
    end
    tmp_dims = size(bl_data);
    bl_data = reshape(bl_data,[tmp_dims(1),tmp_dims(2)*tmp_dims(3)]);
%     bl_data(zscore(bl_data,[],2)>bl_reject_thr)=NaN;
    
    bl_mn = nanmean(bl_data,2);
    bl_mn = repmat(bl_mn,[1,ntrials,ntime]);
    bl_sd = nanstd(bl_data,[],2);
    bl_sd = repmat(bl_sd,[1,ntrials,ntime]);
    
    data_blc.wave = (data.wave-bl_mn)./bl_sd;
    data_blc.phase = data.phase;
       
else % e.g. HFB data, no frequency dimension
    if sep_bl
        bl_data = bl_win.wave;
%         bl_data(noisy_inds_bl)=NaN;
    else
        bl_data = data.wave(:,bl_inds);
%         bl_data(noisy_inds)=NaN;
%         bl_data = bl_data(:,bl_inds);
    end
    if strcmp(noise_params.method,'trials')
        bl_data(bad_trials,:) = NaN;
    elseif strcmp(noise_params.method,'timepts')
        bl_data(bad_inds2) = NaN;
    end
    bl_data = bl_data(:);
%     bl_data(zscore(bl_data)>bl_reject_thr)=NaN; 
    
    bl_mn = nanmean(bl_data(:));
    bl_sd = nanstd(bl_data(:));
    
    data_blc.wave = (data.wave-bl_mn)./bl_sd;
end

data_blc.time = data.time;
data_blc.fsample = data.fsample;



