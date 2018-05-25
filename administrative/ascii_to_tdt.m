sbj = 'S13_47_JT2';
block_name  = 'NKClinicalRest2';

initialize_dirs;

fchan = 'S11_20_rest2.m00';

% -------------------------------------------------------------------------
% Function to convert Nihon Kohden iEEG (raw ECoG data in .m00 format,
% exported from NK in -ascii) to an SPM MEEG file array, including events
% onsets and durations.
% Inputs:
% - fchan: the full file name
% - fev: the event file name (optional, default: no event)
% - bch: indexes of the bad channels AFTER re-ordering (i.e. bad channels
%        in the TDT file, optional, default: no bad channel). These will
%        not be included in the MEEG object.
% - ord: indexes to re-order the channels to match TDT data. (optional).
% Outputs:
% - D: the MEEG object containing specified events, with bad channels
%      discarded.
% - lab_chans: original labels of the channels, to check that the
%      re-ordering was performed correctly.
% No pre-processing such as filtering or downsampling is performed.
%--------------------------------------------------------------------------
% Written by J. Schrouff, 10/17/2013, Stanford University


fid = fopen(fchan);
header = textscan(fid,'%s %s %s %s %s %s',1,'Delimiter',' ');
for i=1:4
    in = strfind(header{i}{1},'=');
    header{i} = header{i}{1}(in+1:end);
end
nsampl = str2double(header{1}); % get the number of TimePoints
nchan = str2double(header{2}); % get the number of Channels
fsample = (1/str2double(header{4}))*1000; % get the sampling rate
% disp(['TimePoints:',num2str(nsampl)])
% disp(['Channels:',num2str(nchan)])
% disp(['Sampling rate:',num2str(fsample)])
% % get channel names from header as well
formatspec = repmat('%s ',1,nchan);
lab_chans = textscan(fid,formatspec,2,'Delimiter',' ');
for i=1:length(lab_chans)
    iref = strfind(lab_chans{i}{1},'-'); %take the reference out of the channel name
    lab_chans{i} = lab_chans{i}{1}(1:iref-1);
    lab_chans{i}= strrep(lab_chans{i},'*','');
end

for i = 1:length(lab_chans);
    wave = [];
    channame = lab_chans{i};
    fs = fsample;
    if (i<10)
        chanlbl = ['0',num2str(i)];
    else
        chanlbl = num2str(i);
    end
    fn = sprintf('%s/OriginalData/%s/%s/iEEG%s_%s.mat',data_root,sbj,block_name,block_name,chanlbl);
    save(fn,'wave','channame','fs')
    disp(i)
end
%
% [d1,fname] = fileparts(fchan);
%
% %Gather info about channel ordering and bad channels
% if nargin<3
%     bch = [];
% end
% if nargin<4 || isempty(ord)
%     ord = 1:nchan; % in the future, create interface to re-order channels using lab_chans
% end
% ordchan = 1:nchan;
% if ~isempty(bch)
%     [tok,itk] = setdiff(ordchan,bch);
% else
%     itk = 1:nchan;
% end
% ord = ord(itk);
% namchan = cell(length(ord),1);
% for i=1:length(ord)
%     namchan{i} = ['iEEG_',num2str(itk(i))];
% end
% lab_chans = lab_chans(ord);
%
% % Start filling the data structure D
% D = [];
% D.Fsample = fsample;
%

clear segarray;
block_size = 30000;
format = repmat('%d',1,nchan);
file_id = fopen(fchan);
x=1;
istart = 1;
iend = istart + block_size-1;
% segarray = textscan(file_id,format,block_size,'HeaderLines',2);

while ~feof(file_id)
    segarray = textscan(file_id,format,block_size,'HeaderLines',2);
    for i = 1:length(lab_chans)
        if (i<10)
            chanlbl = ['0',num2str(i)];
        else
            chanlbl = num2str(i);
        end
        fn = sprintf('%s/OriginalData/%s/%s/iEEG%s_%s.mat',data_root,sbj,block_name,block_name,chanlbl);
        load(fn)
        wave = [wave segarray{i}'];
        save(fn,'wave','channame','fs')
    end
    disp(['Reading block ',num2str(x), ' ...'])
    x = x + 1;
end

for i = 1:length(lab_chans)
    if (i<10)
        chanlbl = ['0',num2str(i)];
    else
        chanlbl = num2str(i);
    end
    fn = sprintf('%s/OriginalData/%s/%s/iEEG%s_%s.mat',data_root,sbj,block_name,block_name,chanlbl);
    load(fn)
    wave = single(wave);
    save(fn,'wave','channame','fs')
end
% fclose(file_id);
%
% %Deal with channel information
% D.channels = struct('bad',repmat({0}, 1, length(ord)),...
%     'type', repmat({'EEG'}, 1, length(ord)),...
%     'label', namchan');
%
% %Deal with trial/event information
% if nargin<3
%     fev = spm_select(1,'mat','Select event file for dataset');
% end
% if isempty(fev)
%     % Create empty event field and transform into SPM MEEG object
%     evtspm=[];
%     D.trials.label = 'Undefined';
%     D.trials.events = evtspm;
%     D.trials.onset = 1/D.Fsample;
%     %Create and save MEEG object
%     D = meeg(D);
%     save(D);
% else
%     %get the events from each category into the structure
%     load(fev)
%     if ~exist('events','var')
%         warning('Could not extract events from file, should be in Parvizi structure')
%     else
%         if ~isfield(events,'categories')
%            warning('Could not extract events from file, should be in Parvizi structure')
%         end
%     end
%     [D] = get_events_SPMformat(events,D); % returns a SPM MEEG object with events
% end
% disp('done')
%
%
%
