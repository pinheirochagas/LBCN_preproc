%% Segment and play answers MMR EBS !!!
% 

load('/Volumes/LBCN8T/Stanford/experiments/neuralData/originalData/S18_124/E18-309_0021/PdioE18-309_0021_03.mat')



audio_output_dir = '/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/ECoG_calc_ebs/';

%% Normalize signal
normic = anlg./(max(abs(anlg)));

%% Define threshold and silence
thrh = 1;
min_silence = 5000;

%% Envelope
samples = 1000;
[up,lo] = envelope(normic,samples,'rms');

%% Start and end points
% find cut point start
cut_point1 = diff(([0 up]-[0 lo])<thrh);
cut_point1(cut_point1~=-1) = 0;

% find cut point end
cut_point2 = diff(([up 0]-[lo 0])<thrh);
cut_point2(cut_point2~=1) = 0;

% combine cutpoints
cutpoints = abs(cut_point1) + cut_point2; 

%% Count the number of regions
ct_fill = ~bwareaopen(~cutpoints, min_silence); % remove some intermediate zeros
[L, numRegions] = bwlabel(ct_fill); % count regions of 1's

%% Calculate onsets
ct_fill_0 = (ct_fill~=0);
ct_fill_d = diff(ct_fill_0);
start = find([ct_fill_0(1) ct_fill_d]==1); % Start index of each group
finish = find([ct_fill_d -ct_fill_0(end)]==-1); % Last index of each group

count = length(start);
onset_offset = cell(count,1);
for i = 1:count
    onset_offset{i} = [ start(i) finish(i)] ;
end

%% Play
for i = 1:length(onset_offset)
    soundsc(anlg(onset_offset{i}(1):onset_offset{i}(2)), 10000);
    pause(1.5)
end


