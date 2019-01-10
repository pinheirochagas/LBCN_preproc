function h = PlotTrialRTSorted(data,column,conds,plot_params)

% plots average timecourse for each condition, separately for each electrode
% INPUTS:
%       data: can be either freq x trial x time  or trial x time
%       column: column of data.trialinfo by which to sort trials for plotting
%       conds:  cell containing specific conditions to plot within column (default: all of the conditions within column)
%               can group multiple conds together by having a cell of cells
%               (e.g. conds = {{'math'},{'autobio','self-internal'}})
%       col:    colors to use for plotting each condition (otherwise will
%               generate randomly)
%       plot_params:    controls plot features (see genPlotParams.m script)

% will only work for non-spectral (i.e. Band) daata
datatype = 'NonSpec';

if isempty(plot_params)
    plot_params = genPlotParams(project_name,'timecourse');
end

ncategs = length(conds);

cmap = cbrewer2('RdBu');
cmap = cmap(end:-1:1,:);

%%
winSize = floor(data.fsample*plot_params.sm);
gusWin= gausswin(winSize)/sum(gausswin(winSize));

plot_data = cell(1,ncategs);

if strcmp(datatype,'Spec')
    freq_inds = data.freqs >= plot_params.freq_range(1) & data.freqs <= plot_params.freq_range(2);
    data.wave = squeeze(nanmean(data.wave(freq_inds,:,:)));  % avg across freq. domain
end

data.wave = convn(data.wave,gusWin','same');

% group data by conditions
% if plot_params.multielec
%     groupall = true;
% else
%     groupall = false;
% end

% if plotting single trials, include noisy trials so can plot in different color
groupall = false;
[grouped_trials_all,~] = groupConds(conds,data.trialinfo,column,'none',[],groupall);

[grouped_trials,cond_names] = groupConds(conds,data.trialinfo,column,plot_params.noise_method,plot_params.noise_fields_trials,groupall);
% if eliminating noisy trials, keep track of how many clean trials remain for
% each condition (and include in figure legend)
if (strcmp(plot_params.noise_method,'trials'))
    for gi = 1:length(cond_names)
        cond_names{gi} = [cond_names{gi},' (',num2str(length(grouped_trials{gi})),' of ',num2str(length(grouped_trials_all{gi})), ' trials)'];
    end
end

plot_data = cell(1,ncategs); % with noisy epochs excluded
plot_data_all = cell(1,ncategs); %including noisy epochs
for ci = 1:ncategs
    plot_data{ci} = data.wave(grouped_trials{ci},:);
    trial_data{ci} = data.trialinfo(grouped_trials{ci},:);
    plot_data_all{ci} = data.wave(grouped_trials_all{ci},:);
    trial_data_all{ci} = data.trialinfo(grouped_trials_all{ci},:);
    
    nstim(ci) = round(nanmedian(trial_data{ci}.nstim));
    RTLock{ci}=nan(1,length(grouped_trials{ci}));
    for i = 1:length(grouped_trials{ci})
        RTLock{ci}(i) = trial_data{ci}.allonsets(i,nstim(ci))-trial_data{ci}.allonsets(i,1)+trial_data{ci}.RT(i);
        postRTinds = find(data.time>RTLock{ci}(i));
%         plot_data{ci}(i,postRTinds)=0;
    end
    [~,sortInds] = sort(trial_data{ci}.RT);
    plot_data{ci}=plot_data{ci}(sortInds,:);
    trial_data{ci} = trial_data{ci}(sortInds,:);
    RTLock{ci} = RTLock{ci}(sortInds);
end

% smooth and plot data
figureDim = [0 0 .4 .8];
figure('units', 'normalized', 'outerposition', figureDim)


% hold on
for ci = 1:ncategs
    %     if plot_params.single_trial
    subplot(ncategs,1,ci)
    clims = [-prctile(plot_data{ci}(:),97.5) prctile(plot_data{ci}(:),97.5)];
    if size(plot_data{ci},1)>1
        h = imagesc(data.time,1:size(plot_data{ci},1),plot_data{ci},clims);
        colormap(cmap)
        hold on
        plot(RTLock{ci},1:size(plot_data{ci},1),'k*')
        for i = 1:size(plot_data{ci},1)
            if strcmp(trial_data{ci}.keys(i),'1')
                text(5,i,[trial_data{ci}.wlist{i},' (True)'])
            elseif strcmp(trial_data{ci}.keys(i),'2')
                text(5,i,[trial_data{ci}.wlist{i},' (False)'])
            else
                text(5,i,trial_data{ci}.wlist{i})
            end
        end
        plot([0 0],ylim,'k-','LineWidth',5)
        title(cond_names{ci})
        xlabel(plot_params.xlabel)
        ylabel('RT-sorted trials')
        set(gca,'fontsize',plot_params.textsize)
        
        if size(data.trialinfo.allonsets,2) > 1
            time_events = cumsum(nanmean(diff(data.trialinfo.allonsets(:,1:nstim(ci)),1,2)));
            for i = 1:length(time_events)
                plot([time_events(i) time_events(i)],ylim,'k-','LineWidth',2)
            end
        end
        
        box off
        
        hold on
        colorbar
    else
        h = imagesc(0);
    end
end


set(gcf,'color','w')



