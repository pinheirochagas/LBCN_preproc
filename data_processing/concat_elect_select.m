function elect_select_all = concat_elect_select(subjects, task, dirs, vars)

elect_select_all = table;
for is = 1:length(subjects)
    s = subjects{is};
    fname = sprintf('%sel_selectivity/el_selectivity_%s_%s.mat',dirs.result_dir, s, task);
    load(fname)

    if sum(strcmp(el_selectivity.Properties.VariableNames, 'DK_long_josef')) == 0
        el_selectivity.DK_long_josef = repmat({'not done'},size(el_selectivity,1),1,1);
    else
    end
    el_selectivity_tmp = el_selectivity(:, contains(el_selectivity.Properties.VariableNames, vars));   
    el_selectivity_tmp.sbj_name = repmat({s},size(el_selectivity_tmp,1),1);
    %% Add HFO info
    
%     el_selectivity = get_HFO_electrodes(dirs, el_selectivity_tmp, s, task)    
    
    elect_select_all = [elect_select_all; el_selectivity_tmp];   

    
end

if sum(contains(vars, 'DK_lobe')) > 0
    elect_select_all.DK_lobe_generic = DK_lobe_generic(elect_select_all);
else
end


end



