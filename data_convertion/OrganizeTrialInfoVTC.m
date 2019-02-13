function OrganizeTrialInfoVTC(sbj_name, project_name, block_names, dirs)

warning('off','all')
%Note there are multiple versions of VTC that have been run in the lab

for ci = 1:length(block_names)
   %second block always starts at the 420 point and third block always
    %starts at the 840 point in version 3 of this experiment 
    
%     if length(block_names)==2 %and eventually the subject number is over 100
%         bn_2=block_names{2};
%         bn = block_names{ci};
%         if strcmp(bn,bn_2)
%             load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn_2));
%             soda_name = dir(fullfile(globalVar.psych_dir, 'sodata*.mat'));
%             K = load([globalVar.psych_dir '/' soda_name.name]);
%             K.theData(1:420) = [];
%             ntrials = 420;
%         else
%             bn = block_names{ci}; %if looking at the first block
%             load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn));
%             soda_name = dir(fullfile(globalVar.psych_dir, 'sodata*.mat'));
%             K = load([globalVar.psych_dir '/' soda_name.name]); 
%         end
%     elseif length(block_names)==3 %and eventually the subject number is over 100
%         bn_2=block_names{2};
%         bn_3=block_names{3};
%         bn = block_names{ci};
%         if strcmp(bn,bn_2)
%             load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn_2));
%             soda_name = dir(fullfile(globalVar.psych_dir, 'sodata*.mat'));
%             K = load([globalVar.psych_dir '/' soda_name.name]);
%             K.theData(1:420) = [];
%             ntrials = 420;
%         elseif strcmp(bn,bn_3)
%            load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn_3));
%             soda_name = dir(fullfile(globalVar.psych_dir, 'sodata*.mat'));
%             K = load([globalVar.psych_dir '/' soda_name.name]);
%             K.theData(1:840) = [];
%             ntrials = 420;
%         else
%             bn = block_names{ci}; %if looking at the first block
%             load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn));
%             soda_name = dir(fullfile(globalVar.psych_dir, 'sodata*.mat'));
%             K = load([globalVar.psych_dir '/' soda_name.name]); 
%         end
%     else %if have only one block
%         bn = block_names{ci};
%             load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn));
%             soda_name = dir(fullfile(globalVar.psych_dir, 'sodata*.mat'));
%             K = load([globalVar.psych_dir '/' soda_name.name]); 
%     end 
%     
    
    
    bn = block_names{ci};
    
    %% Load globalVar
    load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn));
    
    % Load behavioral file
    soda_name = dir(fullfile(globalVar.psych_dir, 'sodata*.mat'));
    K = load([globalVar.psych_dir '/' soda_name.name]); 
    
    
    % start trialinfo
    trialinfo = table;
    
    %works for versions 1 and 3 of VTC
    ntrials = K.trial;
    
    [K,ntrials] = OrganizeTrialInfoVTCExceptions(sbj_name,bn,K,ntrials);
