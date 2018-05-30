function plot_itc(sbj,task,column,elecs,conds,noise_method,plot_params)

% plots inter-trial phase coherence (ITC) for each condition, separately for each electrode
% INPUTS:
%       sbj:    name of subject
%       task:   name of task
%       column: column of data.trialinfo by which to sort trials for plotting
%       elecs:  electrodes to plot (default: all)
%       conds:  cell containing specific conditions to plot within column (default: all)
%       noise_method:   how to exclude data for plotting (default: 'trial'):
%                       'none':     no epoch rejection
%                       'trial':    exclude noisy trials
%                       'timepts':  set noisy timepoints to NaN but don't exclude entire trials
%       plot_params:    .label: 'name','number', or 'none'
%                       .textsize: text size of axis labels, etc
%                       .xlabel
%                       .ylabel
%                       .bl_win: baseline correction window
%                       .xlim
%                       .cmap
%                       .clim

load cdcol.mat

initialize_dirs

% load globalVar
BN = block_by_subj(sbj,task);
load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',data_root,sbj_name,task,sbj_name,BN{1}));

if nargin < 7
    plot_params.legend = 'true';
    plot_params.label = 'name';
    plot_params.textsize = 20;
    plot_params.xlabel = 'Time (s)';
    plot_params.ylabel = 'Freq (Hz)';
    plot_params.xlim = [-0.2 3];
    plot_params.freq_range = [0 40];    % freq. range to show (ITC less reliable for higher frequencies)
    plot_params.cmap = cbrewer2('RdYlBu');
    plot_params.cmap = plot_params.cmap(end:-1:1,:);
    plot_params.clim = [0 0.5];
end

if nargin < 6
    noise_method = 'trial';
end

if nargin < 5 || strcmp(elecs,'all')
    elecs = setdiff(1:globalVar.nchan,globalVar.refChan);
end

data = load_data(sbj,task,elecs(1),datatype);

% if categories not defined, make plots for all categories within specified column
if nargin < 4
    conds = unique(data.trialinfo.(column));
end
ncategs = length(categ_plot);

for ei = 1:length(elecs)
    close all
    el = elecs(ei);
    plot_data = cell(1,ncategs);
    for bi = 1:length(BN)
        data = load_data(sbj,task,el,'spect'); %just for block
        ntrials = size(data.wave,2);
        
        load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',data_root,sbj_name,task,sbj_name,BN{bi}));
        if strcmp(noise_method,'trial') 
            data.wave(:,globalVar.bad_epochs(el).badtrials,:)=NaN; 
        elseif strcmp(noise_method,'timepts')
            for ti = 1:ntrials   
                data.wave(:,ti,globalVar.bad_epochs(el).badinds{ti})=NaN; 
            end
        end

        % organize trials by categories
        for ci = 1:ncategs
            trials = ismember(data.trialinfo.(column),conds{ci});
            plot_data{ci}=cat(2,plot_data{ci},data.wave(:,trials,:));
        end
    end
    
    freq_inds = [find(data.freqs >= plot_params.freq_range(1),1) find(data.freqs >= plot_params.freq_range(2),1)]; 
    
    freq_ticks = 1:4:length(data.freqs);
    freq_labels = cell(1,length(freq_ticks));
    for i = 1:length(freq_ticks)
        freq_labels{i}=num2str(round(data.freqs(freq_ticks(i))));
    end
    % plot data
    for ci = 1:ncategs
        itc_tmp = squeeze(nanmean(exp(1i*(angle(plot_data{ci}))),2));
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
    end

    set(gcf,'color','w')
    set(gcf,'fontsize',plot_params.textsize)
    
    if strcmp(plot_params.label,'name')
        suptitle(data.chanlabel)
    elseif strcmp(plot_params.label,'number')
        suptitle('Elec ',num2str(el))
    end

    fp= sprintf('%s/%s/%s/%s/%s_Ch%.3d_%s_%s.png',results_dir,'FreqDecompose',ver,plot_folder,sbj_name,el,channame,project_name);

    saveas(gcf,fp)
end

