function subjVar = CreateSubjVar(sbj_name, dirs, fsDir_local)

subjVar = [];
cortex = getcort(dirs);
coords = importCoordsFreesurfer(dirs);
elect_names = importElectNames(dirs);
[MNI_coords, elecNames, isLeft, avgVids, subVids] = sub2AvgBrainCustom([],dirs, fsDir_local);
close all
V = importVolumes(dirs);

subjVar.cortex = cortex;
subjVar.V = V;
subjVar.elect_native = coords;
subjVar.elect_MNI = MNI_coords;
subjVar.elect_names = elect_names;
subjVar.demographics = GetDemographics(sbj_name);
if isempty(subjVar.demographics)
    warning(['There is no demographic info for ' sbj_name '. Please add it to the google sheet.'])
else
end
if ~exist([dirs.original_data filesep sbj_name], 'dir')
    mkdir([dirs.original_data filesep sbj_name])
else
end
if ~exist([dirs.original_data filesep sbj_name filesep 'subjVar.mat' ], 'file')
    prompt = ['subjVar already exist for ' sbj_name ' . Replace it? (y or n):'] ;
    ID = input(prompt,'s');
    if strcmp(ID, 'y')
        save([dirs.original_data filesep sbj_name filesep 'subjVar_' sbj_name '.mat'], 'subjVar')
        disp(['subjVar saved for ' sbj_name])
    else
        warning(['subjVar NOT saved for ' sbj_name])
    end
else
end

end

