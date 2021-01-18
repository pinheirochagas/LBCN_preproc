function demographics_all = ConcatDemographics(subjects, dirs)

demographics_all = table;
for is = 1:length(subjects)
    load([dirs.original_data filesep  subjects{is} filesep 'subjVar_'  subjects{is} '.mat']);
    
   
 
    demographics_all = [demographics_all; subjVar.demographics];
    
    
end


end

