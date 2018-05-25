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

sbjs= {'S13_52_FVV'};
project_name= 'MMR';

bad_z = 8; %eliminate

initialize_dirs;

%other variables
prestim_s = 0.2; %200ms

%% identify bad epochs
%loop through each channel, and each condition, to identify bad epochs
for si = 1:length(sbjs)
    sbj_name = sbjs{si};
    task = get_project_name(sbj_name,project_name);
    BN = block_by_subj(sbj_name,task);
    for bi = 1:length(BN)
        block_name = BN{bi};
        load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',data_root,sbj_name,task,sbj_name,block_name),'globalVar');
        if (~strcmp(task,'Rest'))
            load(sprintf('%s/%s/%s/%s/events_%s.mat',results_root,task,sbj_name,block_name,block_name),'events');
        end
        fs = globalVar.iEEG_rate;
        prestim = floor(prestim_s*fs);
        elecs=setxor(1:globalVar.nchan,globalVar.refChan);
        for e = 1:length(elecs);
            ei = elecs(e);
            %load chan, CAR data
            fprintf('Processing chan: %.3d \n',ei)
%             load(sprintf('%s/CARiEEG%s_%.2d.mat',globalVar.CAR_dir,block_name,ei));
            load(sprintf('%s/Normband_%s_%.3d.mat',globalVar.Spec_dir,block_name,ei));
            data = band.amplitude;
%             clear wave
            zdata = zscore(data);
            zdiff = zscore([diff(data) 0]);
            
            %create bad data index
            bad_data = zeros(1, length(data));
            
            % exclude timepoints bad_z stds outside of mean
            bad_data(abs(zdata)>bad_z) = 1;
            
            % exclude rapid changes in signal
            %         bad_data(abs(diff([data 0]))>max_jump) = 1;
            bad_data(abs(zdiff)>bad_z) = 1;
            
            globalVar.bad_epochs(ei).timepoints_ds=find(bad_data);
            globalVar.bad_epochs(ei).timepoints = globalVar.bad_epochs(ei).timepoints_ds*globalVar.compression;
%             globalVar.bad_epochs(ei).timepoints_ds = unique(floor(globalVar.bad_epochs(ei).timepoints*globalVar.fs_comp/fs)); %timepoints in downsampled time
            
            if (~strcmp(task,'Rest'))
                allCats = {events.categories(:).name};
                for ci = 1:length(allCats)
                    ntrials = events.categories(ci).numEvents;
                    globalVar.bad_epochs(ei).categories(ci).numBadTimepts = NaN*ones(1,ntrials);
                    start_inds = floor(events.categories(ci).start*fs)-prestim;
                    end_inds = start_inds + floor(events.categories(ci).duration*fs);
                    for ti = 1:ntrials
                        globalVar.bad_epochs(ei).categories(ci).numBadTimepts(ti)=sum(ismember(globalVar.bad_epochs(ei).timepoints,start_inds(ti):end_inds(ti)));
                        globalVar.bad_epochs(ei).categories(ci).badTrials = find(globalVar.bad_epochs(ei).categories(ci).numBadTimepts>0);
                    end
                end
            end
        end
        fn=sprintf('%s/originalData/%s/global_%s_%s_%s.mat',data_root,sbj_name,task,sbj_name,block_name);
        save(fn,'globalVar');
    end
end






