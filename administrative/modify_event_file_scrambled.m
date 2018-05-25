%% for scrambled

sbjs = {'S13_57_TVD','S14_62_JW'};
project_name = 'Scrambled';

initialize_dirs

for si = 1:length(sbjs)
    sbj = sbjs{si};
    task = get_project_name(sbj,project_name);
    BN = block_by_subj(sbj,task);
    for bi = 1:length(BN)
        load(sprintf('%s/%s/%s/%s/events_%s.mat',results_root,task,sbj,BN{bi},BN{bi}));

        numCat = find(strcmp(categNames,'number'));
        ntrials = events.categories(numCat).numEvents;
        temp_wlist = events.categories(numCat).wlist;
        wlist_num = nan(1,ntrials);
        
        for ti = 1:ntrials
            temp_stim = events.categories(numCat).wlist{ti};
            if strcmp(task,'LogoPassive')
                wlist_num(ti)=str2num(temp_stim(7)); % index 5 for Scrambled, 7 for Logo
            else
                wlist_num(ti)=str2num(temp_stim(5));
            end
        end
        
        events.categories(numCat).wlist_num = wlist_num;
        fp = sprintf('%s/%s/%s/%s/events_%s.mat',results_root,task,sbj,BN{bi},BN{bi});
        save(fp,'events','categNames')
    end
end
        
