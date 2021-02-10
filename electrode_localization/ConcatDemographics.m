function demographics_all = ConcatDemographics(subjects, dirs)

demographics_all = table;
for is = 1:length(subjects)
    s = subjects{is};
    load([dirs.original_data filesep  s filesep 'subjVar_'  s '.mat']);
    
    if isempty(subjVar.demographics)
        subjVar.demographics = GetDemographics(s);
        save([dirs.original_data filesep s filesep 'subjVar_' s '.mat'], 'subjVar')
        display(['subjVar replaced for subject ' s]);
    else
    end

    demographics_all = [demographics_all; subjVar.demographics];
    
end


end

