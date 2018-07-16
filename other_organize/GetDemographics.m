function T = GetDemographics(sbj_name, dirs)

% Load table
T = readtable([dirs.comp_root '/demographics.xlsx']);

% Select the subject rows
T = T(contains(T.sbj_name, sbj_name),:);

end