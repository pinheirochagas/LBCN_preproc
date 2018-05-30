function [epoched_data] = EpochData(data,lockevent,bef_time,aft_time,fs)

% This functon takes in non-epoched data and event file with trial info
% and outputs epoched data
% INPUTS:
%   data: data from single channel (either raw data- 1 x time; or frequency decomposed data- freq x time)
%   evts: event file (events_byTrial)
%   lockevent: 'stim' or 'resp'
%   bef_time: time (in s) before lockevent to start each epoch of data
%   aft_time: time (in s) after lockevent to end each epoch of data

nfreq = size(data,1);  % determine if single timeseries or spectral data (i.e. multiple frequencies)
ntrials = size(lockevent,1);
start_inds = floor(lockevent*fs);
bef_ind = floor(bef_time*fs);
aft_ind = floor(aft_time*fs);
len_trial = aft_ind-bef_ind + 1;

if nfreq > 1
    epoched_data.wave = nan(nfreq,ntrials,len_trial);
else
    epoched_data.wave = nan(ntrials,len_trial);
end

for i = 1:ntrials
    inds = start_inds(i)+bef_ind:start_inds(i)+aft_ind;
    if nfreq > 1
        epoched_data.wave(:,i,:)=data(:,inds);
    else
        epoched_data.wave(i,:)=data(inds);
    end
end

epoched_data.time = linspace(bef_time,aft_time,len_trial);
% add other fields from data to epoched_data
end