%     if strcmp(sbj_name,'S17_112_EA') && strcmp(bn, 'E17-450_0003') || strcmp(sbj_name,'S18_132_MDC') && strcmp(bn, 'E18-975_0005')
%             K.theData(1:420) = [];
%             ntrials = 420;
%     elseif strcmp(sbj_name,'S17_112_EA') && strcmp(bn, 'E17-450_0004')
%             K.theData(1:840) = [];
%             ntrials = 420;
%     end 
    
    for i = 1:ntrials
        if ~isempty(K.theData(i).keys)
            trialinfo.keys{i}=K.theData(i).keys(1);
        else
            trialinfo.keys{i}={NaN};
        end
        
        if K.theData(i).RT==0
            trialinfo.RT(i)=NaN;
        else
            trialinfo.RT(i) = K.theData(i).RT(1);
        end
        
        
        trialinfo.StimulusOnsetTime(i) = K.theData(i).flip.StimulusOnsetTime;
        trialinfo.stimlist(i) = K.stimlist(i)';
        temp = extractBefore(trialinfo.stimlist(i), '.png');
        if contains(temp, ' copy')
            temp = extractBefore(trialinfo.stimlist(i), ' copy');
        else
        end
        length_temp = strlength(temp);
        stim_temp = extractBefore(temp, length_temp-1);
        num_temp = string(regexp(temp, '\d+', 'match'));
        num = str2num(num_temp);
        %going to use this for the number part of it
        
        
        %newer version of VTC
        if 1071<=num && num<=1080
            trialinfo.condNames{i} = 'bird_bodies';
        elseif 1061<=num && num<=1070
            trialinfo.condNames{i} = 'bird_bodies';
        elseif 1121<=num && num<=1130
            trialinfo.condNames{i} = 'buildings';
        elseif 1101<=num && num<=1110
            trialinfo.condNames{i} = 'cars_from_front';
        elseif 1141<=num && num<=1150
            trialinfo.condNames{i} = 'cars_from_side';
        elseif 1151<=num && num<=1160
            trialinfo.condNames{i} = 'chairs';
        elseif 1101<=num && num<=1110
            trialinfo.condNames{i} = 'cars_from_front';
        elseif 1211<=num && num<=1220
            trialinfo.condNames{i} = 'Chinese_false_fonts';
        elseif 1201<=num && num<=1210
            trialinfo.condNames{i} = 'Chinese_pseudowords';
        elseif 1191<=num && num<=1200
            trialinfo.condNames{i} = 'Chinese_words';
        elseif 1161<=num && num<=1170
            trialinfo.condNames{i} = 'false_fonts';
        elseif 1171<=num && num<=1180
            trialinfo.condNames{i} = 'hands';
        elseif 1091<=num && num<=1100
            trialinfo.condNames{i} = 'human_bodies';
        elseif 1081<=num && num<=1090
            trialinfo.condNames{i} = 'human_faces';
        elseif 1111<=num && num<=1120
            trialinfo.condNames{i} = 'logos';
        elseif 1081<=num && num<=1090
            trialinfo.condNames{i} = 'human_faces';
        elseif 1051<=num && num<=1060
            trialinfo.condNames{i} = 'mammal_bodies';
        elseif 1081<=num && num<=1090
            trialinfo.condNames{i} = 'human_faces';
        elseif 1041<=num && num<=1050
            trialinfo.condNames{i} = 'mammal_faces';
        elseif 1181<=num && num<=1190
            trialinfo.condNames{i} = 'natural_scenes';
        elseif 1031<=num && num<=1040
            trialinfo.condNames{i} = 'numbers';
        elseif 1221<=num && num<=1230
            trialinfo.condNames{i} = 'primate_faces';
        elseif 1011<=num && num<=1020
            trialinfo.condNames{i} = 'pseudowords';
        elseif 1081<=num && num<=1090
            trialinfo.condNames{i} = 'human_faces';
        elseif 1231<=num && num<=1253
            trialinfo.condNames{i} = 'scrambled_images';
        elseif 1131<=num && num<=1140
            trialinfo.condNames{i} = 'shapes';
        elseif 1081<=num && num<=1090
            trialinfo.condNames{i} = 'human_faces';
        elseif 1021<=num && num<=1030
            trialinfo.condNames{i} = 'tools';
        elseif 1001<=num && num<=1010
            trialinfo.condNames{i} = 'words';
            
            %old version of VTC
        elseif 28<=num && num<=36
            trialinfo.condNames{i} = 'animals';
        elseif 37<=num && num<=45
            trialinfo.condNames{i} = 'faces';
        elseif 19<=num && num<=27
            trialinfo.condNames{i} = 'falsefonts';
        elseif 55<=num && num<=63
            trialinfo.condNames{i} = 'animals';
        elseif 55<=num && num<=63
            trialinfo.condNames{i} = 'animals';
        elseif 01<=num && num<=09
            trialinfo.condNames{i} = 'numbers'; %PROBLEM: PERSIAN NUMS USE THE SAME THING
        elseif 46<=num && num<=54
            trialinfo.condNames{i} = 'places';
        elseif 64<=num && num<=72
            trialinfo.condNames{i} = 'spanish_words';
        elseif 10<=num && num<=18
            trialinfo.condNames{i} = 'words';
        else
        end
        
        
        %decode the numbers
        if strcmp(trialinfo.condNames{i}, 'numbers')
            if num==1031
                trialinfo.stim{i} = '179';
            elseif num==1032
                trialinfo.stim{i} = '258';
            elseif num==1033
                trialinfo.stim{i} = '339';
            elseif num==1034
                trialinfo.stim{i} = '362';
            elseif num==1035
                trialinfo.stim{i} = '406';
            elseif num==1036
                trialinfo.stim{i} = '504';
            elseif num==1037
                trialinfo.stim{i} = '587';
            elseif num==1038
                trialinfo.stim{i} = '610';
            elseif num==1039
                trialinfo.stim{i} = '841';
            elseif num==1032
                trialinfo.stim{i} = '972';
           
            %for older version, but problem with persian numbers
            elseif num==01
                trialinfo.stim{i} = '135';
            elseif num==02
                trialinfo.stim{i} = '242';
            elseif num==03
                trialinfo.stim{i} = '329';
            elseif num==04
                trialinfo.stim{i} = '474';
            elseif num==05
                trialinfo.stim{i} = '563';
            elseif num==06
                trialinfo.stim{i} = '687';
            elseif num==07
                trialinfo.stim{i} = '725';
            elseif num==08
                trialinfo.stim{i} = '892';
            else
            end
        else
            trialinfo.stim(i) = strcat(trialinfo.condNames{i},'_',num_temp);
        end
        
        
        %Earlier version of VTC did not have them press anything
        if isfield(K,'theData.oneback') == 1
            %Correct - if oneback & pressed is 1
            if ~isempty(K.theData(i).oneback)
                if K.theData(i).oneback==0 && strcmp(K.theData(i).keys, 'noanswer')
                    trialinfo.isCorrect{i}=1;
                elseif  K.theData(i).oneback==1 && strcmp(K.theData(i).keys, '1')
                    trialinfo.isCorrect(i)=1;
                else
                    trialinfo.isCorrect(i)=0;
                end
            else
                trialinfo.isCorrect(i)=0;
            end
        else
        end
    end
    save([globalVar.psych_dir '/trialinfo_', bn '.mat'], 'trialinfo');
end
end


%should just be able to use cond here
%want the image number as a stimlsit variable
%Correct key: when oneback and keys are both 1, should be correct
