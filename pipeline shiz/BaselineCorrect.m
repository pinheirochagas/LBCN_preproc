function data_blc = BaselineCorrect(data,bl_win)
% This function baseline corrects epoched data based on specified baseline
% window. It also rejects noisy trials or noisy timepts (i.e. sets to NaN)
% if specified in noise_method variable

%% INPUTS:
%   data: can be either freq x trial x time  or trial x time
%   bl_win: either a 2-element vector specifying time to be considered for baseline (in s)
%           or another data structure containing the baseline data (if the
%           baseline window isn't within the epoched data)
%   noise_method:   how to exclude data (default: 'trial'):
%                       'none':     no epoch rejection
%                       'trial':    exclude noisy trials (set to NaN)
%                       'timepts':  set noisy timepoints to NaN but don't exclude entire trials

bl_reject_thr = 2; % reject bad timepoints within baseline period (that weren't rejected by prev methods)

if ndims(data.wave)==3
    datatype = 'Spec';
else
    datatype = 'NonSpec';
end

% if  ~isreal(data.wave)
%     phase = angle(data.wave);
%     data.wave = abs(data.wave);  % for spectral data (that is complex), just extract envelope
% end

%% If baseline data is a separate input, eliminate bad trials of baseline data
if isstruct(bl_win)
    sep_bl = true;
    if ~isreal(bl_win)
        bl_win.wave = abs(bl_win.wave);
    end
    if strcmp(datatype,'Spec')
        bl_win.wave(:,data.trialinfo.bad_epochs,:) = NaN;
    else
        bl_win.wave(data.trialinfo.bad_epochs,:) = NaN;
    end
else
    sep_bl = false;
    bl_inds = data.time >= bl_win(1) & data.time <= bl_win(2);
end

%% Extract data from baseline period and compute baseline
if strcmp(datatype,'Spec')
    if sep_bl
        bl_data = bl_win.wave(:,~data.trialinfo.bad_epochs,:);
    else
        bl_data = data.wave(:,~data.trialinfo.bad_epochs,bl_inds);
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
        bl_data = bl_win.wave(~data.trialinfo.bad_epochs,:);
    else
        bl_data = data.wave(~data.trialinfo.bad_epochs,bl_inds);
    end
    bl_mn = nanmean(bl_data(:));
    bl_sd = nanstd(bl_data(:));
    
    data_blc.wave = (data.wave-bl_mn)./bl_sd;
end

data_blc.time = data.time;
data_blc.fsample = data.fsample;



