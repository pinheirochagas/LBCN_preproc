function modulation_params = genModulationParams(project_name)

%% INPUTS:
%   project_name: task name

switch project_name
    case 'MMR'
        modulation_params.task_win = [0 1];
        modulation_params.bl_win = [-0.2 0];
    case 'Memoria'
        modulation_params.task_win = [0 1.5];
        modulation_params.bl_win = [-0.5 0];
    case 'GradCPT'
        modulation_params.task_win = [0 0.8];
        modulation_params.bl_win = [-0.2 0];
end

modulation_params.nreps= 5000;
modulation_params.freq_range = [70 180];
modulation_params.paired = false;
modulation_params.noise_method = 'trials';
modulation_params.noise_fields_trials= {'bad_epochs_HFO','bad_epochs_raw_HFspike'}; % can combine any of the bad_epoch fields in data.trialinfo (will take union of selected fields)
modulation_params.noise_fields_timepts= {'bad_inds_HFO','bad_inds_raw_HFspike'}; % can combine any of the bad_epoch fields in data.trialinfo (will take union of selected fields)
modulation_params.alpha = 0.05;

modulation_params.blc=1;
modulation_params.smooth=1;
modulation_params.fwer=0.05;
modulation_params.tail=0;
modulation_params.sm=0.1;
modulation_params.twin=[-0.5 7];
modulation_params.mincluster = 0.02;   %% define the minimum cluster threshold.
modulation_params.isplot=1;


