function UpdateGlobalVarDirs(sbj_name, project_name, block_names, dirs)


for i = 1:length(block_names)
    bn = block_names{i};
    % Load globalVar
    fn = sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn);
    load(fn,'globalVar');
    
    globalVar.sbj_name = sbj_name;
    globalVar.originalData = sprintf('%s/%s/%s', dirs.original_data,sbj_name, bn);
    globalVar.CARData = sprintf('%s/CARData/CAR/%s/%s',dirs.data_root,sbj_name, bn);
    globalVar.BandData = sprintf('%s/BandData/', dirs.data_root);
    globalVar.SpecData = sprintf('%s/SpecData/', dirs.data_root);
    globalVar.psych_dir = sprintf('%s/%s/%s', dirs.psych_root,sbj_name, bn);
    globalVar.result_dir = sprintf('%s/%s/%s/%s', dirs.result_root, project_name, sbj_name, bn);

    % Remove old fields
    field_rm = {'FiltData','CompData','HFBData','bad_epochs'};
    for ii = 1:length(field_rm)
       if isfield(globalVar, field_rm{ii})
           globalVar = rmfield(globalVar, field_rm{ii});
       else
       end
    end
%     globalVar.center = 'Stanford';
    % Save globalVar
    save(fn,'globalVar');
end

end