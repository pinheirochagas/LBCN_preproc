function CopySubject(sbj_name, s_psychData, d_psychData, s_neuralData, d_neuralData, neuralData_folders, project_name, block_names)
% s source
% d destination

%% neuralData_folders
if strcmp(neuralData_folders, 'all')
    neuralData_folders = {'originalData', 'CARData', 'CompData', 'FiltData', ...
        'SpecData', 'HFBData'};
else
end

%% Copy psychData
for i = 1:length(block_names)
    bn = block_names{i};
    
    if ~exist([d_psychData filesep sbj_name filesep bn])
        mkdir([d_psychData filesep sbj_name filesep bn])
        copyfile([s_psychData filesep sbj_name filesep bn], [d_psychData filesep sbj_name filesep bn])
    else
    end
    
    %% Copy neural data
    for ii = 1:length(neuralData_folders)
        if ~exist([d_neuralData filesep neuralData_folders{ii} filesep sbj_name filesep bn])
            disp(['copying ' neuralData_folders{ii} ' ' sbj_name])
            mkdir([d_neuralData filesep neuralData_folders{ii} filesep sbj_name filesep bn])
            copyfile([s_neuralData filesep neuralData_folders{ii} filesep sbj_name filesep bn], [d_neuralData filesep neuralData_folders{ii} filesep sbj_name filesep bn])
        else
        end
        
    end
    
    %% Copy globalVar 
    global_var_s_path = sprintf('%s/originalData/%s/global_%s_%s_%s.mat',s_neuralData,sbj_name,project_name,sbj_name,bn);
    global_var_d_path = sprintf('%s/originalData/%s/global_%s_%s_%s.mat',d_neuralData,sbj_name,project_name,sbj_name,bn);
    if ~exist(global_var_d_path)
        copyfile(global_var_s_path, global_var_d_path)
    else
    end
    
end
    
    
end


%
% if ~exist([d_psychData sbj_name])
%     copyfile([s_psychData '/' sbj_name], [d_psychData '/' sbj_name])
% else
% end