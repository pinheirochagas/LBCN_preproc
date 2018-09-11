function trialinfo = OrganizeTrialInfoNumber_comparison(sbj_name, project_name, block_names, dirs)
%% Get and prepare behavioral trialinfo

for i = 1:length(block_names)
    results_table = table;
    stim_table = table;
    %% Load globalVar
    bn = block_names{i};
    load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn));
    % Load trialinfo
    soda_name = dir(fullfile(globalVar.psych_dir, 'sodata*.mat'));
    load([globalVar.psych_dir '/' soda_name.name], 'theData'); % block 55 %% FIND FILE IN THE FOLDER AUTO
    
    % Correct for this subject. 
    if strcmp(sbj_name, 'S18_127') && strcmp(bn, 'E18-706_0039')
        theData = theData(3:end);
    end
    
    %% correct for missing keys and rt
    for ii = 1:length(theData)
        if isempty(theData(ii).keys)
            theData(ii).keys = 'noanswer';
        end
        if isempty(theData(ii).RT)
            theData(ii).RT = nan;
        end
        if isempty(theData(ii).flip)
            theData(ii).flip.StimulusOnsetTime = nan;
        end
    end

    
    results_table = vertcat(results_table,struct2table(theData));
    
    % load stim
    load([globalVar.psych_dir '/Run' num2str(i)  '/permutedTrials.mat']);
    permdottype(isnan(permdottype))=0; % substitute nan for 0, to make table consise
    stim_table = vertcat(stim_table, table(permnum1',permnum2',permlum1',permlum2',permstimtype',permconds',permdottype'));
    
    
    % Rename table cols
    stim_table.Properties.VariableNames = {'num1', 'num2', 'lum1', 'lum2', 'stim_type', 'condNames', 'dot_type'};
    
    %% correct sbj_name 'S15_89b_JQ', easiest way
    if strmatch(sbj_name, 'S15_89b_JQ') % this sbj_name completed the older version
        for i = 1:length(stim_table.num1)
            if stim_table.num1(i) ~= 55;
                stim_table.num2(i) = stim_table.num1(i);
                stim_table.num1(i) = 55;
                if strmatch(results_table.keys{i}, '2')
                    results_table.keys{i} = '1';
                else
                    results_table.keys{i} = '2';
                end
            else
            end
        end
    end
    
    
    %% Plug trialinfo and stim in the same table
    trialinfo = stim_table;
    
    % Unjitter num2
    trialinfo.num2cat = trialinfo.num1; % initialize
    num_deviants = [-22, -16, -10, -4, +4, +10, +16, +22] + trialinfo.num1(1);
    for ii = 1:length(trialinfo.num2)
        for iii = 1:length(num_deviants)
            if trialinfo.num2(ii) == num_deviants(iii) || trialinfo.num2(ii) == num_deviants(iii)+1 || trialinfo.num2(ii) == num_deviants(iii) -1;
                trialinfo.num2cat(ii) = num_deviants(iii);
                continue
            else
            end
        end
    end
    
    % Add ratios
    trialinfo.ratios_num = trialinfo.num1./trialinfo.num2cat;
    trialinfo.ratios_lum = trialinfo.lum1./trialinfo.lum2;
    
    
    % Add correct answer
    trialinfo.larger = trialinfo.num1; % initialize
    for ii = 1:length(trialinfo.num2)
        if trialinfo.num2(ii) > trialinfo.num1(ii);
            trialinfo.larger(ii) = 2;
        else
            trialinfo.larger(ii) = 1;
        end
    end
    
    % add keys
    trialinfo.keys = trialinfo.num1; % initialize
    for ii = 1:length(results_table.keys)
        end
        key = str2num(results_table.keys{ii});
        if ~isempty(key)
            trialinfo.keys(ii) = key;
        else
            trialinfo.keys(ii) = NaN;
        end
    end
    
    % add accuracy
    trialinfo.accuracy = trialinfo.num1; % initialize
    for ii = 1:length(trialinfo.keys)
        if trialinfo.keys(ii) == trialinfo.larger(ii)
            trialinfo.accuracy(ii) = 1;
        elseif trialinfo.keys(ii) ~= trialinfo.larger(ii) && isnan(trialinfo.keys(ii)) == 0
            trialinfo.accuracy(ii) = 0;
        elseif isnan(trialinfo.keys(ii)) == 1
            trialinfo.accuracy(ii) = NaN;
        end
    end
    
    % add RT
    trialinfo.RT = trialinfo.num1; % initialize
    for ii = 1:length(results_table.RT)
        if isnan(trialinfo.keys(ii)) == 0
            trialinfo.RT(ii) = results_table.RT(ii);
        else
            trialinfo.RT(ii) = NaN;
        end
    end
    
    % Add stim onset
    for i = 1:length(theData)
        trialinfo.StimulusOnsetTime(i) = theData(i).flip.StimulusOnsetTime;
    end
    
    % Add some conditions
    trialinfo.dist_num = discretize(abs(trialinfo.num1-trialinfo.num2cat),4);
    trialinfo.dist_lum = discretize(abs(trialinfo.lum1-trialinfo.lum2),4);
    
    for i = 1:size(trialinfo,1)
        if trialinfo.condNames(i) == 1
            trialinfo.conds_num_lum{i} = 'number';
        else
            trialinfo.conds_num_lum{i} = 'brightness';
        end
        
        if trialinfo.condNames(i) == 1 && trialinfo.stim_type(i) == 1
            trialinfo.conds_num_lum_digit_dot{i} = 'brightness_digit';
        elseif trialinfo.condNames(i) == 1 && trialinfo.stim_type(i) == 2
            trialinfo.conds_num_lum_digit_dot{i} = 'brightness_dot';
        elseif trialinfo.condNames(i) == 2 && trialinfo.stim_type(i) == 1
            trialinfo.conds_num_lum_digit_dot{i} = 'number_digit';
        elseif trialinfo.condNames(i) == 2 && trialinfo.stim_type(i) == 2
            trialinfo.conds_num_lum_digit_dot{i} = 'number_dot';
        end
    end
    
    for i = 1:size(trialinfo,1)
        if strcmp(trialinfo.conds_num_lum{i}, 'number')
            trialinfo.conds_num_lum_digit_dot_distance{i} = [trialinfo.conds_num_lum_digit_dot{i} '_' num2str(trialinfo.dist_num(i))];
        else
            trialinfo.conds_num_lum_digit_dot_distance{i} = [trialinfo.conds_num_lum_digit_dot{i} '_' num2str(trialinfo.dist_lum(i))];
        end    
    end    
    
    %% Save trialinfo
    save([globalVar.psych_dir '/trialinfo_', bn '.mat'], 'trialinfo');

end


