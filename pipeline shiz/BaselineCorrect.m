function data_blc = BaselineCorrect(data,bl_win,noise_method)
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

if ndims(data)==3
    datatype = 'Spec';
else
    datatype = 'NonSpec';
end

% If baseline data is a separate input, eliminate bad trials of baseline data
if isstruct(bl_win)
    sep_bl = true;
    if strcmp(datatype,'Spec')
        bl_win.wave(:,data.trialinfo.badtrials,:)=NaN;
    else
        bl_win.wave(data.trialinfo.badtrials,:)=NaN;
    end
else
    sep_bl = false;
    bl_inds = data.time >= bl_win(1) & data.time <= bl_win(2);
end

if strcmp(noise_method,'trial')
    if strcmp(datatype,'Spec')
        data.wave(:,data.trialinfo.badtrials,:)=NaN;
    else
        data.wave(data.trialinfo.badtrials,:)=NaN;
    end
elseif strcmp(noise_method,'timepts')
    for ti = 1:ntrials
        if strcmp(datatype,'Spec')
            data.wave(:,ti,data.trialinfo.badinds{ti})=NaN;
        else
            data.wave(ti,data.trialinfo.badinds{ti})=NaN;
        end
    end
end

if strcmp(datatype,'Spec')
    if sep_bl
        bl_data = abs(bl_win.wave);
    else
        bl_data = abs(data.wave(:,:,bl_inds));
    end
    tmp_dims = size(bl_data);
    bl_data = reshape(bl_data,[tmp_dims(1),tmp_dims(2)*tmp_dims(3)]);
    bl_mn = nanmean(bl_data,2);
    bl_mn = repmat(bl_mn,[1,size(data.wave,2),size(data.wave,3)]);
    bl_sd = nanstd(bl_data,[],2);
    bl_sd = repmat(bl_sd,[1,size(data.wave,2),size(data.wave,3)]);
       
else
    if sep_bl
        bl_data = bl_win.wave;
    else
        bl_data = data.wave(:,bl_inds);
    end
    bl_mn = nanmean(bl_data(:));
    bl_sd = nanstd(bl_data(:));
    
end
data_blc.wave = (data.wave-bl_mn)./bl_sd;

data_blc.time = data.time;
data_blc.fsample = data.fsample;



