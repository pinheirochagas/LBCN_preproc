% function PlotERSP(sbj,task,column,elecs,conds,noise_method,plot_params)
function PlotERSP(data,column,conds,plot_params)
% plots spectrogram for each condition, separately for each electrode
% INPUTS:
%       data: spectral data(freq x trials x time)
%       column: column of data.trialinfo by which to sort trials for plotting
%       conds:  cell containing specific conditions to plot within column (default: all)
%       plot_params:    .label: 'name','number', or 'none'
%                       .textsize: text size of axis labels, etc
%                       .xlabel
%                       .ylabel
%                       .bl_win: baseline correction window
%                       .xlim
%                       .cmap
%                       .clim

%%

if nargin < 4 || isempty(plot_params)
    plot_params.legend = 'true';
    plot_params.label = 'name';
    plot_params.textsize = 20;
    plot_params.xlabel = 'Time (s)';
    plot_params.ylabel = 'Freq (Hz)';
    plot_params.xlim = [data.time(1) data.time(end)];
    plot_params.cmap = cbrewer2('RdBu');
    plot_params.cmap = plot_params.cmap(end:-1:1,:);
    plot_params.clim = [-2 2];
    plot_params.sm = 0.05;
end

if nargin < 3 || isempty(conds)
    conds = unique(data.trialinfo.(column));
end
ncategs = length(conds);

winSize = floor(data.fsample*plot_params.sm);
gusWin= gausswin(winSize)/sum(gausswin(winSize));

%% 

plot_data = cell(1,length(conds));
% ntrials = size(data.wave,2);

for ci = 1:ncategs
    trials = ismember(data.trialinfo.(column),conds{ci});
    plot_data{ci}=data.wave(:,trials,:);
end


freq_ticks = 1:4:length(data.freqs);
freq_labels = cell(1,length(freq_ticks));
for i = 1:length(freq_ticks)
    freq_labels{i}=num2str(round(data.freqs(freq_ticks(i))));
end
% plot data
for ci = 1:ncategs
    subplot(1,ncategs+1,ci)
    data_tmp = abs(squeeze(nanmean(plot_data{ci},2))); % average across trials
    data_tmp = convn(data_tmp,gusWin','same');
    imagesc(data.time,1:length(data.freqs),data_tmp)
%     imagesc(data.time,1:length(data.freqs),data_tmp,plot_params.clim)
    axis xy
    hold on
    colormap(plot_params.cmap);
    set(gca,'YTick',freq_ticks)
    set(gca,'YTickLabel',freq_labels)
    plot([0 0],ylim,'k-','LineWidth',3)
    title(conds{ci})
    xlabel(plot_params.xlabel);
    ylabel(plot_params.ylabel)
    xlim(plot_params.xlim)
    box off
end

set(gcf,'color','w')
set(gca,'fontsize',plot_params.textsize)

if strcmp(plot_params.label,'name')
    suptitle(data.label)
elseif strcmp(plot_params.label,'number')
    suptitle('Elec ',num2str(el))
end


