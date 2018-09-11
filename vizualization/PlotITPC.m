function PlotITC(data,column,conds,plot_params,noise_method)
% Plots inter-trial phase coherence for each condition
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


if isempty(plot_params)
    plot_params.label = 'name';
    plot_params.textsize = 16;
    plot_params.xlabel = 'Time (s)';
    plot_params.ylabel = 'Freq (Hz)';
    plot_params.xlim = [data.time(1) data.time(end)];
    plot_params.cmap = cbrewer2('RdYlBu');
    plot_params.cmap = plot_params.cmap(end:-1:1,:);
    plot_params.clim = [0 0.4];
    plot_params.freq_range = [0 32];
end


if isempty(conds)
    conds = unique(data.trialinfo.(column));
end
ncategs = length(conds);

plot_data = cell(1,length(conds));

% organize trials by categories


for ci = 1:ncategs
    trials1 = find(~cellfun(@isempty,data.trialinfo.(column)));
    if strcmp(noise_method, 'trials')
        trials2 = find(ismember(data.trialinfo.(column)(trials1),conds{ci}) & data.trialinfo.bad_epochs(trials1) == false);
    else
        trials2 = find(ismember(data.trialinfo.(column)(trials1),conds{ci}));
    end
    trials = trials1(trials2);
    plot_data{ci}=data.phase(:,trials,:);
end

freq_inds = [find(data.freqs >= plot_params.freq_range(1),1) find(data.freqs >= plot_params.freq_range(2),1)];

freq_ticks = 1:4:length(data.freqs);
freq_labels = cell(1,length(freq_ticks));
for i = 1:length(freq_ticks)
    freq_labels{i}=num2str(round(data.freqs(freq_ticks(i))));
end
% plot data
figure('Position',[200 200 800 400])
for ci = 1:ncategs
%     itc_tmp = squeeze(nanmean(exp(1i*(angle(plot_data{ci}))),2));
    itc_tmp = squeeze(abs(nanmean(exp(1i*(plot_data{ci})),2)));
    subplot(1,ncategs,ci)
    imagesc(data.time,1:length(data.freqs),itc_tmp,plot_params.clim)
    axis xy
    hold on
    colormap(plot_params.cmap)
    set(gca,'YTick',freq_ticks)
    set(gca,'YTickLabel',freq_labels)
    plot([0 0],ylim,'k-','LineWidth',3)
    title(conds{ci})
    xlabel(plot_params.xlabel)
    ylabel(plot_params.ylabel)
    xlim(plot_params.xlim)
    ylim(freq_inds)
    box off
    
    set(gca,'fontsize',plot_params.textsize)
end
colorbar
set(gcf,'color','w')
