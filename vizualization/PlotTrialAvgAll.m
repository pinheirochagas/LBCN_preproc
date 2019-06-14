function PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,elecs,freq_band,locktype,column,conds,plot_params,datatype)

%% INPUTS
%       sbj_name: subject name
%       project_name: name of task
%       block_names: blocks to be analyed (cell of strings)
%       dirs: directories pointing to files of interest (generated by InitializeDirs)
%       elecs: can select subset of electrodes to epoch (default: all)
%              (if specifying elecs, can either be vectors of elec #s or cells of elec names)
%       datatype: 'CAR','HFB',or 'Spec'
%       locktype: 'stim' or 'resp' (which event epoched data is locked to)
%       column: column of data.trialinfo by which to sort trials for plotting
%       conds:  cell containing specific conditions to plot within column (default: all of the conditions within column)
%               can group multiple conds together by having a cell of cells
%               (e.g. conds = {{'math'},{'autobio','self-internal'}})
%       col:    colors to use for plotting each condition (otherwise will
%               generate randomly)
%       plot_params:    controls plot features (see genPlotParams.m script)


sbj_name_tmp = strsplit(sbj_name, '_');
sbj_name_generic = sbj_name(1:end-(length(sbj_name_tmp{end})+1));


if isempty(plot_params)
    plot_params = genPlotParams(project_name,'timecourse');
end

% keep track of bad chans (from any block) for labeling plots
bad_chans = [];
for bi = 1:length(block_names)
    load([dirs.data_root,filesep,'OriginalData',filesep,sbj_name,filesep,'global_',project_name,'_',sbj_name,'_',block_names{bi},'.mat'])
    bad_chans = union(bad_chans,globalVar.badChan);
end

if iscell(elecs)
    elecs = ChanNamesToNums(globalVar,elecs);
end

if isempty(elecs)
    elecs = setdiff(1:globalVar.nchan,globalVar.refChan);
end


if plot_params.multielec
    dir_out = [dirs.result_root,filesep,project_name,filesep,sbj_name,filesep,'Figures',filesep,datatype,'Data',filesep,freq_band,filesep,locktype,'lock',filesep,'multielec'];
else
    dir_out = [dirs.result_root,filesep,project_name,filesep,sbj_name,filesep,'Figures',filesep,datatype,'Data',filesep,freq_band,filesep,locktype,'lock'];
end

%% loop through electrodes and plot

if plot_params.multielec  % if plotting multiple elecs on same fig
    elec_names = cell(1,length(elecs));
    elec_names_all = [];
end

tag = [locktype,'lock'];
if plot_params.blc
    tag = [tag,'_bl_corr'];
end
concatfield = {'wave'}; % concatenate amplitude across blocks

if plot_params.single_trial
    plottag = '_singletrials';
else
    plottag = '';
end

col_tmp = plot_params.col;

% if plotting multiple elecs, adjust y-axis limits based on min and max of
% all elecs
if (plot_params.multielec)
    ymin = 0;
    ymax = 0;
end

% determine folder name for plots by compared conditions
for ei = 1
    el = elecs(ei);
    %     data_all = concatBlocks(sbj_name,block_names,dirs,el,datatype,concatfield,tag);
    data_all = concatBlocks(sbj_name,project_name,block_names,dirs,el,freq_band,datatype,concatfield,tag);
    

    
    if plot_params.multielec
        groupall = true;
    else
        groupall = false;
    end
    
    if isempty(conds)
        tmp = find(~cellfun(@isempty,(data_all.trialinfo.(column))));
        conds = unique(data_all.trialinfo.(column)(tmp));
    end
    cond_names = groupCondNames(conds,groupall);
end

folder_name = cond_names{1};
for gi = 2:length(cond_names)
    folder_name = [folder_name,'_',cond_names{gi}];
end
if plot_params.single_trial
    dir_out = [dir_out,filesep,folder_name,filesep,'singletrials'];
else
    dir_out = [dir_out,filesep,folder_name];
end
if ~exist(dir_out)
    mkdir(dir_out)
end

% Plotting
for ei = 1:length(elecs)
    el = elecs(ei);
    
    %     data_all = concatBlocks(sbj_name,block_names,dirs,el,datatype,concatfield,tag);
    data_all = concatBlocks(sbj_name,project_name, block_names,dirs,el,freq_band,datatype,concatfield,tag);
    
        % correct data.label
    if plot_params.correct_label
        data_all.label = plot_params.FS_labels{el};
    else
    end
    
    if strcmp(plot_params.noise_method,'timepts')
        data_all = removeBadTimepts(data_all,plot_params.noise_fields_timepts);
    end
    if ismember(el,bad_chans)
        tagchan = ' (bad)';
    else
        tagchan = ' (good)';
    end
    
    if plot_params.multielec % if  multiple elecs in same figure (will group all conditions together)
        plot_params.col = col_tmp(ei,:); % plot each elec in diff color
        h(ei) = PlotTrialAvg(data_all,column,conds,plot_params);
        hold on
        ymin(ei) = (min(h(ei).YData) - (std(h(ei).YData)/sqrt(size(h(ei).YData,2)))) / 1.2;
        ymax(ei) = (max(h(ei).YData) + (std(h(ei).YData)/sqrt(size(h(ei).YData,2)))) * 1.2;
        elec_names{ei} = [data_all.label,tagchan];
        elec_names_all = [elec_names_all,'_',data_all.label];
    else
        PlotTrialAvg(data_all,column,conds,plot_params);
        
            
            
        if strcmp(plot_params.label,'name')
            %             suptitle([data_all.label,tagchan, elect_select{ei}])
            suptitle([data_all.label,tagchan])
        elseif strcmp(plot_params.label,'number')
            suptitle(['Elec ',num2str(el),tagchan])
        end
        
        %% Save
        if plot_params.save == true
            if isempty(plot_params.save_dir)
%                 dir_out = '/Volumes/LBCN8T/Stanford/data/Results/Logo/S14_73_AY/Figures/BandData/HFB/stimlock/logo';
%                 folder_name = 'logo';
                fn_out = sprintf('%s/%s_%s_%s_%s_%slock_%s%s.png',dir_out,sbj_name_generic,data_all.label,project_name,freq_band,locktype,folder_name,plottag);
                savePNG(gcf, 300, fn_out)
                fn_out = sprintf('%s/%s_%s_%s_%s_%slock_%s%s.pdf',dir_out,sbj_name_generic,data_all.label,project_name,freq_band,locktype,folder_name,plottag);
%                 save2pdf(fn_out, gcf, 300)
                close
            else
                fn_out = sprintf('%s/%s_%s_%s_%s_%slock_%s%s.png',plot_params.save_dir,sbj_name_generic,data_all.label,project_name,freq_band,locktype,folder_name,plottag);
                savePNG(gcf, 300, fn_out)
            end
        end
%         close
    end

end

% Continued to increment to the hold on multiple elecs
if plot_params.multielec  % if plotting multiple elecs, create legend based on elec #
    ylim([min(ymin) max(ymax)])
    plot([0 0],ylim,'Color', [0 0 0], 'LineWidth',2)
    leg = legend(h,elec_names);
    legend boxoff
    set(leg,'fontsize',14);
    title_conds = conds{1};
    for ci = 2:length(conds)
        title_conds = [title_conds,'+',conds{ci}];
    end
    title(title_conds)
    
    if plot_params.save == true
        if isempty(plot_params.save_dir)
            fn_out = sprintf('%s/%s_%s_%s_%s_%s_%slock.png',dir_out,sbj_name_generic,elec_names_all,title_conds,project_name,freq_band,locktype);
            savePNG(gcf, 300, fn_out)
%             save2pdf(fn_out, gcf, 300)
        else
            fn_out = sprintf('%s/%s_%s_%s_%s_%s_%slock.png',plot_params.save_dir,sbj_name_generic,elec_names_all,title_conds,project_name,freq_band,locktype);
            savePNG(gcf, 300, fn_out)
        end
    end
    
    %     close
end
