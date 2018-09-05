function plot_params = genPlotParams(task,plottype)

%% INPUTS:
%   task: task name
%   plottype: 'timecourse'(e.g. for HFB),'ERSP' (for spectrogram), 
%             or 'ITC' (for inter-trial phase coherence)
%% OUTPUTS:
%   plot_params     .single_trial: true (plot indiv. trials) or false (plot avg. across trials)
%                   .eb: error-bar type ('ste' for standard error of mean, or 'std' for standard dev.)
%                   .multielec: true or false (whether to plot multiple elecs on same figure)
%                   .blc: true or false (whether to load bl-corrected data or not)
%                   .run_blc: true or false (whether to run baseline
%                           correction before plotting, i.e. if data not already
%                           baseline corrected)
load cdcol.mat

switch plottype
    case 'timecourse'
        plot_params.legend = true;
        plot_params.single_trial = false;
        plot_params.eb = 'ste';
        plot_params.xlabel = 'Time (s)';
        plot_params.ylabel = 'z-scored power';
        plot_params.textsize = 20;
        plot_params.freq_range = [70 180];
        plot_params.plot_metric = 'z';
        plot_params.multielec = false;
        plot_params.col = [cdcol.ultramarine;
            cdcol.carmine;
            cdcol.grassgreen;
            cdcol.lilac;
            cdcol.yellow;
            cdcol.turquoiseblue;
            cdcol.flamered;
            cdcol.periwinkleblue;
            cdcol.yellowgeen
            cdcol.purple];
    case 'ERSP'
        plot_params.legend = 'false';
        plot_params.textsize = 14;
        plot_params.xlabel = 'Time (s)';
        plot_params.ylabel = 'Freq (Hz)';
        plot_params.cmap = cbrewer2('RdBu');
        plot_params.cmap = plot_params.cmap(end:-1:1,:);
        plot_params.clim = [-2 2];
    case 'ITC'
        plot_params.textsize = 16;
        plot_params.xlabel = 'Time (s)';
        plot_params.ylabel = 'Freq (Hz)';
        plot_params.cmap = cbrewer2('RdYlBu');
        plot_params.cmap = plot_params.cmap(end:-1:1,:);
        plot_params.clim = [0 0.4];
        plot_params.freq_range = [0 32];
    case 'RTCorr'
        plot_params.textsize = 20;
        plot_params.xlabel = 'Time (s)';
        plot_params.ylabel = 'Freq (Hz)';
        plot_params.cmap = cbrewer2('RdYlBu');
        plot_params.cmap = plot_params.cmap(end:-1:1,:);
        plot_params.clim = [0 0.3];
        plot_params.freq_range = [0 32];
        plot_params.norm = true;
end

switch task
    case 'MMR'
        plot_params.xlim = [-0.2 3];
        plot_params.blc = true;
        plot_params.bl_win = [-0.2 0];      
    case 'Memoria'
        plot_params.xlim = [-0.5 6];
        plot_params.blc = true;
        plot_params.bl_win = [-0.5 0];
    case 'GradCPT'
        plot_params.xlim = [-0.5 1.6];
        plot_params.blc = false;
end
    
plot_params.lw = 3;
plot_params.label = 'name';
plot_params.sm = 0.1;
% plot_params.run_blc = true;


