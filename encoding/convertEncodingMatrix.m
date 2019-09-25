function convertEncodingMatrix(data)
%% Converts data structure into a encoding matrix
% Here this matrix is represented as a table, for easy access to the fields. 
% Each row represents a given time unit. 
% Each column represents different data feature for a single channel, such as: 
%        brain (e.g. HFB); taks (e.g. Math vs. Memory); behavioral (e.g. RT) or subject. 
% 

% Define which kind of data: Band vs. Spec 
size_wave = size(data.wave);

enc_matrix = table;


% Band data
if length(size_wave) == 3 
    trial_dim = 1;
    elect_dim = 2;
    time_dim = 3;
    n_trials = size(data.wave,trial_dim);
    n_elects = size(data.wave,elect_dim);
    n_time = size(data.wave,time_dim);
    
    % For each electrode
    trialinfo_concat = repelem(data.trialinfo,n_time,1);
    enc_matrix.time = repmat(data.time, 1, n_trials)';
    enc_matrix.trial = reshape(repmat(1:n_trials, n_time,1), n_trials*n_time, 1);
    enc_matrix = [enc_matrix trialinfo_concat];
    
    enc_matrix_el = cell(n_elects,1);
    for i = 1:n_elects    
        enc_matrix_el{i} = enc_matrix;
        enc_matrix_el{i}.HFB = reshape(data.wave(:,i,:), n_trials*n_time,1);
    end
    
    
% Spec data
else
end




end