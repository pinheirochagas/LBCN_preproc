function data_blc = BaselineCorrect(data,bl_win)
% This function baseline corrects epoched data based on specified baseline
% window. It also rejects noisy trials or noisy timepts (i.e. sets to NaN)
% if specified in noise_method variable

%% INPUTS:
%   data: can be either freq x trial x time  or trial x time
%   bl_win: either a 2-element vector specifying time to be considered for baseline (in s)
%           or another data structure containing the baseline data (if the
%           baseline window isn't within the epoched data)


bl_reject_thr = 2; % reject bad timepoints within baseline period (that weren't rejected by prev methods)

if ndims(data.wave)==3
    datatype = 'Spec';
    [nfreq,ntrials,ntime]=size(data.wave);
else
    datatype = 'NonSpec';
    [ntrials,ntime]=size(data.wave);
end

%% create matrix the same size as data.wave with 1s for noisy timepts, 0 otherwise

noisy_inds = false(ntrials,ntime);
for ti = 1:ntrials
    noisy_inds(ti,data.trialinfo.bad_inds{ti})=true;
end
if strcmp(datatype,'Spec')
    noisy_inds = reshape(noisy_inds,[1,ntrials,ntime]);
    noisy_inds = repmat(noisy_inds,[nfreq,1,1]);
end
%% If baseline data is a separate input, eliminate noisy timepts
if isstruct(bl_win)
    sep_bl = true;
    if (strcmp(datatype,'Spec'))
        [nfreq,ntrials,ntime]=size(bl_win.wave);
    else
        [ntrials,ntime]=size(bl_win.wave);
    end
    
    noisy_inds_bl = false(ntrials,ntime);
    for ti = 1:ntrials
        noisy_inds_bl(ti,bl_win.trialinfo.bad_inds{ti})=true;
    end
    if strcmp(datatype,'Spec')
        noisy_inds_bl = reshape(noisy_inds_bl,[1,ntrials,ntime]);
        noisy_inds_bl = repmat(noisy_inds_bl,[nfreq,1,1]);
    end

else
    sep_bl = false;
    bl_inds = data.time >= bl_win(1) & data.time <= bl_win(2);
end

%% Extract data from baseline period and compute baseline
if strcmp(datatype,'Spec')
    if sep_bl
        bl_data = bl_win.wave;
        bl_data(noisy_inds_bl)=NaN;
    else
        bl_data = data.wave;
        bl_data(noisy_inds)=NaN;
        bl_data = bl_data(:,:,bl_inds);
    end
    tmp_dims = size(bl_data);
    bl_data = reshape(bl_data,[tmp_dims(1),tmp_dims(2)*tmp_dims(3)]);
    bl_data(zscore(bl_data,[],2)>bl_reject_thr)=NaN;
    
    bl_mn = nanmean(bl_data,2);
    bl_mn = repmat(bl_mn,[1,size(data.wave,2),size(data.wave,3)]);
    bl_sd = nanstd(bl_data,[],2);
    bl_sd = repmat(bl_sd,[1,size(data.wave,2),size(data.wave,3)]);
    
    data_blc.wave = (data.wave-bl_mn)./bl_sd;
    data_blc.phase = data.phase;
       
else % e.g. HFB data, no frequency dimension
    if sep_bl
        bl_data = bl_win.wave;
        bl_data(noisy_inds_bl)=NaN;
    else
        bl_data = data.wave;
        bl_data(noisy_inds)=NaN;
        bl_data = bl_data(:,bl_inds);
    end
    bl_data = bl_data(:);
    bl_data(zscore(bl_data)>bl_reject_thr)=NaN; 
    
    bl_mn = nanmean(bl_data(:));
    bl_sd = nanstd(bl_data(:));
    
    data_blc.wave = (data.wave-bl_mn)./bl_sd;
end

data_blc.time = data.time;
data_blc.fsample = data.fsample;



