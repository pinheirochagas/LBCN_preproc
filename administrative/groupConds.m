function [grouped_trials,grouped_condnames] = groupConds(conds,trialinfo,column,noise_method,groupall)

%% INPUTS:
%   conds: cell of conditions (can be cell of cells if grouping conditions
%          together)
%   trialinfo:   trialinfo table (field of data)
%   groupall:    true or false (if true, will group all of the conditions in
%           conds together; useful for plotting multiple elecs on same
%           plot)
%% OUTPUTS:
%   grouped_trials: cell containing trial indeces (in trialinfo) corresponding to each
%                   cond (or group of conds)
%   grouped_condnames:  condition names (will concatenate cond names if
%                       grouping multiple conds together)

if (groupall)
    nconds = 1;
else
    nconds = length(conds);
end
grouped_trials = cell(1,nconds);
for ci = 1:nconds
    trials1 = find(~cellfun(@isempty,trialinfo.(column)));
    if groupall
        trials2 = find(ismember(trialinfo.(column)(trials1),conds));
    else
        trials2 = find(ismember(trialinfo.(column)(trials1),conds{ci}));
    end
    if strcmp(noise_method, 'trials')
        trials2 = intersect(trials2,find(trialinfo.bad_epochs(trials1) == false));
    end
    grouped_trials{ci} = trials1(trials2);
end
grouped_condnames = groupCondNames(conds,groupall);