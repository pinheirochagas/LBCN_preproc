function OrganizeTrialInfo_MFA(sbj_name, project_name, block_names, dirs)

for i = 1:length(block_names)
    bn = block_names{i};
    
    %% Load globalVar
    load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn));
    
    % Load behavioral file
    soda_name = dir(fullfile(globalVar.psych_dir, 'sodata*.mat'));
    K = load([globalVar.psych_dir '/' soda_name.name]); % block 55 %% FIND FILE IN THE FOLDER AUTO
    
    
    % Load stimulus information
    stim_key = readtable('/Users/csava/Documents/code/lbcn_preproc-master/administrative/MFA_stimlist_key.csv');
    
    % start trialinfo
    [~,idx] = ismember(K.stimlist,stim_key.filename); 
     % Correct for the the subjects in which the filename for text is
    % different
    if sum(idx == 0) > 0 
        [~,idx] = ismember(K.stimlist,stim_key.filename2); 
    end
    
    %getting correct keys
    stim_key.correct(stim_key.correct==0) = 2;
    for i=1:length(K.theData)
        sub_resp(i)= str2double(K.theData(i).keys);
    end
   
    correct = stim_key.correct(idx);
    accuracy = correct ==sub_resp'; 
    
    %getting the type of variable [dots;digit;word]
    stim_type = regexp(stim_key.type, '_', 'split');
    stim_type = vertcat(stim_type{:});
    stim_type = stim_type(:,1)
    
    %defining other variables
    Operand1 = stim_key.operand1(idx);
    Operand2 = stim_key.operand2(idx);
    Operation = stim_key.operator(idx);
    PresResult = stim_key.PresResult(idx);
    CorrResult = stim_key.CorrectResult(idx);
    Deviant = stim_key.Deviant(idx);
    AbsDeviant = stim_key.AbsDeviant(idx);
    Category = stim_key.type(idx);
    stimlist = K.stimlist;
    condNames = stim_key.type(idx);
    CorrectResult = stim_key.CorrectResult(idx);
    PresResult = stim_key.PresResult(idx);
    Deviant = stim_key.Deviant(idx);
    AbsDeviant = stim_key.AbsDeviant(idx);
    
    
    
 trialinfo = table;
    trialinfo.stimlist = reshape(K.stimlist,length(K.stimlist),1); 
   
    
  for i = 1:length(K.theData)
        trialinfo.keys{i,1} = vertcat(K.theData(i).keys);
  end
    
  
  for i=1:length(K.theData)
        RTb(i,1)=K.theData(i).RT; 
  end
  
  trialinfo.RT = RTb;
  
  trialinfo.accuracy = accuracy;
  trialinfo.condNames = condNames;
  % need isCalc function?
  trialinfo.Operand1 = Operand1;
  trialinfo.Operand2 = Operand2;
  %trialinfo.OperandMin(i,1) = min(Operand1,Operand2);
  %trialinfo.OperandMax(i,1) = max(Operand1,Operand2);
  trialinfo.Operation = Operation;
  trialinfo.CorrectResult = CorrectResult;
  trialinfo.PresResult = PresResult;
  trialinfo.Deviant = Deviant;
  trialinfo.AbsDeviant = AbsDeviant;
  trialinfo.StimulusOnsetTime(i,1) = K.theData(i).flip.StimulusOnsetTime;
  trialinfo.stim_type = stim_type
  
  %missingallonset

    
    
    %% Correct for rest trials
    %     rest_inds = sort(K.rest_inds);
    %     rest_inds = rest_inds + (1:length(rest_inds));
    %     ntrials_total = size(trialinfo,1) + length(rest_inds);
    %     trialinfoNew = table;
    %     trialinfoNew(setdiff(1:ntrials_total,rest_inds),:)=trialinfo;
    %     trialinfoNew.condNames(rest_inds)={'rest'};
    %     trialinfoNew.conds_math_memory(rest_inds)={'rest'};
    %     trialinfoNew.wlist(rest_inds)={'+'};
    %     trialinfoNew.RT(rest_inds)=NaN;
    %     trialinfoNew.allonsets(rest_inds)=NaN;
    %
    %     trialinfo = trialinfoNew;
    
    % Save
    save([globalVar.psych_dir '/trialinfo_', bn '.mat'], 'trialinfo');
end

end

