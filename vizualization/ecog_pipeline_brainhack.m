%% ECoG Problem Size Paper
% To be submitted to Current Biology as a Report
addpath(genpath('/Users/pinheirochagas/Pedro/NeuroSpin/Experiments/Calculia/scripts/Calc_ECoG'))

%% List Subjects for post-processing
% MMR
subjectsMMRall = {'S12_32_JTb','S12_38_LK','S12_42_NC','S13_47_JT2','S13_53_KS2','S13_57_TVD','S14_62_JW','S14_64_SP','S14_66_CZ','S14_80_KB'};
% subjectsMMRall = {'S12_32_JTb','S12_38_LK','S12_42_NC','S13_47_JT2','S13_53_KS2','S13_57_TVD','S14_62_JW','S14_64_SP','S14_66_CZ'};

data_root = '/Volumes/NeuroSpin2T/Calc_ECoG/analysis_ECoG/neuralData/';
sub_ID = 'S12_32_JTb';

%% Avg MMR 
for i = 1:length(subjectsMMRall)
    sprintf('procesing subject %d', i)
    avgMMRtrials(subjectsMMRall{i});
end


% Import results from cluster
load([data_root 'SpecData/' 'cluster/cluster_labels.mat'])
labels = labels+1;
data_all = load([data_root 'SpecData/' 'cluster/data.mat'])
data_all = data_all.data;

%% Load MNI coordinates
for i = 1:length(subjectsMMRall)
    % Load data
    sub_ID = subjectsMMRall{i};
    gammadir = [data_root 'SpecData/' sub_ID '/'];
    data_fieldtrip_dir = [gammadir 'data_fieldtrip/'];
    load([data_root 'electrode_coords/MNI/' subjectsMMRall{i} '_mni_elecs.mat'])
    load([data_fieldtrip_dir sub_ID '_MMR_data_stats_z_FDR_all.mat'], 'StatsGamma');
    el_mniPlot = el_mni(StatsGamma.chan_all,:);
    el_mniPlot_all{i} = el_mniPlot;  
end
el_mniPlot_all = vertcat(el_mniPlot_all{:});
el_mniPlot_all(:,1) = abs(el_mniPlot_all(:,1)) * -1;


%% Load template brain (only right hemisphere)
cortex_TemplateRight = load(['/Volumes/NeuroSpin2T/Calc_ECoG/analysis_ECoG/neuralData/' 'cortex/Colin_cortex_right.mat']);
cortex_TemplateLeft = load(['/Volumes/NeuroSpin2T/Calc_ECoG/analysis_ECoG/neuralData/' 'cortex/Colin_cortex_left.mat']);


%% Define markers
colInc = [255 0 0]/255;
colDec = [0 0 255]/255;
colNonresp = [0 0 0]/255;
mark = '.';
MarkSizeEffect = 50;
MarkSizenoEffect = 25;
colRing = [255 255 255]/255;
MarkRing = 'o';
MarkSizeRing = 10;
colors = jet(length(unique(labels)))

%% Plot the template brain
figureDim = [0 0 1 .6];
figure('units','normalized','outerposition',figureDim)
subplot(1,2,1)
ctmr_gauss_plot(cortex_TemplateLeft.cortex,[0 0 0], 0, 'l', 1)
subplot(1,2,2)
ctmr_gauss_plot(cortex_TemplateLeft.cortex,[0 0 0], 0, 'l', 4)
    

%% Plot the template brain
for c = 1:length(el_mniPlot_all)
    el_add(el_mniPlot_all(c,:),'k',mark,MarkSizenoEffect,[1,2,1])
    el_add(el_mniPlot_all(c,:),'k',mark,MarkSizenoEffect,[1,2,2])
end
save2pdf('/Volumes/NeuroSpin2T/Calc_ECoG/coverage.pdf', gcf, 600)


%% Plot the template brain
for c = 1:length(el_mniPlot_all)
    f = plot3(el_mniPlot_all(c,1),el_mniPlot_all(c,2),el_mniPlot_all(c,3), mark, 'Color', 'k', 'MarkerSize', MarkSizenoEffect);

%     el_add(el_mniPlot_all(c,:),colors(labels(c),:),mark,MarkSizenoEffect,[1,2,1])
%     el_add(el_mniPlot_all(c,:),colors(labels(c),:),mark,MarkSizenoEffect,[1,2,2])
end



%% Load template brain (only right hemisphere)
cluster_num = 12 % 9 and 12 
color_el = cdcol.orange;

el_mniPlot = el_mniPlot_all(labels==cluster_num,:);
el_mniPlot(:,1) = -70;

for c = 1:length(el_mniPlot)
    f = plot3(el_mniPlot(c,1)*c,el_mniPlot(c,2),el_mniPlot(c,3), 'o', 'Color', 'k', 'MarkerFaceColor', color_el, 'MarkerSize', 20);     

