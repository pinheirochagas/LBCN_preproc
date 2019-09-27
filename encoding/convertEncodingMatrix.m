function convertEncodingMatrix(data, subjVar, cfg)
%% Converts data structure into a encoding matrix
% Here this matrix is represented as a table, for easy access to the fields.
% Each row represents a given time unit.
% Each column represents different data feature for a single channel, such as:
%        brain (e.g. HFB); taks (e.g. Math vs. Memory); behavioral (e.g. RT) or subject.
%

% To be defined
cfg = []
cfg.time_window = [0 2] % in secs

% Define time windows to crop
if ~isempty(cfg.time_window)
    min_time_idx = min(find(data.time >= cfg.time_window(1)));
    max_time_idx = max(find(data.time <= cfg.time_window(2)));
    time_window = min_time_idx:max_time_idx;
end


% Define which kind of data: Band vs. Spec
size_wave = size(data.wave);

enc_matrix = table;

% Band data
if length(size_wave) == 3
    trial_dim = 1;
    elect_dim = 2;
    time_dim = 3;
    
    % Crop time
    if ~isempty(cfg.time_window)       
        data.time = data.time(time_window);
        data.wave = data.wave(:,:,time_window);
    end
    
    
    n_trials = size(data.wave,trial_dim);
    n_elects = size(data.wave,elect_dim);
    n_time = size(data.wave,time_dim);
    
    
    % Basic matrix with task features
    enc_matrix.subj_name = repmat(subjVar.sbj_name(1:6),n_trials*n_time, 1);
    enc_matrix.task_name = repmat(data.project_name,n_trials*n_time, 1);
    
    % specifics
    switch data.project_name
        case 'MMR'
            task = 
    
    enc_matrix.trial = reshape(repmat(1:n_trials, n_time,1), n_trials*n_time, 1);
    enc_matrix.time = repmat(data.time, 1, n_trials)';
    
    
    
    % trialinfo
    trialinfo_concat = repelem(data.trialinfo,n_time,1);

    
    enc_matrix = [enc_matrix trialinfo_concat];
    % Correct the matrix for general, accound for all tasks
    % this should be a new function
    
    enc_matrix.Properties.VariableNames{strcmp(enc_matrix.Properties.VariableNames, 'wlist')} = 'stim';
    
  
    % Add brain features per electrode
    enc_matrix_el = cell(n_elects,1);
    for i = 1:n_elects
        enc_matrix_el{i} = enc_matrix;
        enc_matrix_el{i}.HFB = reshape(data.wave(:,i,:), n_trials*n_time,1);
        enc_matrix_el{i}.HFB = reshape(data.wave(:,i,:), n_trials*n_time,1);

    end
    
    
    % Spec data
else
end




end