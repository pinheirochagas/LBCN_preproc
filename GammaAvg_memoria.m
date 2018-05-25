clc; clear;
warning('off','all')
close all;
chunkInfo= [];
%% SCRIPT PARAMETERS
sbj_name= 'S18_124';
project_name= 'Calculia_production';
elecs='all';            % which electrodes to plot; 'all' if all elecs
% elecs = 35;

suffix = 'AddSub'; %'MathMem','MathNumNumword','AutoGenSpec'

plot_channame = 1;      % set plot title to channel name
plot_col = 1;           % 1 to plot color, 0 for black/white
linewid = 4;            % line width
scale = 1;              % 0 to set manually (limits below); 1 to scale automatically
plot_eb = 1;            % 1 to plot shaded errorbars
plot_legend = 1;

% 1 to plot legend

switch suffix
    case 'AddSub'
        categ_plot = {{'add'},{'sub'}};
        legend_text = {'add','sub'};
        colors_rgb = [40 40 234; 190 0 22; 0 173 64]/255;
    case 'MathMemRest'
        categ_plot = {{'Autobio'},{{'MathNumber'},{'MathNumberWord'}},{'Rest'}};
        legend_text = {'Autobio','Math','Rest'};
        colors_rgb = [40 40 234; 190 0 22; 0 173 64]/255;
    case 'MathNumNumword'
        categ_plot = {{'MathNumber'},{'MathNumberWord'}};
        legend_text = {'Math- number','Math- number word'};
        colors_rgb = [190 0 22; 255 102 102]/255;
    case 'AutoGenSpec'
        categ_plot = {{'AutoGenVerb'},{'AutoSpecVerb'}};
        legend_text = {'Autobio- Gen verb', 'Autobio- Spec verb'};
        colors_rgb = [52 160 234; 0 0 170]/255;
end
% categ_plot = {{'AutoRecent'},{'AutoDist'}};
% categ_plot ={{'Math_speak'},{'Math_imagine'}};
% legend_text = {'Math-speak','Math-imagine'};


% legend_text = {'Autobio- recent past', 'Autobio- distant past'};
% 
% if (plot_col)
% %     colors_rgb = [40 40 234; 190 0 22; 0 173 64]/255;
%    
% 
% else
%     colors_rgb = [0.2 0.2 0.2; 0.7 0.7 0.7];
% end

% plotting axis limits
ymin = -0.5; % 0.5;
ymax = 2;
xmin = -0.5; % -0.2s must be > - 1
xmax = 6; % 1s must be less than 3

max_bad_timepts = 1;
noise_sd = 3;
noise_sd_max = 3;

winSize_s = 0.1; %smoothing window
bandnum = 1;
w = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Making data directory
task = project_name;
BN = block_by_subj(sbj_name,task);

initialize_dirs;
results_root = sprintf('%s/Results/%s/%s',comp_root,task,sbj_name);
result_folder = 'allblocks';
plot_folder = ['gamma_fig_',suffix];
ver = sprintf('v%s',num2str(bandnum));

load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',data_root,sbj_name,task,sbj_name,BN{1}));

fs_comp = globalVar.fs_comp;

winSize = floor(fs_comp*winSize_s);
gusWin= gausswin(winSize)/sum(gausswin(winSize));
bsl_beg_s = -0.200/fs_comp;
bsl_end_s = 0/fs_comp;
bef_point_baseline = floor(-bsl_beg_s*fs_comp);
aft_point_baseline = floor(bsl_end_s*fs_comp);
Npoints_baseline = bef_point_baseline+aft_point_baseline+1;

win_array = {'stim' 'resp'};
bef_array = [1 xmax];
aft_array = [xmax 1];
bef_win = bef_array(w);
aft_win = aft_array(w);
bef_point= floor(bef_win * fs_comp);
aft_point= ceil(aft_win * fs_comp);
Npoints= bef_point + aft_point+1; %reading Npoints data point
time= linspace(-bef_win,aft_win,Npoints);

%%

globalVar.result_dir=results_root;
% results_dir = sprintf('%s/%s/%s',results_root,task,sbj_name);

if ~exist(sprintf('%s/%s',results_root,'FreqDecompose'))
    mkdir((sprintf('%s',results_root)),'FreqDecompose');
end
if ~exist(sprintf('%s/%s/%s',results_root,'FreqDecompose',ver))
    mkdir((sprintf('%s/%s',results_root,'FreqDecompose')),ver);
end
if ~exist(sprintf('%s/%s/%s/%s',results_root,'FreqDecompose',ver,plot_folder))
    mkdir((sprintf('%s/%s/%s',results_root,'FreqDecompose',ver)),plot_folder);