%     el_add2(el_mniPlot(c,:),'g',mark,MarkSizenoEffect*2,[1,2,1])
%     el_add2(el_mniPlot(c,:),'g',mark,MarkSizenoEffect*2,[1,2,2])
end
% save2pdf('/Volumes/NeuroSpin2T/Calc_ECoG/cluster_30.pdf', gcf, 600)
savePNG(gcf,400, [dir_out 'cluster_12_brain.png'])



figure
dataplot = data_all(labels==cluster_num,:)'
dataplottmp = dataplot>0.15;
dataplot = dataplot(:,find(sum(dataplottmp)==0));
plot(dataplot, 'Color', color_el, 'LineWidth', 2)

plot(data_all', 'Color', 'k', 'LineWidth', 1)

set(gca,'xticklabel',[])
set(gca,'yticklabel',[])

set(gca,'FontSize',20)

xlabel('Time')
ylabel('HFB')
ylim([-0.06 0.13])
% save2pdf('/Volumes/NeuroSpin2T/Calc_ECoG/allchan.pdf', gcf, 600)
savePNG(gcf,400, [dir_out 'cluster_12_time.png'])


plot3(els(:,1),els(:,2),els(:,3),'Marker', '.','Color', 'r','MarkerSize',50, 'MarkerFaceColor','r')

plot3(1,2,3,'Marker', makerType,'Color', elcol,'MarkerSize',50, 'MarkerFaceColor',elcol)

%% Saving
savePNG(gcf,200, [GrouPresultsDir 'brainMap_coverage_' brain '_.png'])
% 
%     data_root = '/Volumes/NeuroSpin2T/Calc_ECoG/analysis_ECoG/neuralData/';
%     gammadir = [data_root 'SpecData/' sub_ID '/'];
%     data_fieldtrip_dir = [gammadir 'data_fieldtrip/'];



 %%% WORK ON BAD CHANNELS EXCLUSION!!!
 %%%%
%% Load avg data
subjectsMMRall = {'S12_32_JTb','S12_38_LK','S12_42_NC','S13_47_JT2','S13_53_KS2','S13_57_TVD','S14_62_JW','S14_64_SP','S14_66_CZ'};
data_root = '/Volumes/NeuroSpin2T/Calc_ECoG/analysis_ECoG/neuralData/';

math_all = [];
memo_all = [];
for s = 1:length(subjectsMMRall)
    disp(['loading subject ' subjectsMMRall{s}]);
    load([data_root sprintf('SpecData/%s/data_fieldtrip/%s_mmr_avg.mat', subjectsMMRall{s}, subjectsMMRall{s})]);
%     math_memo = dataCalc.trial{1} - dataMemo.trial{1};
    math = dataCalc.trial{1};
%     math(exclude_chan_math{s},:) = [];
    
    memo = dataMemo.trial{1};
%     math(exclude_chan_memo{s},:) = [];
    
%     math_norm = normalize(math);
%     memo_norm = normalize(memo);
    for ii = 1:size(math,1)
        math_norm = (math-min(math(:)))/(max(math(:))-min(math(:)));
        memo_norm = (memo-min(memo(:)))/(max(memo(:))-min(memo(:)));
%         math_memo_norm = 2*(math_memo-min(math_memo(:)))/(max(math_memo(:))-min(math_memo(:)))-1;
    end
    math_all = [math_all;math_norm];
    memo_all = [memo_all;memo_norm];
end


%% Verify outiler channels
exclude = math_norm;
for i = 1:size(exclude,1) 
    chan = exclude(i,:);
    idx_max = find(chan == max(chan));
    hold on
    plot(chan)
    text(idx_max,  max(chan), num2str(i))    
end

% exclude_chan_math = {[98, 75], [], [], [], [], [], [], 31, [62, 73]};
% exclude_chan_memo = {[], [], [], [], [], [], [], [31, 25, 19]};
% el_mniPlot_math(unique([horzcat(exclude_chan_math{:}) horzcat(exclude_chan_memo{:})]),:) = []

%% Get indices for colloring
[col_idx,cols] = colorbarFromValues(math_all(:), 'RedsWhite');
cols = flipud(cols)

figureDim = [0 0 .2 .2];
figure('units','normalized','outerposition',figureDim)
for i = 15:5:length(cols)
    plot(i, 1, '.', 'MarkerSize', 20+(i/2), 'Color', cols(i,:))
    hold on
end
axis off
dir_out = '/Users/pinheirochagas/Desktop/';
savePNG(gcf,400, [dir_out 'Blues.png'])
savePNG(gcf,400, [dir_out 'Reds.png'])


[col_idx,cols] = colorbarFromValues(math_all(:), 'RedsWhite');
col_idx_math = reshape(col_idx,size(math_all,1), size(math_all,2));
[col_idx,cols] = colorbarFromValues(memo_all(:), 'BluesWhite');
col_idx_memo = reshape(col_idx,size(memo_all,1), size(memo_all,2));
el_mniPlot_all(:,1) = -70;
el_mniPlot_all_math = el_mniPlot_all;
el_mniPlot_all_memo = el_mniPlot_all;
el_mniPlot_all_math(:,1) = el_mniPlot_all(:,1) - sum(math_all,2);
el_mniPlot_all_memo(:,1) = el_mniPlot_all(:,1) - sum(memo_all,2);


mark = 'o';
MarkSizeEffect = 35;
colRing = [0 0 0]/255;

time = dataCalc.time(1:1000);


%% Plot math
F = struct;
count = 0;

for e = 1:size(math_all,2)
    count = count+1;
    ctmr_gauss_plot(cortex_TemplateLeft.cortex,[0 0 0], 0, 'l', 1)
    % Sort to highlight larger channels
    for i = 1:size(el_mniPlot_all_math)
%         f = plot3(el_mniPlot_all(i,1)/(1-abs(math_memo_norm_all(i,e))),el_mniPlot_all(i,2),el_mniPlot_all(i,3), 'o', 'Color', 'k', 'MarkerFaceColor', cols(col_idx_math_memo(i,e),:), 'MarkerSize', MarkSizeEffect*abs(math_memo_norm_all(i,e))+0.01);
        f = plot3(el_mniPlot_all_math(i,1),el_mniPlot_all_math(i,2),el_mniPlot_all_math(i,3), 'o', 'Color', 'k', 'MarkerFaceColor', cols(col_idx_math(i,e),:), 'MarkerSize', MarkSizeEffect*abs(math_all(i,e))+0.01);     
    end
    time_tmp = num2str(time(e));
    
    if length(time_tmp) < 6
        time_tmp = [time_tmp '00'];
    end
    if strcmp(time_tmp(1), '-')
        time_tmp = time_tmp(1:6);
    else
        time_tmp = time_tmp(1:5);
    end
    
    text(50, 15, -60, [time_tmp ' s'], 'FontSize', 40)
    cdata = getframe(gcf);
    F(count).cdata = cdata.cdata;
    F(count).colormap = [];
    close all
end

fig = figure;
movie(fig,F,1)

videoRSA = VideoWriter([dir_out 'mmr_math.avi']);
% uncompressedVideo = VideoWriter([dir_out 'video_ex_2.avi'], 'Uncompressed AVI');
videoRSA.FrameRate = 60;  % Default 30
videoRSA.Quality = 100;    % Default 75
open(videoRSA);
writeVideo(videoRSA, F);
close(videoRSA);


%% Plot memo
F = struct;
count = 0;

for e = 1:size(memo_all,2)
    count = count+1;
    ctmr_gauss_plot(cortex_TemplateLeft.cortex,[0 0 0], 0, 'l', 1)
    % Sort to highlight larger channels
    for i = 1:size(el_mniPlot_all_memo)
%         f = plot3(el_mniPlot_all(i,1)/(1-abs(math_memo_norm_all(i,e))),el_mniPlot_all(i,2),el_mniPlot_all(i,3), 'o', 'Color', 'k', 'MarkerFaceColor', cols(col_idx_math_memo(i,e),:), 'MarkerSize', MarkSizeEffect*abs(math_memo_norm_all(i,e))+0.01);
        f = plot3(el_mniPlot_all_memo(i,1),el_mniPlot_all_memo(i,2),el_mniPlot_all_memo(i,3), 'o', 'Color', 'k', 'MarkerFaceColor', cols(col_idx_memo(i,e),:), 'MarkerSize', MarkSizeEffect*abs(memo_all(i,e))+0.01);     
    end
    time_tmp = num2str(time(e));
    
    if length(time_tmp) < 6
        time_tmp = [time_tmp '00'];
    end
    if strcmp(time_tmp(1), '-')
        time_tmp = time_tmp(1:6);
    else
        time_tmp = time_tmp(1:5);
    end
    
    text(50, 15, -60, [time_tmp ' s'], 'FontSize', 40)
    cdata = getframe(gcf);
    F(count).cdata = cdata.cdata;
    F(count).colormap = [];
    close all
end

fig = figure;
movie(fig,F,1)

videoRSA = VideoWriter([dir_out 'mmr_memo.avi']);
% uncompressedVideo = VideoWriter([dir_out 'video_ex_2.avi'], 'Uncompressed AVI');
videoRSA.FrameRate = 60;  % Default 30
videoRSA.Quality = 100;    % Default 75
open(videoRSA);
writeVideo(videoRSA, F);
close(videoRSA);






