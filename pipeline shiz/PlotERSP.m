% function PlotERSP(sbj,task,column,elecs,conds,noise_method,plot_params)
function PlotERSP(data,column,conds,plot_params, noise_method)
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


% organize trials by categories
if strcmp(noise_method, 'trials')
    for ci = 1:ncategs
        trials = ismember(data.trialinfo.(column),conds{ci}) & data.trialinfo.bad_epochs == false;
        plot_data{ci}=data.wave(:,trials,:);
    end
else
    for ci = 1:ncategs
        trials = ismember(data.trialinfo.(column),conds{ci});
        plot_data{ci}=data.wave(:,trials,:);
    end
end


% for ci = 1:ncategs
%     trials = ismember(data.trialinfo.(column),conds{ci});
%     plot_data{ci}=data.wave(:,trials,:);
% end



% Set the range of the plot
plot_params.clim = [-prctile(data.wave(:), 90) prctile(data.wave(:), 90)];


freq_ticks = 1:4:length(data.freqs);
freq_labels = cell(1,length(freq_ticks));
for i = 1:length(freq_ticks)
    freq_labels{i}=num2str(round(data.freqs(freq_ticks(i))));
end
% plot data
figureDim = [0 0 .8 .4];
figure('units', 'normalized', 'outerposition', figureDim)
for ci = 1:ncategs
    subplot(1,ncategs+1,ci)
    data_tmp = squeeze(nanmean(plot_data{ci},2)); % average across trials
    data_tmp_all{ci} = convn(data_tmp,gusWin','same');
    imagesc(data.time,1:length(data.freqs),data_tmp,plot_params.clim)
%     imagesc(data.time,1:length(data.freqs),data_tmp)
    colorbar
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
    set(gca,'fontsize',plot_params.textsize)
    box off
    y_lim = ylim;
    plotLines(data, y_lim)
end

% Plot the difference
subplot(1,ncategs+1,ci+1)
data_tmp_diff = data_tmp_all{1} - data_tmp_all{2};
imagesc(data.time,1:length(data.freqs),data_tmp_diff,plot_params.clim/2)
colorbar
%     imagesc(data.time,1:length(data.freqs),data_tmp,plot_params.clim)
axis xy
hold on
colormap(plot_params.cmap);
set(gca,'YTick',freq_ticks)
set(gca,'YTickLabel',freq_labels)
plot([0 0],ylim,'k-','LineWidth',3)
title('difference')
xlabel(plot_params.xlabel);
ylabel(plot_params.ylabel)
xlim(plot_params.xlim)
set(gca,'fontsize',plot_params.textsize)
box off

%% Plot lines to mark events

plotLines(data, y_lim)


set(gcf,'color','w')

if strcmp(plot_params.label,'name')
    suptitle(data.label)
elseif strcmp(plot_params.label,'number')
    suptitle('Elec ',num2str(el))
end

end


function plotLines(data, y_lim)

if size(data.trialinfo.allonsets,2) > 1
    time_events = cumsum(nanmean(diff(data.trialinfo.allonsets,1,2)));
    for i = 1:length(time_events)
        plot([time_events(i) time_events(i)],y_lim,'Color', [0 0 0], 'LineWidth',2)
    end
else
    
end
plot([0 0],y_lim,'Color', [0 0 0], 'LineWidth',2)
plot(xlim,[0 0],'Color', [0 0 0], 'LineWidth',2)
ylim(y_lim)

end

