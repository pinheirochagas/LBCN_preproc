function mod_par = genModulationParams(project_name, hypothesis)

%% INPUTS:
%   project_name: task name
[column,conds] = getCondNames(project_name, hypothesis);

switch project_name
    case {'MMR', 'UCLA'}
        mod_par.task_win = [0 1];
        mod_par.bl_win = [-0.2 0];
        
        mod_par.tag = 'stim';
        
        switch hypothesis
            case 'cross_decade_mod'
                mod_par.conds = conds;
                mod_par.column = column;
                mod_par.preds.(conds{find(strcmp(conds, 'math'))}) = {'decadeCross', 'decadeCross'};
                mod_par.dep_vars.(conds{find(strcmp(conds, 'math'))}) = {'initial', 'total'};
            case 'min_operand_mod'
                mod_par.conds = conds;
                mod_par.column = column;
                mod_par.preds.(conds{find(strcmp(conds, 'math'))}) = {'OperandMin', 'OperandMin'};
                mod_par.dep_vars.(conds{find(strcmp(conds, 'math'))}) = {'initial', 'total'};

                
            case 'min_operand_old'
                mod_par.conds = conds;
                mod_par.column = column;
                mod_par.preds.(conds{find(strcmp(conds, 'math'))}) = {'OperandMin', 'OperandMin', 'initial', 'total'};
                mod_par.dep_vars.(conds{find(strcmp(conds, 'math'))}) = {'initial', 'total', 'RT', 'RT'};
                
   
                
        end
    case 'Memoria'
        mod_par.task_win = [0 1.5];
        mod_par.bl_win = [-0.5 0];
        
        mod_par.tag = 'stim';
        switch hypothesis
            
            
            case 'correctness_mod'
                mod_par.task_win = [4.3 5.5];
                mod_par.conds = conds;
                mod_par.column = column;
                mod_par.preds.(conds{find(strcmp(conds, 'math'))}) = {'correctness'};
                mod_par.dep_vars.(conds{find(strcmp(conds, 'math'))}) = {'total'};
                
            case 'abs_deviant_mod'
                mod_par.task_win = [4.3 5.5];
                mod_par.conds = conds;
                mod_par.column = column;
                mod_par.preds.(conds{find(strcmp(conds, 'math'))}) = {'AbsDeviant'};
                mod_par.dep_vars.(conds{find(strcmp(conds, 'math'))}) = {'total'};
                
            case 'sl_ls_mod'
                mod_par.task_win = [2.1 4.3];
                mod_par.conds = conds;
                mod_par.column = column;
                mod_par.preds.(conds{find(strcmp(conds, 'math'))}) = {'ls_sl'};
                mod_par.dep_vars.(conds{find(strcmp(conds, 'math'))}) = {'total'};
                
            case 'operand_2_mod'
                mod_par.task_win = [2.1 4.3];
                mod_par.conds = conds;
                mod_par.column = column;
                mod_par.preds.(conds{find(strcmp(conds, 'math'))}) = {'Operand2'};
                mod_par.dep_vars.(conds{find(strcmp(conds, 'math'))}) = {'total'};
                
            case 'format_mod'
                mod_par.task_win = [2.1 4.3];
                mod_par.conds = conds;
                mod_par.column = column;
                mod_par.preds.(conds{find(strcmp(conds, 'math'))}) = {'mathtype'};
                mod_par.dep_vars.(conds{find(strcmp(conds, 'math'))}) = {'total'};
                
                
                
                
                
            case 'GradCPT'
                mod_par.task_win = [0 0.8];
                mod_par.bl_win = [-0.2 0];
        end
end

mod_par.nreps= 5000;
mod_par.freq_range = [70 180];
mod_par.paired = false;
mod_par.noise_method = 'trials';
mod_par.noise_fields_trials= {'bad_epochs_HFO','bad_epochs_raw_HFspike'}; % can combine any of the bad_epoch fields in data.trialinfo (will take union of selected fields)
mod_par.noise_fields_timepts= {'bad_inds_HFO','bad_inds_raw_HFspike'}; % can combine any of the bad_epoch fields in data.trialinfo (will take union of selected fields)
mod_par.alpha = 0.05;

mod_par.blc=1;
mod_par.smooth=1;
mod_par.fwer=0.05;
mod_par.tail=0;
mod_par.sm=0.1;
mod_par.twin=[-0.5 7];
mod_par.mincluster = 0.02;   %% define the minimum cluster threshold.
mod_par.isplot=1;