end

%%
if isstr(elecs) == 1 && strcmp(elecs,'all')
    elecs = setxor([1:globalVar.nchan],[globalVar.refChan]);%
end

load(sprintf('%s/%s/events_%s.mat',globalVar.result_dir,BN{1},BN{1}));
categ_array = {events.categories(:).name};

allonsets = [];

for ci = 1:length(categ_array)
    if (~isfield(events.categories(ci),'allonset'))
        events.categories(ci).allonset = events.categories(ci).start;
    end
    allonsets = [allonsets; events.categories(ci).allonset];
end
ISI = nanmean(allonsets(:,2)-allonsets(:,1));


%% calculate gamma trace and plot
for e = 1:length(elecs)
% for e = 44:84
    ei = elecs(e);
    mn_tmp = cell(1,length(BN));
    elname = ['0',num2str(ei)];
    if (ei<10)
        elname = ['0',num2str(ei)];
    else
        elname = num2str(ei);
    end;
 
    for bi = 1:length(BN)
        block_name = BN{bi};
        load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',data_root,sbj_name,task,sbj_name,block_name));
        load(sprintf('%s/events_%s.mat',globalVar.result_dir,block_name));
        
        event_time_baseline = [];
        for ci = 1:length(events.categories)
            bad_trials = find(globalVar.bad_epochs(ei).categories(ci).numBadTimepts>max_bad_timepts);
            good_trials = setdiff(1:events.categories(ci).numEvents,bad_trials);
            temp = events.categories(ci).start(good_trials);
            event_time_baseline = [event_time_baseline temp(:)'];
        end
        event_point_baseline = floor(event_time_baseline * fs_comp);
        
        load(sprintf('%s/Normband_%s_%.3d',globalVar.Spec_dir,block_name,ei));
        if (plot_channame)
            load(sprintf('%s/iEEG%s_%.2d.mat',globalVar.data_dir,block_name,ei),'channame');
        end
        
        amplitude= band.amplitude;
        power_tmp= double(amplitude(bandnum,:).^2); % Signal Power
        power_tmp = convn(power_tmp,gusWin','same');
        clear amplitude
        
        mn_tmp_baseline = NaN*ones(length(event_point_baseline),Npoints_baseline);
        for eni=1:length(event_point_baseline)
            if ~isnan(event_point_baseline(eni))
                mn_tmp_baseline(eni,:)= power_tmp(1,event_point_baseline(eni)-bef_point_baseline:event_point_baseline(eni)+aft_point_baseline);
            end
        end
        
        mb200 = nanmean(mn_tmp_baseline(:));
        stdb200 = nanstd(mn_tmp_baseline(:));
        
        power_bc = (power_tmp-mb200)/stdb200; %baseline corrected power
        
        for ci = 1:length(categ_plot)
            categs = categ_plot{ci};
            event_time = [];
%             event_allonsets = [];
            for cii = 1:length(categs)
                cind = find(strcmp(categ_array,categs{cii}));
                %                 bad_trials = find(
                bad_trials = find(globalVar.bad_epochs(ei).categories(cind).numBadTimepts>max_bad_timepts);
                %                 bad_trials = globalVar.bad_epochs(ei).categories(ci).badTrials;
                good_trials = setdiff(1:events.categories(cind).numEvents,bad_trials);
%                 event_time = [event_time events.categories(cind).start(good_trials,1)'];
                event_time = [event_time events.categories(cind).start(good_trials)'];
%                 event_allonsets = [event_allonsets; events.categories(cind).start(good_trials,:)];
            end
            
            event_dur = xmax;
            
            event_point= floor(event_time* fs_comp);
            
            id= event_point - bef_point;
            event_point(id<0)=[];
            jd= (event_point + bef_point);
            event_point(jd>globalVar.chanLength)=[];
            
            mn_tmp{bi}.(['c',num2str(ci)])= NaN*ones(length(event_point),Npoints);
            for eni=1:length(event_point)
                if ~isnan(event_point(eni))
                    mn_tmp{bi}.(['c',num2str(ci)])(eni,:)= power_bc(1,event_point(eni)-bef_point:event_point(eni)+aft_point);
                end
            end
        end
    end
    
    mn_tmp2 = mn_tmp;
    clear mn_tmp
    
    for ci = 1:length(categ_plot)
        mn_tmp.(['c',num2str(ci)]) = [];
    end

    for bi = 1:length(BN)
        for ci = 1:length(categ_plot)
            mn_tmp.(['c',num2str(ci)]) = vertcat(mn_tmp.(['c',num2str(ci)]),mn_tmp2{bi}.(['c',num2str(ci)]));
        end
    end
    
    %% detect bad epochs
    
    for ci = 1:length(categ_plot)
        mean_power_trial = nanmean(mn_tmp.(['c',num2str(ci)]),2);
        std_power_trial = nanstd(mn_tmp.(['c',num2str(ci)]),[],2);
        max_power_trial = nanmax(mn_tmp.(['c',num2str(ci)]),[],2);
        mean_all = nanmean(mean_power_trial);
        std_all = nanstd(mean_power_trial);
        mean_std_all = nanmean(std_power_trial);
        std_std_all = nanstd(std_power_trial);
        bad_mean = find((mean_power_trial > mean_all + noise_sd*std_all));
        bad_var = find((std_power_trial > mean_std_all + noise_sd*std_std_all) | (std_power_trial < mean_std_all - noise_sd*std_std_all));
        bad_max = find(max_power_trial > mean_all + noise_sd_max*std_all);
        bad_trials = union(bad_mean,bad_var);
        mn_tmp.(['c',num2str(ci)])(bad_trials,:) = NaN;
    end
    
    
    for ci = 1:length(categ_plot)
        if ~isempty(mn_tmp.(['c',num2str(ci)]))
            numtrials.(['c',num2str(ci)]) = sum(~isnan(mn_tmp.(['c',num2str(ci)])(:,1)));
        else
            numtrials.(['c',num2str(ci)]) = 0;
        end
        mn.(['c',num2str(ci)]) = nanmean(mn_tmp.(['c',num2str(ci)]),1);
        sd.(['c',num2str(ci)]) = nanstd(mn_tmp.(['c',num2str(ci)]),[],1);
    end
    
    %% plotting
    
    line_order = {'--','-'}; %for passive vs active
    
    figure('Position',[400 400 600 400])
    ind = 0;
    max_plot = 1;
    min_plot = -1;
    if (plot_legend)
        for ci= 1:length(categ_plot)
            if (length(mn.(['c',num2str(ci)]))>1)
                h(ci) = plot(time,mn.(['c',num2str(ci)]),'LineWidth',linewid,'Color',colors_rgb(ci,:));
                hold on
            end
        end
        leg = legend(h,legend_text,'Location','NorthWest');
    end
    for ci = 1:length(categ_plot)
        ind = ind+1;
        lineprops.col{1} = colors_rgb(ci,:);
        lineprops.style= '-';
        lineprops.width = 3;
        lineprops.edgestyle = '-';
        if (length(mn.(['c',num2str(ci)]))>1)
            if plot_eb
                mseb(time,mn.(['c',num2str(ci)]),sd.(['c',num2str(ci)])/sqrt(numtrials.(['c',num2str(ci)])),lineprops,1);
                hold on
            end
            plot(time,mn.(['c',num2str(ci)]),'LineWidth',linewid,'Color',colors_rgb(ci,:))
        end
        max_plot = max(max_plot,nanmax(mn.(['c',num2str(ci)])));
        min_plot = min(min_plot,nanmin(mn.(['c',num2str(ci)])));
        hold on
    end
    hold on
   
    hold on
    xlim([xmin xmax])
    if (scale)
        ylim([floor(min_plot),ceil(max_plot)])
    else
        ylim([ymin ymax])
    end
    line([0 0],ylim, 'Color','k','LineWidth',3)                %1st stim
    line([ISI ISI],ylim, 'Color','k','LineWidth',2)            %2nd stim
    line([2*ISI 2*ISI],ylim, 'Color','k','LineWidth',2)        %3rd stim

    line([xmin xmax],[0 0], 'Color','k','LineWidth',3)
    set(gcf,'color','w')
    if (plot_legend)
        set(gca,'fontsize',30)
        set(leg,'fontsize',20)
        legend boxoff
    else
        set(gca,'fontsize',50)
    end
    
    if (plot_channame)
        title(channame,'fontsize',50)
    end
    
    box off
    
    
    %% saving
%     fp= sprintf('%s/%s/%s/%s/%s_Ch%.3d_%s_%s_%s.png',results_root,'FreqDecompose',ver,plot_folder,sbj_name,ei,channame,project_name,suffix);
    fp= sprintf('%s/%s/%s/%s/%s_%s_%s_%s.png',results_root,'FreqDecompose',ver,plot_folder,sbj_name,channame,project_name,suffix);
%     fp= sprintf('%s/%s/%s/%s/%s_%s_gamma_elec%.2d_bandnum%s.png',results_root,'FreqDecompose',ver,plot_folder,sbj_name,project_name,ei,ver);
    saveas(gcf,fp)
    if length(elecs)>1
        close all
    end
end


