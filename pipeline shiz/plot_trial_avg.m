function plot_trial_avg(sbj,task,datatype,column,elecs,conds,col,noise_method,plot_params)

% plots average timecourse for each condition, separately for each electrode
% INPUTS:
%       sbj:    name of subject
%       task:   name of task
%       datatype: 'raw' or 'spect' (raw or spectrally decomposed) epoched data
%       column: column of data.trialinfo by which to sort trials for plotting
%       elecs:  electrodes to plot (default: all)
%       conds:  cell containing specific conditions to plot within column (default: all of the conditions within column)
%       col:    colors to use for plotting each condition (otherwise will
%               generate randomly)
%       noise_method:   how to exclude data for plotting (default: 'trial'):
%                       'none':     no epoch rejection
%                       'trial':    exclude noisy trials
%                       'timepts':  set noisy timepoints to NaN but don't exclude entire trials
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
load cdcol.mat

initialize_dirs

% load globalVar
BN = block_by_subj(sbj,task);
load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',data_root,sbj_name,task,sbj_name,BN{1}));

if nargin < 9
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

if nargin < 8
    noise_method = 'trial';
end

if nargin < 7
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

if nargin < 5
    elecs = setdiff(1:globalVar.nchan,globalVar.refChan);
end

data = load_data(sbj,task,elecs(1),datatype);
if nargin < 6
    conds = unique(data.trialinfo.(column));
end
ncategs = length(categ_plot);

winSize = floor(data.fsample*winSize_s);
gusWin= gausswin(winSize)/sum(gausswin(winSize));

for ei = 1:length(elecs)
    close all
    el = elecs(ei);
    plot_data = cell(1,ncategs);
    for bi = 1:length(BN)
        data = load_data(sbj,task,el,datatype); %just for block
        ntrials = size(data.trialinfo(1));
        bl_inds = data.time >= plot_params.bl_win(1) & data.time <= plot_params.bl_win(2);
        freq_inds = data.freqs >= plot_params.freq_range(1) & data.freqs <= plot_params.freq_range(2);
        
        load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',data_root,sbj_name,task,sbj_name,BN{bi}));
        if strcmp(noise_method,'trial')
            if strcmp(datatype,'raw')
                data.wave(globalVar.bad_epochs(el).badtrials,:)=NaN;
            else
                data.wave(:,globalVar.bad_epochs(el).badtrials,:)=NaN;
            end
        elseif strcmp(noise_method,'timepts')
            for ti = 1:ntrials
                if strcmp(datatype,'raw')
                    data.wave(ti,globalVar.bad_epochs(el).badinds{ti})=NaN;
                else
                    data.wave(:,ti,globalVar.bad_epochs(el).badinds{ti})=NaN;
                end
            end
        end
        
        % baseline correction
        if strcmp(datatype,'raw')
            bl_data = data.wave(:,bl_inds);
            bl_mn = nanmean(bl_data(:));
            bl_sd = nanstd(bl_data(:));
            data.wave = (data.wave-bl_mn)/bl_sd;
        else
            bl_data = data.wave(:,:,bl_inds);
            tmp_dims = size(bl_data);
            bl_data = reshape(bl_data,[tmp_dims(1),tmp_dims(2)*tmp_dims(3)]);
            bl_mn = nanmean(bl_data,2);
            bl_mn = repmat(bl_mn,[1,size(data.wave,2),size(data.wave,3)]);
            bl_sd = nanstd(bl_data,[],2);
            bl_sd = repmat(bl_sd,[1,size(data.wave,2),size(data.wave,3)]);
            data.wave = (data.wave-bl_mn)./bl_sd;
            data.wave = squeeze(nanmean(data.wave(freq_inds,:,:)));
        end
        
        % organize trials by categories
        for ci = 1:ncategs
            trials = ismember(data.trialinfo.(column),conds{ci});
            plot_data{ci}=cat(1,plot_data{ci},data.wave(trials,:));
        end
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
    set(gcf,'fontsize',plot_params.textsize)
    box off
    
    if (plot_params.legend)
        leg = legend(h,conds,'Location','Northwest');
        legend boxoff
        set(leg,'fontsize',14)
    end
    
    if strcmp(plot_params.label,'name')
        title(data.chanlabel)
    elseif strcmp(plot_params.label,'number')
        title('Elec ',num2str(el))
    end
    
    plot([0 0],ylim,'k--','LineWidth',3)
    plot(xlim,[0 0],'k--','LineWidth',3)
    if (plot_channame)
        fp= sprintf('%s/%s/%s/%s/%s_Ch%.3d_%s_%s.png',results_dir,'FreqDecompose',ver,plot_folder,sbj_name,el,channame,project_name);
    else
        fp= sprintf('%s/%s/%s/%s/%s_Ch%.3d_%s.png',results_dir,'FreqDecompose',ver,plot_folder,sbj_name,el,project_name);
    end
    
    saveas(gcf,fp)
end

