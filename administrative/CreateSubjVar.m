function subjVar = CreateSubjVar(sbj_name, dirs, data_format, fsDir_local)

%% Load a given globalVar
gv_dir = dir(fullfile([dirs.data_root filesep 'originalData/' sbj_name]));
gv_inds = arrayfun(@(x) contains(x.name, 'global'), gv_dir);
fn_tmp = gv_dir(gv_inds);
load([fn_tmp(1).folder filesep fn_tmp(1).name])

%% Cortex and channel label correction
subjVar = [];
cortex = getcort(dirs);
native_coord = importCoordsFreesurfer(dirs);
fs_chan_names = importElectNames(dirs);
[MNI_coord, chanNames, isLeft, avgVids, subVids] = sub2AvgBrainCustom([],dirs, fsDir_local);
close all
V = importVolumes(dirs);

subjVar.cortex = cortex;
subjVar.V = V;

%% Correct channel name 
% Load naming from google sheet
if strcmp(data_format, 'edf')
    [DOCID,GID] = getGoogleSheetInfo('chan_names_ppt', 'chan_names_fs_figures');
else
    [DOCID,GID] = getGoogleSheetInfo('chan_names_ppt', 'chan_names_ppt_log');
end
googleSheet = GetGoogleSpreadsheet(DOCID, GID);
ppt_chan_names = googleSheet.(sbj_name);
ppt_chan_names = ppt_chan_names(~cellfun(@isempty, ppt_chan_names)); % Dangerous for the ones with skip names
ppt_chan_names = cellfun(@(x) strrep(x, ' ', ''), ppt_chan_names, 'UniformOutput', false); % Remove eventual spaces

nchan_fs = length(fs_chan_names);
chan_comp = ppt_chan_names;
nchan_cmp = length(ppt_chan_names);

in_chan_cmp = false(1,nchan_fs);
for i = 1:nchan_fs
    in_chan_cmp(i) = ismember(fs_chan_names(i),chan_comp);
end

in_fs = false(1,nchan_cmp);
for i = 1:nchan_cmp
    in_fs(i) = ismember(chan_comp(i),fs_chan_names);
end

% 1: More channels in freesurfer  
if sum(in_chan_cmp) == length(in_chan_cmp) && sum(in_fs) == length(in_fs)
    % do nothing
elseif sum(in_chan_cmp) < length(in_chan_cmp) && sum(in_fs) == length(in_fs)
    fs_chan_names = fs_chan_names(in_chan_cmp); 
    native_coord = native_coord(in_chan_cmp,:);
    MNI_coord = MNI_coord(in_chan_cmp,:);

% 2: More channels in EDF/TDT     
elseif sum(in_chan_cmp) == length(in_chan_cmp) && sum(in_fs) < length(in_fs)
    fs_chan_names_tmp = cell(nchan_cmp,1);
    fs_chan_names_tmp(in_fs) = cellstr(fs_chan_names);
    fs_chan_names_tmp(in_fs==0) = chan_comp(in_fs==0);
    fs_chan_names = fs_chan_names_tmp;
    
    native_coord_tmp = nan(size(native_coord,1),size(native_coord,2),1);
    native_coord_tmp(in_fs,:) = native_coord;
    native_coord = native_coord_tmp;
    
    MNI_coord_tmp = nan(size(MNI_coord,1),size(MNI_coord,2),1);
    MNI_coord_tmp(in_fs,:) = MNI_coord;
    MNI_coord = MNI_coord_tmp;
else
    error('this exception is not accounted for, please check')
end
    
%% Reorder and save in subjVar
new_order = nan(1,nchan_cmp);
for i = 1:nchan_cmp
    tmp = find(ismember(fs_chan_names, chan_comp(i)));
    if ~isempty(tmp)
        new_order(i) = tmp(1);
    end
end

subjVar.native_coord = native_coord(new_order,:);
subjVar.MNI_coord = MNI_coord(new_order,:);
if strcmp(data_format, 'TDT')
    subjVar.elect_names = chan_comp;
else
    subjVar.elect_names = globalVar.channame;
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

