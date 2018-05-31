function PlotTrialAvg(data,column,conds,col,plot_params)

% plots average timecourse for each condition, separately for each electrode
% INPUTS:
%       data: can be either freq x trial x time  or trial x time
%       column: column of data.trialinfo by which to sort trials for plotting
%       conds:  cell containing specific conditions to plot within column (default: all of the conditions within column)
%       col:    colors to use for plotting each condition (otherwise will
%               generate randomly)
%       plot_params:    .eb : plot errorbars ('ste','std',or 'none')
%                       .lw : line width of trial average
%                       .legend: 'true' or 'false'
%                       .label: 'name','number', or 'none'
%                       .sm: width of gaussian smoothing window (s)
%                       .textsize: text size of axis labels, etc
%                       .xlabel
%                       .ylabel
%                       .freq_range: frequency range to extract (only applies to spectral data)
%                       .bl_win: baseline correction window
%                       .xlim
load('cdcol.mat')

if ndims(data.wave)==3 % if spectral data
    datatype = 'Spec';
else
    datatype = 'NonSpec';
end

if nargin < 5 || isempty(plot_params)
    plot_params.eb = 'ste';
    plot_params.lw = 3;
    plot_params.legend = true;
    plot_params.label = 'name';
    plot_params.sm = 0.05;
    plot_params.textsize = 20;
    plot_params.xlabel = 'Time (s)';
    plot_params.ylabel = 'z-scored power';
    plot_params.freq_range = [70 180];
    plot_params.bl_win = [-0.2 0];
    plot_params.xlim = [-0.2 3];
end

if nargin < 4 || isempty(col)
    col = [cdcol.carmine;
        cdcol.ultramarine;
        cdcol.grassgreen;
        cdcol.lilac;
        cdcol.yellow;
        cdcol.turquoiseblue;
        cdcol.flamered;
        cdcol.periwinkleblue;
        cdcol.yellowgeen
        cdcol.purple];
end

if nargin < 3 || isempty(conds)
    conds = unique(data.trialinfo.(column));
end
ncategs = length(conds);

%% 

winSize = floor(data.fsample*plot_params.sm);
gusWin= gausswin(winSize)/sum(gausswin(winSize));

plot_data = cell(1,ncategs);

if strcmp(datatype,'Spec')
    freq_inds = data.freqs >= plot_params.freq_range(1) & data.freqs <= plot_params.freq_range(2);
    data.wave = squeeze(nanmean(abs(data.wave(freq_inds,:,:))));  % avg across freq. domain
end

% organize trials by categories
for ci = 1:ncategs
    trials = ismember(data.trialinfo.(column),conds{ci});
    plot_data{ci}=cat(1,plot_data{ci},data.wave(trials,:));
end


% smooth and plot data
for ci = 1:ncategs
    plot_data{ci} = convn(plot_data{ci},gusWin','same');
    lineprops.col{1} = col(ci,:);
    if ~strcmp(plot_params.eb,'none')
        lineprops.style= '-';
        lineprops.width = plot_params.lw;
        lineprops.edgestyle = '-';
        if strcmp(plot_params.eb,'ste')
            mseb(data.time,nanmean(plot_data{ci}),nanstd(plot_data{ci})/sqrt(size(plot_data{ci},1)),lineprops,1);
            hold on
        else %'std'
            mseb(data.time,nanmean(plot_data{ci}),nanstd(plot_data{ci}),lineprops,1);
            hold on
        end
    end
    h(ci)=plot(data.time,nanmean(plot_data{ci}),'LineWidth',plot_params.lw,'Color',col(ci,:));
    hold on
end
xlim(plot_params.xlim)

xlabel(plot_params.xlabel);
ylabel(plot_params.ylabel)

set(gcf,'color','w')
set(gca,'fontsize',plot_params.textsize)
box off

if (plot_params.legend)
    leg = legend(h,conds,'Location','Northeast', 'AutoUpdate','off');
    legend boxoff
    set(leg,'fontsize',14)
end

if strcmp(plot_params.label,'name')
    title(data.label)
elseif strcmp(plot_params.label,'number')
    title('Elec ',num2str(el))
end

plot([0 0],ylim,'Color', [0 0 0], 'LineWidth',2)
plot(xlim,[0 0],'Color', [0 0 0], 'LineWidth',2)

box on % Pedro concluded


