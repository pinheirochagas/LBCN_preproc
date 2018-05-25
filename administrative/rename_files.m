clear
curr_dir = '/Users/amydaitch/Documents/MATLAB/analysis_ECoG/Results/MMR/S18_119/FreqDecompose/v1/gamma_fig_stimresp/';
new_dir = '/Users/amydaitch/Documents/MATLAB/analysis_ECoG/Results/MMR/S18_119/FreqDecompose/v1/gamma_fig_stimresp_rename/';

old_lbls = {'LINSA','LINSP','LAT1','LHT2','LTPT','LSG','LOF','LCINA','LCINP','RAMY','RHIP','RCINA','RCINP','LPVT'};
new_lbls = {'LavINS','LdINS','LAmy','LaHIP','LTP','LsgCIN','LaORB','LadCIN','LRSC','RAmy','RmHIP','RadCIN','RRSC','LVTC'};

cd(curr_dir);

fnames = dir;
fnames = {fnames(:).name};

for i = 1:length(old_lbls)
    tmp_inds = find(contains(fnames,old_lbls{i}));
    for j = 1:length(tmp_inds)
%         load(fnames{tmp_inds(j)})
        new_fn = strrep(fnames{tmp_inds(j)},old_lbls{i},new_lbls{i});
        new_fn = strrep(new_fn,'-','');
        if ~strcmpi(fnames{tmp_inds(j)},new_fn)
            movefile(fnames{tmp_inds(j)},new_fn)
        end
    end
end

%% change elec name in orig iEEG file
curr_dir = '/Users/amydaitch/Documents/MATLAB/analysis_ECoG/Results/MMR/S18_119/FreqDecompose/v1/gamma_fig_stimresp/';
cd(curr_dir);

fnames = dir;
fnames = {fnames(:).name};
for i = 1:length(fnames)
    if contains(fnames{i},'S17')
        new_fn = strrep(fnames{i},'S17','S18');
        movefile(fnames{i},new_fn)
    end
end