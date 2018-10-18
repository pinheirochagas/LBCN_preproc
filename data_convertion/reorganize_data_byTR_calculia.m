function reorganize_data_byTR_calculia(subjectname, calculiaVersion)
% calculiaVersion = 1 for old calculia
% calculiaVersion = 2 for new MEG calculia

%% Specify subject and directories
% Subject, task and blocks
%subjectname='S14_80_KB';
project_name= 'calculia';
task = get_project_name(subjectname,project_name);
BN = block_by_subj(subjectname,task);
% Select the active blocks (find a way to automatize it)
% BN = BN(5:8);
% Directories
initialize_dirs
behdir = [results_root project_name '/' subjectname '/'];

% Define trials parameters
% trialnoDelay = 5*500 + 4*400
% trialnoDelay =

for blockN = 1:length(BN)
    % Load behavioral data
    load([behdir BN{blockN} '/events_', BN{blockN} '.mat']);
    
    % Break the 'categories' structure
    if calculiaVersion == 1
       trialno = horzcat(events.categories.stimNum)';
       allonsets = vertcat(events.categories.start);
       wlist = horzcat(events.categories.wlist)';
       duration = horzcat(events.categories.duration)';      
    elseif calculiaVersion == 2
       trialno = vertcat(events.categories.trialno);
       allonsets = vertcat(events.categories.allonsets);
       wlist = vertcat(events.categories.wlist);
       duration = horzcat(events.categories.stimdur)';      
    end    
    
%     active = horzcat(events.categories.active)';
    if isfield(events.categories, 'duration') == 1
    elseif isfield(events.categories, 'stimdur') == 1
       duration = horzcat(events.categories.stimdur)';
    end
    
    % Check if the trial is delayed
    delay = allonsets(:,end) - allonsets(:,1) > 4; % define an object criteria for that
    % Calculate RT
    RT = duration-(allonsets(:,end) - allonsets(:,1));
    
    for i = 1:length(trialno)
        events_byTrial(i).block = BN{blockN};
        events_byTrial(i).task = task;
        events_byTrial(i).trialno = trialno(i);
        events_byTrial(i).wlist = wlist(i);
        events_byTrial(i).allonsets = allonsets(i,:);
%         events_byTrial(i).active = active(i);
        events_byTrial(i).delay = delay(i);
        events_byTrial(i).RT = RT(i);
    end
    
    % Add calculation info
    for i=1:length(events_byTrial)
        % Calculation info
        [C,matches] = strsplit(events_byTrial(i).wlist{1},{'+','-','=', 'and', 'is'},'CollapseDelimiters',true);
        if sum(isstrprop(C{1}, 'digit')) > 0;
            isCalc = 1;
            Operand1 = str2num((C{1}));
            Operand2 = str2num((C{2}));
            if strmatch(matches{1}, '-') == 1
                Operator = -1;
            else
                Operator = 1;
            end
            CorrectResult = Operand1 + Operand2*Operator;
            PresResult = str2num((C{3}));
            Deviant = CorrectResult - PresResult;
            AbsDeviant = abs(Deviant);
        else
            isCalc = 0;
            Operand1 = nan;
            Operand2 = nan;
            Operator = nan;
            CorrectResult = nan;
            PresResult = nan;
            Deviant = nan;
            AbsDeviant = nan;
        end
        
        events_byTrial(i).isCalc = isCalc;
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

