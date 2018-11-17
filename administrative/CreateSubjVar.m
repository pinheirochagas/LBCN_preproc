function subjVar = CreateSubjVar(sbj_name, dirs, data_format, fsDir_local)

%% Load a given globalVar
gv_dir = dir(fullfile([dirs.data_root filesep 'originalData/' sbj_name]));
gv_inds = arrayfun(@(x) contains(x.name, 'global'), gv_dir);
fn_tmp = gv_dir(gv_inds);
load([fn_tmp(1).folder filesep fn_tmp(1).name])

%% Cortex and channel label correction
subjVar = [];
cortex = getcort(dirs);
coords = importCoordsFreesurfer(dirs);
elect_names = importElectNames(dirs);
[elect_MNI, elecNames, isLeft, avgVids, subVids] = sub2AvgBrainCustom([],dirs, fsDir_local);
close all
V = importVolumes(dirs);

subjVar.cortex = cortex;
subjVar.V = V;
subjVar.elect_native = coords;
subjVar.elect_MNI = elect_MNI;
subjVar.elect_names = elect_names;

%% Correct channel name 
% Load naming from google sheet
[DOCID,GID] = getGoogleSheetInfo('chan_names_ppt', []);
googleSheet = GetGoogleSpreadsheet(DOCID, GID);
chan_names_ppt = googleSheet.(sbj_name);
chan_names_ppt = chan_names_ppt(~cellfun(@isempty, chan_names_ppt)); % Dangerous for the ones with skip names


nchan_fs = length(elect_names);

if strcmp(data_format, 'edf')
    chan_compare = globalVar.channame;
    nchan_cmp = globalVar.nchan;
else
    chan_compare = chan_names_ppt;
    nchan_cmp = length(chan_names_ppt);
end

new_order = nan(1,nchan_fs);

for i = 1:nchan_fs
    tmp = find(ismember(chan_compare,elect_names(i)));
    if ~isempty(tmp)
        new_order(i) = tmp(1);
    end
end

bad_inds_fs = find(isnan(new_order));
bad_inds_cmp = setdiff(1:nchan_cmp,new_order(~isnan(new_order)));


elect_names(bad_inds_fs)

% Situation 1 - some channels are present in freesurfer, but not in EDF/TDT 
%leave them as they are, so nans will be added to coords and after removed. 

% Option 2 - some channels have mismatched names in freesurfer and EDF/TDT
% names can be fixed to actually match existing channels. 

% Situation 3 - some channels in EDF or TDT to no exist in freesurver, so have to add nans to elec_names, MNI and native coords



%% Organize subjVar
subjVar.cortex = cortex;
subjVar.V = V;

if isempty(bad_inds_fs) || isempty(bad_inds_fs) % if everything matches uip
    subjVar.elect_native = nan(nchan_fs,3);
    subjVar.elect_MNI = nan(nchan_fs,3);
    subjVar.elect_names = elect_names;
    subjVar.elect_native(new_order,:) = coords;
    subjVar.elect_MNI(new_order,:) = elect_MNI;
    subjVar.elect_names(new_order) = elect_names; 
    if ~isempty(bad_inds_cmp) % if not all electrodes were detected in freesurfer, add NaNs to coords
        for i = 1:length(bad_inds_cmp)
            subjVar.elect_names = [subjVar.elect_names; globalVar.channame{bad_inds_cmp(i)}];
            subjVar.elect_native = [subjVar.elect_native; NaN NaN NaN];
            subjVar.elect_MNI = [subjVar.elect_MNI; NaN NaN NaN];
        end
    else
        subjVar.elect_names = subjVar.elect_names(1:nchan_cmp);
        subjVar.elect_native = subjVar.elect_native(1:nchan_cmp,:);
        subjVar.elect_MNI = subjVar.elect_MNI(1:nchan_cmp,:);
    end
else
    undefined_subjVar = subjVar.elect_names(bad_inds_fs(bad_inds_fs<=length(elect_names)))
    undefined_globalVar = globalVar.channame(bad_inds_cmp)
end



%% Demographics
subjVar.demographics = GetDemographics(sbj_name);
if isempty(subjVar.demographics)
    warning(['There is no demographic info for ' sbj_name '. Please add it to the google sheet.'])
else
end

if ~exist([dirs.original_data filesep sbj_name], 'dir')
    mkdir([dirs.original_data filesep sbj_name])
else
end

%% Save subjVar
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

