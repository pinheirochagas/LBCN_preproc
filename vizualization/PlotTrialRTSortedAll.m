function PlotTrialRTSortedAll(sbj_name,project_name,block_names,dirs,elecs,freq_band,locktype,column,conds,datatype, plot_params)

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

if isempty(plot_params)
    plot_params = genPlotParams(project_name,'RTLock');
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

dir_out = [dirs.result_root,filesep,project_name,filesep,sbj_name,filesep,'Figures',filesep,datatype,'Data',filesep,freq_band,filesep,locktype,'lock'];

%% loop through electrodes and plot

tag = [locktype,'lock'];
if plot_params.blc
    tag = [tag,'_bl_corr'];
end
concatfield = {'wave'}; % concatenate amplitude across blocks

plottag = '';

% col_tmp = plot_params.col;


% determine folder name for plots by compared conditions
for ei = 1
    el = elecs(ei);
    %     data_all = concatBlocks(sbj_name,block_names,dirs,el,datatype,concatfield,tag);
    data_all = concatBlocks(sbj_name, project_name, block_names,dirs,el,freq_band,datatype,concatfield,tag);
    groupall = false;
    
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

dir_out = [dir_out,filesep,folder_name,filesep,'RTSort'];

if ~exist(dir_out)
    mkdir(dir_out)
end

% Plotting
for ei = 1:length(elecs)
    el = elecs(ei);
    
    %     data_all = concatBlocks(sbj_name,block_names,dirs,el,datatype,concatfield,tag);
    data_all = concatBlocks(sbj_name, project_name, block_names,dirs,el,freq_band,datatype,concatfield,tag);
    if strcmp(plot_params.noise_method,'timepts')
        data_all = removeBadTimepts(data_all,plot_params.noise_fields_timepts);
    end
    if ismember(el,bad_chans)
        tagchan = ' (bad)';
    else
        tagchan = ' (good)';
    end
    
    PlotTrialRTSorted(data_all,column,conds,plot_params);
    
%     if strcmp(plot_params.label,'name')
%         suptitle([data_all.label,tagchan])
%     elseif strcmp(plot_params.label,'number')
%         suptitle(['Elec ',num2str(el),tagchan])
%     else
%     end
%     fn_out = sprintf('%s/%s_%s_%s_%s_%slock_%s%s.png',dir_out,sbj_name,data_all.label,project_name,freq_band,locktype,folder_name,plottag);
%     savePNG(gcf, 100, fn_out)
%     fn_out = sprintf('%s/%s_%s_%s_%s_%slock_%s%s.pdf',dir_out,sbj_name,data_all.label,project_name,freq_band,locktype,folder_name,plottag);
%     save2pdf(fn_out, gcf, 100)

if plot_params.save == true
    if isempty(plot_params.save_dir)
        %                 dir_out = '/Volumes/LBCN8T/Stanford/data/Results/Logo/S14_73_AY/Figures/BandData/HFB/stimlock/logo';
        %                 folder_name = 'logo';
        fn_out = sprintf('%s/ERP_%s_%s_%s_%s_%slock_%s%s.png',dir_out,sbj_name,data_all.label,project_name,freq_band,locktype,folder_name,plottag);
        savePNG(gcf, 300, fn_out)
        colorbar('off')
        cdata = getframe(gcf);
        F(ei).cdata = cdata.cdata;
        F(ei).colormap = [];
        close
    else
        %                 fn_out = sprintf('%s/%s_%s_%s_%s_%slock_%s%s.png',plot_params.save_dir,sbj_name,data_all.label,project_name,freq_band,locktype,folder_name,plottag);
        fn_out = sprintf('%s%s_%02d_%s_%s_%slock_ERP.png',plot_params.save_dir,sbj_name,el,project_name,freq_band,locktype);
        savePNG(gcf, 300, fn_out)
        close
    end
end


end
% 


% 
% 
% fig = figure('units', 'normalized', 'outerposition', [0 0 .4 1]);
% movie(fig,F,1)
% fn_out = sprintf('%s/%s_%s_%s_%s_%slock_%s%s_video.png',dir_out,sbj_name,data_all.label,project_name,freq_band,locktype,folder_name,plottag);
% videoRSA = VideoWriter(fn_out);
% videoRSA.FrameRate = 30;  % Default 30
% videoRSA.Quality = 100;    % Default 75
% open(videoRSA);
% writeVideo(videoRSA, [F,F,F,F,F,F,F,F,F,F,F]);
% close(videoRSA);


end

