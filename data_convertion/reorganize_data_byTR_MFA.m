function reorganize_data_byTR_MFA(subjectname)

%% Specify subject and directories
% Subject, task and blocks
project_name= 'MFA';
task = get_project_name(subjectname,project_name);
BN = block_by_subj(subjectname,task);
% Directories
initialize_dirs
behdir = [results_root project_name '/' subjectname '/'];

for blockN = 1:length(BN)
    % Load behavioral data
    load([behdir BN{blockN} '/events_', BN{blockN} '.mat']);
    stim_key = readtable([results_root 'MFA/MFA_stimlist_key.csv']);
    % Ignore category 6, spanish add, cause there is no stim
    % Break the 'categories' structure
    trialno = horzcat(events.categories.stimNum)';
    allonsets = horzcat(events.categories.start)';
    wlist = horzcat(events.categories.wlist)';
    RT =  horzcat(events.categories.RT)';
    % Plug key
    [~,idx] = ismember(wlist,stim_key.filename); 
    % Correct for the the subjects in which the filename for text is
    % different
    if sum(idx == 0) > 0 
        [~,idx] = ismember(wlist,stim_key.filename2); 
    end

    % Accuracy
    sub_resp = horzcat(events.categories.sbj_resp)';
    stim_key.correct(stim_key.correct==0) = 2;
    correct = stim_key.correct(idx);
    accuracy = correct == sub_resp;
    Operand1 = stim_key.operand1(idx);
    Operand2 = stim_key.operand2(idx);
    Operator = stim_key.operator(idx);
    PresResult = stim_key.PresResult(idx);
    CorrResult = stim_key.CorrectResult(idx);
    Deviant = stim_key.Deviant(idx);
    AbsDeviant = stim_key.AbsDeviant(idx);
    Category = stim_key.type(idx);
   
    for i = 1:length(wlist)
        events_byTrial(i).block = BN{blockN};
        events_byTrial(i).task = task;
        events_byTrial(i).trialno = trialno(i);
        events_byTrial(i).wlist = wlist(i);
        events_byTrial(i).allonsets = allonsets(i,:);
        events_byTrial(i).RT = RT(i);
        events_byTrial(i).accuracy = accuracy(i);
        events_byTrial(i).Operand1 = Operand1(i);
        events_byTrial(i).Operand2 = Operand2(i);
        events_byTrial(i).OperandMin = min(Operand1(i), Operand2(i));
        events_byTrial(i).OperandMax = max(Operand1(i), Operand2(i));
        events_byTrial(i).Operator = Operator(i);
        events_byTrial(i).PresResult = PresResult(i);
        events_byTrial(i).CorrResult = CorrResult(i);
        events_byTrial(i).Deviant = Deviant(i);
        events_byTrial(i).AbsDeviant = AbsDeviant(i);
        events_byTrial(i).Category = Category(i);
    end
    
    %Check if there are nans in the onsets and update events
    onsetNaN = ~isnan(vertcat(events_byTrial.allonsets));
    events_byTrial = events_byTrial(onsetNaN);
        
    % Save
    save([behdir BN{blockN} '/events_byTrial_', BN{blockN} '.mat'], 'events', 'events_byTrial');
    'saved'
end

end

