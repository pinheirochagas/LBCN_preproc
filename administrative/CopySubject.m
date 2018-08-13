function CopySubject(subj_name, s_psychData, d_psychData, s_neuralData, d_neuralData)
% s source 
% d destination

%% psychData
if ~exist([d_psychData subj_name])
    copyfile([s_psychData '/' subj_name], [d_psychData '/' subj_name])
else
end

%% neuralData
neuralData_folders = {'originalData', 'CARData', 'CompData', 'FiltData', ...
    'SpecData', 'HFBData'};

for i = 1:length(neuralData_folders)
    
    if ~exist([d_neuralData '/' neuralData_folders{i} '/' subj_name])
        mkdir([d_neuralData '/' neuralData_folders{i} '/' subj_name])
        disp(['copying ' neuralData_folders{i}])
        copyfile([s_neuralData '/' neuralData_folders{i} '/' subj_name], [d_neuralData '/' neuralData_folders{i} '/' subj_name])
    else
    end
    
end


end

