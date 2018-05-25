%% bad_epochs.m
% Functions: Identifies bad epoch for analysis exclusion, add/remore during plots.
% Input: globalVar, CAR data
% Output: bad peochs to globalVar
% Dependencies: freezeColors.m & cbfreeze.m (matlab exchange)
%
% Brett Foster - 2013; LBCN, Stanford.
% modified by Amy Daitch

%% Inputs/define
%clear workspace
clear all
clc

%subject/block of interest
sbjs= {'S15_89b_JQ'};
% project_name= 'calculia';
project_name = 'calculia';

bad_z = 4; %eliminate

initialize_dirs;

%other variables
prestim_s = 0.5; %200ms
poststim_s = 2;

%% identify bad epochs

%loop through each channel, and each condition, to identify bad epochs
for si = 1:length(sbjs)
    sbj_name = sbjs{si};
    task = get_project_name(sbj_name,project_name);
    BN = block_by_subj(sbj_name,task);
    for bi = 1:length(BN)
        block_name = BN{bi};
        load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',data_root,sbj_name,task,sbj_name,block_name),'globalVar');
        load(sprintf('%s/%s/%s/%s/events_old_%s.mat',results_root,task,sbj_name,block_name,block_name),'events');
        fs = globalVar.iEEG_rate;
        prestim = floor(prestim_s*fs);
        poststim = floor(poststim_s*fs);
        elecs=setxor(1:globalVar.nchan,globalVar.refChan);
        for ei = 1:length(elecs)
            el = elecs(ei);
            %load chan, CAR data
            fprintf('Processing chan: %.3d \n',el)
            load(sprintf('%s/CARiEEG%s_%.2d.mat',globalVar.CAR_dir,block_name,el));
            data = wave;
            clear wave
            zdata = zscore(data);
            zdiff = zscore([diff(data) 0]);
            
            %create bad data index
            bad_data = zeros(1, length(data));
            
            % exclude timepoints bad_z stds outside of mean
            bad_data(abs(zdata)>bad_z) = 1;
            
            % exclude rapid changes in signal
            %         bad_data(abs(diff([data 0]))>max_jump) = 1;
            bad_data(abs(zdiff)>bad_z) = 1;
            
            globalVar.bad_epochs(el).timepoints=find(bad_data);
            globalVar.bad_epochs(el).timepoints_ds = unique(floor(globalVar.bad_epochs(el).timepoints*globalVar.fs_comp/fs)); %timepoints in downsampled time
            
            allCats = {events.categories(:).name};
            for ci = 1:length(allCats)
                ntrials = events.categories(ci).numEvents;
                globalVar.bad_epochs(el).categories(ci).numBadTimepts = NaN*ones(1,ntrials);
                if ntrials > 0
                    start_inds = floor(events.categories(ci).allonsets(:,1)*fs)-prestim;
                    end_inds = floor(events.categories(ci).allonsets(:,5)*fs)+poststim;
                end
                for ti = 1:ntrials
                    globalVar.bad_epochs(el).categories(ci).numBadTimepts(ti)=sum(ismember(globalVar.bad_epochs(el).timepoints,start_inds(ti):end_inds(ti)));
                    globalVar.bad_epochs(el).categories(ci).badTrials = find(globalVar.bad_epochs(el).categories(ci).numBadTimepts>0);
                end
            end
        end
        fn=sprintf('%s/originalData/%s/global_%s_%s_%s.mat',data_root,sbj_name,task,sbj_name,block_name);
        save(fn,'globalVar');
    end
end






