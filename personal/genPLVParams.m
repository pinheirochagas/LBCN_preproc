function plv_params = genPLVParams(project_name)

switch project_name
    case 'GradCPT'
        plv_params.t_win = [0 0.8]; %time window in each trial during which to compute PLV
end

plv_params.freq_range = [0 32]; 
plv_params.blc = false;