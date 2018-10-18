function reorganize_data_byTR_context(subjectname)
% calculiaVersion = 1 for old calculia
% calculiaVersion = 2 for new MEG calculia

%% Specify subject and directories
% Subject, task and blocks
%subjectname='S13_57_TVD';
project_name= 'calculia';
task = get_project_name(subjectname,project_name);
BN = block_by_subj(subjectname,task);
% Select the active blocks (find a way to automatize it)
% BN = BN(5:8);
% Directories
initialize_dirs
behdir = [results_root project_name '/' subjectname '/'];
stimdir = [psych_root '/' subjectname '/'];

% Define trials parameters
% trialnoDelay = 5*500 + 4*400
% trialnoDelay =

for blockN = 1:length(BN)
    % Load behavioral data
    load([behdir BN{blockN} '/events_', BN{blockN} '.mat']);
    psychdata = load([stimdir BN{blockN} '/TVD_dv3_' num2str(str2num(BN{blockN}(end))-1) '_all.mat']);
    
    % Allonsets
    allonsets = vertcat(events.categories.start);
    allonsets = sortrows(allonsets);
    
    % Extract trial info from wlist
    wlist = vertcat(psychdata.trials.problem);
    for l = 1:size(wlist,1)
        wlistModtmp = wlist(l,:);
        for c = 1:size(wlist,2)
            [C,matches] = strsplit(wlistModtmp{c},{'_'},'CollapseDelimiters',true);
            if ismember('N', C{1}) && ~isempty(words2num(C{2}))
                wlistMod(l,c) = cellstr(num2str(words2num(C{2})));
            elseif ismember('W', C{1}) && ~isempty(words2num(C{2}))
                wlistMod(l,c) = cellstr(C{2});
            elseif ismember('N', C{1}) && strcmp('plus', C{2}) == 1
                wlistMod(l,c) = cellstr('+');
            elseif ismember('N', C{1}) && strcmp('minus', C{2}) == 1
                wlistMod(l,c) = cellstr('-');
            elseif ismember('N', C{1}) && strcmp('is', C{2}) == 1
                wlistMod(l,c) = cellstr('=');
            elseif ismember('W', C{1}) && strcmp('plus', C{2}) == 1
                wlistMod(l,c) = cellstr(C{2});
            elseif ismember('W', C{1}) && strcmp('minus', C{2}) == 1
                wlistMod(l,c) = cellstr(C{2});
            elseif ismember('W', C{1}) && strcmp('is', C{2}) == 1
                wlistMod(l,c) = cellstr(C{2});
            end
        end        
    end
    
    % Concatenate all stim
    for l = 1:size(wlistMod,1)
        wlistModtmp = wlistMod(l,:);
        wlistModFinal{l} = [wlistModtmp{1} wlistModtmp{2} wlistModtmp{3} wlistModtmp{4} wlistModtmp{5}];
    end
    wlist = wlistModFinal'
    

    
    %duration = horzcat(events.categories.stimdur)';
        
    % Check if the trial is delayed
    delay = vertcat(psychdata.trials.delay); % define an object criteria for that
    % Calculate RT
    % RT = duration-(allonsets(:,end) - allonsets(:,1));
    
    for i = 1:size(allonsets,1)
        events_byTrial(i).block = BN{blockN};
        events_byTrial(i).task = task;
%         events_byTrial(i).trialno = trialno(i);
        events_byTrial(i).wlist = wlist(i);
        events_byTrial(i).allonsets = allonsets(i,:);
        %         events_byTrial(i).active = active(i);
        events_byTrial(i).delay = delay(i);
%         events_byTrial(i).RT = RT(i);
    end
    
    % Add calculation info
    for i=1:length(events_byTrial)
        % Calculation info
        [C,matches] = strsplit(events_byTrial(i).wlist{1},{'+','-','=', 'plus', 'minus', 'is'},'CollapseDelimiters',true);
        Operand1str = C{1};
        Operand2str = C{2};
        PresResultstr = C{3};
        Operatorstr = matches{1};
        Equalstr = matches{2};

        if sum(isstrprop(C{1}, 'digit')) > 0;
            Operand1 = str2num(C{1});
        else
            Operand1 = words2num(C{1});
        end
        
        if sum(isstrprop(C{2}, 'digit')) > 0;
            Operand2 = str2num(C{2});
        else
            Operand2 = words2num(C{2});
        end
        
        if sum(isstrprop(C{3}, 'digit')) > 0;
            PresResult = str2num(C{3});
        else
            PresResult = words2num(C{3});
        end
        
        if strcmp('+', matches{1}) == 1 || strcmp('plus', matches{1}) == 1;
            Operator = 1;
        elseif strcmp('-', matches{1}) == 1 || strcmp('minus', matches{1}) == 1;
            Operator = -1;
        else
            Operator = nan;
        end       
        
        CorrectResult = Operand1 + Operand2*Operator;
        Deviant = CorrectResult - PresResult;
        AbsDeviant = abs(Deviant);
        
%         events_byTrial(i).isCalc = isCalc;
        events_byTrial(i).Operand1str = Operand1str;
        events_byTrial(i).Operand2str = Operand2str;
        events_byTrial(i).PresResultstr = PresResultstr;
        events_byTrial(i).Operatorstr = Operatorstr;
        events_byTrial(i).Equalstr = Equalstr;
        events_byTrial(i).Operand1 = Operand1;
        events_byTrial(i).Operand2 = Operand2;
        events_byTrial(i).OperandMin = min(Operand1,Operand2);
        events_byTrial(i).OperandMax = max(Operand1,Operand2);
        events_byTrial(i).Operator = Operator;
        events_byTrial(i).CorrectResult = CorrectResult;
        events_byTrial(i).PresResult = PresResult;
        events_byTrial(i).Deviant = Deviant;
        events_byTrial(i).AbsDeviant = AbsDeviant;
    end
    
    %Save
    save([behdir BN{blockN} '/events_byTrial_', BN{blockN} '.mat'], 'events', 'events_byTrial');
    'saved'
end

end

%% This is probably important for other versions of calculia...


%     %%% Get the index of the correct order of each trial
%     if block < 4
%         task = 1;
%         trialno = horzcat(events.categories.stimNum)';
%         allonsets = vertcat(events.categories.start);
%         wlist = horzcat(events.categories.wlist)';
%         %isDelay = [];
%     else
%         task = 2;
%         trialno = horzcat(events.categories.trialno)';
%         allonsets = vertcat(events.categories.allonsets);
%         wlist = vertcat(events.categories.wlist);
%         %isDelay = []; HOW TO DEAL WITH THE DELAY?
%     end

%Allonsets = allonsets(index,:);
%     onsets = allonsets(:,1);

%Wlist = wlist(index);
%isActive = horzcat(events.categories.active)';
%IsActive = isActive(index);



% Put trials in order and remove repeated trials from blocks 4:5
%     [uniqueTrialNum indexUTN] = unique(trialno);
%     events_byTR = events_byTR(indexUTN);

% Save