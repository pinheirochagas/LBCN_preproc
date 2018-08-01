function data = OrganizeTrialInfoNumber_comparison(subject)
%% Get and prepare behavioral data

initDirs
%% Retrieve experimental runs
runs = block_by_subj(subject, 'NumComp');

% Initializa variables
results_table = table;
stim_table = table;

for i = 1:length(runs)
    % Load data
    data_dir = [data_root_dir subject '/' 'psychData/' runs{i}];
    cd(data_dir)
    soda = dir('*.mat');
    load(soda.name, 'theData')
    results_table = vertcat(results_table,struct2table(theData));
    % load stim
    load([data_dir '/Run' num2str(i)  '/permutedTrials.mat']);
    permdottype(isnan(permdottype))=0; % substitute nan for 0, to make table consise
    stim_table = vertcat(stim_table, table(permnum1',permnum2',permlum1',permlum2',permstimtype',permconds',permdottype'));
end

% Rename table cols
stim_table.Properties.VariableNames = {'num1', 'num2', 'lum1', 'lum2', 'stim_type', 'conds', 'dot_type'};

%% correct subject 'S15_89b_JQ', easiest way
if strmatch(subject, 'S15_89b_JQ') % this subject completed the older version
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


%% Plug data and stim in the same table
data = stim_table;

% Unjitter num2
data.num2cat = data.num1; % initialize
num_deviants = [-22, -16, -10, -4, +4, +10, +16, +22] + data.num1(1);
for ii = 1:length(data.num2)
    for iii = 1:length(num_deviants)
        if data.num2(ii) == num_deviants(iii) || data.num2(ii) == num_deviants(iii)+1 || data.num2(ii) == num_deviants(iii) -1;
            data.num2cat(ii) = num_deviants(iii);
            continue
        else 
        end
    end
end

% Add ratios
data.ratios_num = data.num1./data.num2cat;
data.ratios_lum = data.lum1./data.lum2;


% Add correct answer
data.larger = data.num1; % initialize
for ii = 1:length(data.num2)
    if data.num2(ii) > data.num1(ii);
        data.larger(ii) = 2;
    else
        data.larger(ii) = 1;
    end
end

% add keys
data.keys = data.num1; % initialize
for ii = 1:length(results_table.keys)
    key = str2num(results_table.keys{ii});
    if ~isempty(key)
        data.keys(ii) = key;
    else
        data.keys(ii) = NaN;
    end
end

% add accuracy
data.accuracy = data.num1; % initialize
for ii = 1:length(data.keys)
    if data.keys(ii) == data.larger(ii);
        data.accuracy(ii) = 1;
    elseif data.keys(ii) ~= data.larger(ii) && isnan(data.keys(ii)) == 0; 
        data.accuracy(ii) = 0;
    elseif isnan(data.keys(ii)) == 1; 
        data.accuracy(ii) = NaN;
    end
end

% add RT
data.RT = data.num1; % initialize
for ii = 1:length(results_table.RT)
    if isnan(data.keys(ii)) == 0;
        data.RT(ii) = results_table.RT(ii);
    else
        data.RT(ii) = NaN;
    end
end

    
    


end

