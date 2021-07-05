function [dep, pred] = getDepPred(data, datatype, el, dep, pred, conds, mod_par)

dep_pred = {dep,pred};
data_win = min(find(data.time>mod_par.task_win(1))):max(find(data.time<mod_par.task_win(2)));
trial_idx = find(strcmp(data.trialinfo.(mod_par.column), conds) & data.trialinfo.bad_epochs_HFO == 0 & data.trialinfo.spike_hfb == 0);

for i = 1:length(dep_pred)
    dep_pred_tmp = dep_pred{i};
    
    switch dep_pred_tmp
        case 'RT'
            dep_pred_tmp_final{i} = data.trialinfo.RT(trial_idx);
            
        case 'OperandMin'
            dep_pred_tmp_final{i} = data.trialinfo.OperandMin(trial_idx);
            
        case 'decadeCross'
            dep_pred_tmp_final{i} = data.trialinfo.decadeCross(trial_idx);
            
        case 'correctness'
            dep_pred_tmp_final{i} = data.trialinfo.correctness(trial_idx);
            
        case 'AbsDeviant'
            dep_pred_tmp_final{i} = data.trialinfo.AbsDeviant(trial_idx);            
            
        case 'initial'
            % Average across conds
            data_field = 'wave';
            if strcmp(datatype, 'Band')
                dep_pred_tmp_final{i} = nanmean(data.(data_field)(trial_idx,el,data_win),3); % average time win by electrode
            else strcmp(datatype, 'Spec')
%                 dep_pred_tmp_final{i} = nanmedian(data_sbj.(data_field)(trial_idx,:,:,:),4); % average time win by electrode
            end
            
        case 'total'
            data_field = 'wave';
            for ii = 1:length(trial_idx)
                if strcmp(pred, 'correctness') || strcmp(pred, 'AbsDeviant') || strcmp(pred, 'format') || strcmp(pred, 'sl_ls') 
                    tmp = squeeze(data.(data_field)(trial_idx(ii),el,data_win(1):data_win(2)));
                else
                    tmp = squeeze(data.(data_field)(trial_idx(ii),el,data_win(1):max(find(data.time <= data.trialinfo.RT(trial_idx(ii))))));
                end
                tmp = tmp+abs(min(tmp));
                dep_pred_tmp_final{i}(ii,1) = trapz(tmp); 
                % Should I only take the positive values? 
                %  dep_pred_tmp_final{i}(ii) = trapz(tmp(tmp>0)); 
            end
    end
    
end
    % Define dep and pred
    dep = dep_pred_tmp_final{1};
    pred = dep_pred_tmp_final{2};    
    
end

