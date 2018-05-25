%% for scrambled

events_old = events;
clear events

% old category order
% categNames = {'foreign','letter','nonnumword','num_eqn','numword','number','scramble-letter','scramble-number','sentence','sym_eqn','text_eqn'};
categNames = {'company_logo','company_logo','foreign','letter','meaningful_logo','num_sym','number','word_sym'};
% categNames = {'letter','number','scramble-letter','scramble-number','foreign'};
% new category order
newCatArray = {'letter','number','scramble-letter','scramble-number','foreign'};
numcats = length(newCatArray);

for ci = 1:numcats
    events.categories(ci).name = newCatArray{ci};
    events.categories(ci).categNum = ci;

    cat_ind = find(strcmp(categNames,newCatArray{ci}));
    if (~isempty(cat_ind))
%         trials = find(events_old.conds == cat_ind);
        events.categories(ci).numEvents = events_old.categories(cat_ind).numEvents;
        events.categories(ci).start = events_old.categories(cat_ind).start;
        events.categories(ci).duration = events_old.categories(cat_ind).duration;
        events.categories(ci).stimNum = events_old.categories(cat_ind).stimNum;
        events.categories(ci).wlist = events_old.categories(cat_ind).stimFile;
%         events.categories(ci).RT = events_old.RT(trials);
%         events.categories(ci).sbj_resp = events_old.sbj_resp(trials);
        %     events.categories(ci).correct = events_old.correct(trials);
    else
        trials = [];
        events.categories(ci).numEvents = 0;
        events.categories(ci).start = [];
        events.categories(ci).duration = [];
        events.categories(ci).stimNum = [];
        events.categories(ci).wlist = {};
%         events.categories(ci).RT = [];
%         events.categories(ci).sbj_resp = {};
        %     events.categories(ci).correct = events_old.correct(trials);
    end

end

categNames = newCatArray;

%% scrambled- from behav file
% oldCatArray = {'letter','number','scramble-letter','scramble-number','foreign'};
% newCatArray = {'letter','number','scramble-letter','scramble-number','foreign'};
% numcats = length(newCatArray);
% 
% for ci = 1:numcats
%     events.categories(ci).name = newCatArray{ci};
%     events.categories(ci).categNum = ci;
% 
%     cat_ind = find(strcmp(categNames,newCatArray{ci}));
%     if (~isempty(cat_ind))
%         trials = find(conds == cat_ind);
%         events.categories(ci).numEvents = length(trials);
%         events.categories(ci).start = events_old.start(trials);
%         events.categories(ci).duration = events_old.duration(trials);
%         events.categories(ci).stimNum = trials;
%         events.categories(ci).wlist = events_old.stimFile(trials);
%         events.categories(ci).RT = events_old.RT(trials);
%         events.categories(ci).sbj_resp = events_old.sbj_resp(trials);
%         %     events.categories(ci).correct = events_old.correct(trials);
%     else
%         trials = [];
%         events.categories(ci).numEvents = 0;
%         events.categories(ci).start = [];
%         events.categories(ci).duration = [];
%         events.categories(ci).stimNum = [];
%         events.categories(ci).wlist = {};
%         events.categories(ci).RT = [];
%         events.categories(ci).sbj_resp = {};
%         %     events.categories(ci).correct = events_old.correct(trials);
%     end
% 
% end
% 
% categNames = newCatArray;

%% for 7Heaven
% 
% events_old = events;
% clear events
% 
% categNames  = {'Num','RhymingWord','NumWord'};
% % categNames  = {'Num','RhymingWord','NumWord','NumWordEn','RhymingWordEn'}; %S13_53_KS2
% newCatArray  = {'Num','RhymingWord','NumWord'};
% numcats = length(newCatArray);
% 
% for ci = 1:numcats
%     events.categories(ci).name = newCatArray{ci};
%     events.categories(ci).categNum = ci;
% 
%     cat_ind = find(strcmp(categNames,newCatArray{ci}));
%     if (~isempty(cat_ind))
%         trials = find(events_old.condition == cat_ind);
%         events.categories(ci).numEvents = length(trials);
%         events.categories(ci).start = events_old.stimOnset(trials);
%         events.categories(ci).stimNum = trials;
%         events.categories(ci).duration = events_old.RT(trials);
%     else
%         trials = [];
%         events.categories(ci).numEvents = 0;
%         events.categories(ci).start = [];
%         events.categories(ci).stimNum = [];
%         events.categories(ci).duration = [];
%     end
% 
% end
% 
% categNames = newCatArray;

%% For Context S12_41_KS
% clear;
% 
% sbj = 'S12_41_KS';
% task = 'Context';
% 
% initialize_dirs;
% 
% BN = block_by_subj(sbj,task);
% 
% oldCatArray = {'NumWord1digitAdd','Num1digitAdd','one_word','one_num'};
% newCatArray  = {'Num1digitAdd','Num2digitAdd','Num2digitSub','LetterAdd','NumWord1digitAdd'};
% numcats = length(newCatArray);
% 
% for bi = 1:length(BN)
% % for bi = 1
%     block_name = BN{bi};
%     psych_fn = get_psych_file(sbj,block_name);
%     load(sprintf('%s/%s/%s/%s/events_old_%s.mat',results_root,task,sbj,block_name,block_name))
%     load(sprintf('%s/%s/%s/%s',psych_root,sbj,block_name,psych_fn),'trials')
%     events_old = events;
%     clear events
% 
%     conds_old = [trials.cond];
%     condition = mod(conds_old-1,4)+1;
%     ntrials = length(condition);
%     active = zeros(1,ntrials);
%     active(conds_old<=4)=1;
% 
%     resp = cell(1,ntrials);
%     eq_corr = NaN*ones(1,ntrials);
%     for ti = 1:ntrials
%         resp{ti}=trials(ti).resp_b{end};
%         if isfield(trials(ti),'eq_corr')
%             eq_corr(ti)=trials(ti).eq_corr;
%         end
%     end
% 
%     resp_empty = find(cellfun(@isempty,resp));
%     for ti = 1:length(resp_empty)
%         resp{resp_empty(ti)}=NaN;
%     end
%     resp = [resp{:}];
% 
%     for ci = 1:numcats
%         events.categories(ci).name = newCatArray{ci};
%         events.categories(ci).categNum = ci;
% 
%         cat_ind = find(strcmp(oldCatArray,newCatArray{ci}));
%         if (~isempty(cat_ind))
%             trials_temp = find(condition == cat_ind);
%             events.categories(ci).numEvents = length(trials_temp);
%             events.categories(ci).start = events_old.onset(trials_temp,:);
%             events.categories(ci).stimNum = trials_temp;
% %             events.categories(ci).duration = events_old.RT(trials_temp);
%             events.categories(ci).eq_corr=eq_corr(trials_temp);
% %             events.categories(ci).sbj_resp = resp(trials_temp);
%             events.categories(ci).active = active(trials_temp);
%         else
%             trials_temp = [];
%             events.categories(ci).numEvents = 0;
%             events.categories(ci).start = [];
%             events.categories(ci).stimNum = [];
% %             events.categories(ci).duration = [];
%             events.categories(ci).eq_corr = [];
% %             events.categories(ci).sbj_resp = [];
%             events.categories(ci).active = [];
%         end
% 
%     end
% 
%     categNames = newCatArray;
%     new_events_fn = sprintf('%s/%s/%s/%s/events_%s.mat',results_root,task,sbj,block_name,block_name);
%     save(new_events_fn,'events','categNames')
% %     clear events trials
% end

 %% For Context- S12_45_LR,S13_53_KS2,S13_57_TVD
% clear;
% 
% sbj = 'S13_57_TVD';
% task = 'Context';
% 
% initialize_dirs;
% 
% BN = block_by_subj(sbj,task);
% 
% oldCatArray = {'NumWord1digitAdd','Num1digitAdd','one_word','one_num'};
% newCatArray  = {'Num1digitAdd','Num2digitAdd','Num2digitSub','LetterAdd','NumWord1digitAdd'};
% numcats = length(newCatArray);
% 
% for bi = 1:length(BN)
%     % for bi = 1
%     block_name = BN{bi};
%     psych_fn = get_psych_file(sbj,block_name);
%     load(sprintf('%s/%s/%s/%s/events_old_old_%s.mat',results_root,task,sbj,block_name,block_name))
%     load(sprintf('%s/%s/%s/%s',psych_root,sbj,block_name,psych_fn),'trials')
%     events_old = events;
%     clear events
% 
%     condition = [trials(:).cond];
%     ntrials = length(condition);
%     active = zeros(1,ntrials);
%     active(1)=trials(1).instr;
%     for ti = 2:ntrials
%         if (trials(ti).instr > 0)
%             active(ti) = trials(ti).instr;
%         else
%             active(ti) = active(ti-1);
%         end
%     end
%     active(active==2)=0;
% 
%     resp = cell(1,ntrials);
%     eq_corr = NaN*ones(1,ntrials);
%     for ti = 1:ntrials
%         resp{ti}=trials(ti).resp_b{end};
%         if isfield(trials(ti),'eq_corr')
%             eq_corr(ti)=trials(ti).eq_corr;
%         end
%     end
% 
%     resp_empty = find(cellfun(@isempty,resp));
%     for ti = 1:length(resp_empty)
%         resp{resp_empty(ti)}=NaN;
%     end
%     resp = [resp{:}];
% 
%     for ci = 1:numcats
%         events.categories(ci).name = newCatArray{ci};
%         events.categories(ci).categNum = ci;
% 
%         cat_ind = find(strcmp(oldCatArray,newCatArray{ci}));
%         if (~isempty(cat_ind))
%             trials_temp = find(condition == cat_ind);
%             events.categories(ci).numEvents = length(trials_temp);
%             events.categories(ci).start = events_old.onset(trials_temp,:);
%             events.categories(ci).stimNum = trials_temp;
%             %             events.categories(ci).duration = events_old.RT(trials_temp);
%             events.categories(ci).eq_corr=eq_corr(trials_temp);
%             %             events.categories(ci).sbj_resp = resp(trials_temp);
%             events.categories(ci).active = active(trials_temp);
%         else
%             trials_temp = [];
%             events.categories(ci).numEvents = 0;
%             events.categories(ci).start = [];
%             events.categories(ci).stimNum = [];
%             %             events.categories(ci).duration = [];
%             events.categories(ci).eq_corr = [];
%             %             events.categories(ci).sbj_resp = [];
%             events.categories(ci).active = [];
%         end
% 
%     end
% 
%     categNames = newCatArray;
%     new_events_fn = sprintf('%s/%s/%s/%s/events_Sep2017%s.mat',results_root,task,sbj,block_name,block_name);
%     save(new_events_fn,'events','categNames')
%     %     clear events trials
% end

%% For Context- S13_57_TVD
clear;

sbj = 'S13_57_TVD';
task = 'Context';

initialize_dirs;

BN = block_by_subj(sbj,task);

oldCatArray =  {'all_word','all_num','one_word','one_num'};
newCatArray =  {'all_word','all_num','one_word','one_num'};
% newCatArray  = {'Num1digitAdd','Num2digitAdd','Num2digitSub','LetterAdd','NumWord1digitAdd'};
numcats = length(newCatArray);

for bi = 1:length(BN)
    % for bi = 1
    block_name = BN{bi};
    psych_fn = get_psych_file(sbj,block_name);
    load(sprintf('%s/%s/%s/%s/events_old_old_%s.mat',results_root,task,sbj,block_name,block_name))
    load(sprintf('%s/%s/%s/%s',psych_root,sbj,block_name,psych_fn),'trials')
    events_old = events;
    clear events

    condition = [events_old.cond];
    ntrials = length(condition);
    active = events_old.task;
    active(active==2)=0;

    resp = nan(1,ntrials);
%     eq_corr = NaN*ones(1,ntrials);
    for ti = 1:ntrials
        resp_tmp = events_old.resp_b{ti};
        for i = 1:length(resp_tmp)
            if(~isempty(resp_tmp{i}))
                resp(ti)=str2num(resp_tmp{i});
            end
        end
    end
        
%         resp{ti}=trials(ti).resp_b{end};
%         if isfield(trials(ti),'eq_corr')
%             eq_corr(ti)=trials(ti).eq_corr;
%         end
%     end
% 
%     resp_empty = find(cellfun(@isempty,resp));
%     for ti = 1:length(resp_empty)
%         resp{resp_empty(ti)}=NaN;
%     end
%     resp = [resp{:}];

    for ci = 1:numcats
        events.categories(ci).name = newCatArray{ci};
        events.categories(ci).categNum = ci;

        cat_ind = find(strcmp(oldCatArray,newCatArray{ci}));
        if (~isempty(cat_ind))
            trials_temp = find(condition == cat_ind);
            events.categories(ci).numEvents = length(trials_temp);
            events.categories(ci).start = events_old.onset(trials_temp,:);
            events.categories(ci).stimNum = trials_temp;
            %             events.categories(ci).duration = events_old.RT(trials_temp);
            events.categories(ci).eq_corr=events_old.eq_corr(trials_temp);
            %             events.categories(ci).sbj_resp = resp(trials_temp);
            events.categories(ci).active = active(trials_temp);
        else
            trials_temp = [];
            events.categories(ci).numEvents = 0;
            events.categories(ci).start = [];
            events.categories(ci).stimNum = [];
            %             events.categories(ci).duration = [];
            events.categories(ci).eq_corr = [];
            %             events.categories(ci).sbj_resp = [];
            events.categories(ci).active = [];
        end

    end

    categNames = newCatArray;
    new_events_fn = sprintf('%s/%s/%s/%s/events_Sep2017%s.mat',results_root,task,sbj,block_name,block_name);
    save(new_events_fn,'events','categNames')
    %     clear events trials
end
%%
% Calculia
% clear;
% 
% sbj = 'S14_78_RS';
% task = 'calculia';
% 
% initialize_dirs;
% 
% BN = block_by_subj(sbj,task);
% 
% oldCatArray = {'Num1digitAdd','Num1digitAdd','LetterAdd','LetterAdd','Num2digitAdd','Num2digitAdd','Num2digitSub','Num2digitSub'};
% newCatArray  = {'Num1digitAdd','Num2digitAdd','Num2digitSub','LetterAdd','NumWord1digitAdd'};
% numcats = length(newCatArray);
% 
% for bi = 1:length(BN)
%     % for bi = 1
%     block_name = BN{bi};
% %     psych_fn = get_psych_file(sbj,block_name);
%     load(sprintf('%s/%s/%s/%s/events_old_%s.mat',results_root,task,sbj,block_name,block_name))
% %     load(sprintf('%s/%s/%s/%s',psych_root,sbj,block_name,psych_fn),'trials')
%     events_old = events;
%     clear events
% 
%     actpass = calculia_blocktype(sbj,BN{bi});
% 
%  for ci = 1:numcats
%     events.categories(ci).name = newCatArray{ci};
%     events.categories(ci).categNum = ci;
% 
%     cat_ind = find(strcmp(oldCatArray,newCatArray{ci}));
%     trials = [];
%     events.categories(ci).numEvents = 0;
%     events.categories(ci).start = [];
%     events.categories(ci).stimNum = [];
%     events.categories(ci).duration = [];
%     events.categories(ci).duration = [];
%     events.categories(ci).eq_corr = [];
%     events.categories(ci).active = [];
%     events.categories(ci).wlist = '';
%     if (~isempty(cat_ind))
%         for cii = 1:length(cat_ind)
%             cat = cat_ind(cii);
%             temp_name = events_old.categories(cat).name;
%             events.categories(ci).numEvents = events.categories(ci).numEvents+events_old.categories(cat).numEvents;
%             events.categories(ci).start = [events.categories(ci).start;  events_old.categories(cat).allonsets];
%             events.categories(ci).stimNum = [events.categories(ci).stimNum events_old.categories(cat).trialno(:)'];
%             events.categories(ci).duration = [events.categories(ci).duration events_old.categories(cat).stimdur];
%             events.categories(ci).wlist = [events.categories(ci).wlist events_old.categories(cat).wlist'];
%             events.categories(ci).active = [events.categories(ci).active actpass*ones(1,events_old.categories(cat).numEvents)];
%             if (isempty(strfind(temp_name,'incorr')))
%                 events.categories(ci).eq_corr = [events.categories(ci).eq_corr zeros(1,events_old.categories(cat).numEvents)];
%             else
%                events.categories(ci).eq_corr = [events.categories(ci).eq_corr ones(1,events_old.categories(cat).numEvents)];
%             end
%         end
%     end
% 
% end
% 
%     categNames = newCatArray;
%     new_events_fn = sprintf('%s/%s/%s/%s/events_%s.mat',results_root,task,sbj,block_name,block_name);
%     save(new_events_fn,'events','categNames')
%     %     clear events trials
% end

%%
% Calculia- S14_62_JW
% clear;
% 
% sbj = 'S14_62_JW';
% task = 'calculia';
% 
% initialize_dirs;
% 
% BN = block_by_subj(sbj,task);
% 
% oldCatArray = {'Num1digitAdd','Num1digitAdd','Num2digitAdd','Num2digitAdd','AddCorr','AddIncorr','Num2digitSub','Num2digitSub','LetterAdd','LetterAdd'};
% newCatArray  = {'Num1digitAdd','Num2digitAdd','Num2digitSub','LetterAdd','NumWord1digitAdd'};
% numcats = length(newCatArray);
% 
% for bi = 1:length(BN)
%     % for bi = 1
%     block_name = BN{bi};
% %     psych_fn = get_psych_file(sbj,block_name);
%     load(sprintf('%s/%s/%s/%s/events_old_%s.mat',results_root,task,sbj,block_name,block_name))
% %     load(sprintf('%s/%s/%s/%s',psych_root,sbj,block_name,psych_fn),'trials')
%     events_old = events;
%     clear events
% 
%     actpass = calculia_blocktype(sbj,BN{bi});
% 
%  for ci = 1:numcats
%     events.categories(ci).name = newCatArray{ci};
%     events.categories(ci).categNum = ci;
% 
%     cat_ind = find(strcmp(oldCatArray,newCatArray{ci}));
%     trials = [];
%     events.categories(ci).numEvents = 0;
%     events.categories(ci).start = [];
%     events.categories(ci).stimNum = [];
%     events.categories(ci).duration = [];
%     events.categories(ci).duration = [];
%     events.categories(ci).eq_corr = [];
%     events.categories(ci).active = [];
% %     events.categories(ci).wlist = '';
%     if (~isempty(cat_ind))
%         for cii = 1:length(cat_ind)
%             cat = cat_ind(cii);
%             temp_name = events_old.categories(cat).name;
%             events.categories(ci).numEvents = events.categories(ci).numEvents+events_old.categories(cat).numEvents;
%             events.categories(ci).start = [events.categories(ci).start;  events_old.categories(cat).allonsets];
%             events.categories(ci).stimNum = [events.categories(ci).stimNum events_old.categories(cat).trialno(:)'];
%             events.categories(ci).duration = [events.categories(ci).duration events_old.categories(cat).stimdur];
% %             events.categories(ci).wlist = [events.categories(ci).wlist events_old.categories(cat).wlist'];
%             events.categories(ci).active = [events.categories(ci).active actpass*ones(1,events_old.categories(cat).numEvents)];
%             if (isempty(strfind(temp_name,'incorr')))
%                 events.categories(ci).eq_corr = [events.categories(ci).eq_corr zeros(1,events_old.categories(cat).numEvents)];
%             else
%                events.categories(ci).eq_corr = [events.categories(ci).eq_corr ones(1,events_old.categories(cat).numEvents)];
%             end
%         end
%     end
% 
% end
% 
%     categNames = newCatArray;
%     new_events_fn = sprintf('%s/%s/%s/%s/events_%s.mat',results_root,task,sbj,block_name,block_name);
%     save(new_events_fn,'events','categNames')
%     %     clear events trials
% end

%% UCLA
clear;

sbj = 'S10_18_JBXa';
task = 'UCLA';

initialize_dirs;

BN = block_by_subj(sbj,task);

oldCatArray  = {'self-internal','internal-other','other','self-external','external-other','external-dis-other','math','autobio','rest'};
newCatArray = {'self-internal','other','self-external','autobio','math','rest'};
numcats = length(newCatArray);

for bi = 1:length(BN)
    block_name = BN{bi};
    load(sprintf('%s/%s/%s/%s/events_old_%s.mat',results_root,task,sbj,block_name,block_name))
    events_old = events;
    clear events
    
    for ci = 1:numcats
        events.categories(ci).name = newCatArray{ci};
        events.categories(ci).categNum = ci;
        
        cat_ind = find(strcmp(oldCatArray,newCatArray{ci}));
        trials = [];
        events.categories(ci).numEvents = 0;
        events.categories(ci).start = [];
        events.categories(ci).stimNum = [];
        events.categories(ci).duration = [];
        events.categories(ci).correct = [];
        events.categories(ci).sbj_resp = [];
        events.categories(ci).RT = [];
        events.categories(ci).wlist = '';
        if (~isempty(cat_ind))
            for cii = 1:length(cat_ind)
                cat = cat_ind(cii);
                temp_name = events_old.categories(cat).name;
                events.categories(ci).numEvents = events.categories(ci).numEvents+events_old.categories(cat).numEvents;
                events.categories(ci).start = [events.categories(ci).start  events_old.categories(cat).start];
                events.categories(ci).stimNum = [events.categories(ci).stimNum events_old.categories(cat).stimNum(:)'];
                events.categories(ci).duration = [events.categories(ci).duration events_old.categories(cat).duration];
                events.categories(ci).correct = [events.categories(ci).correct events_old.categories(cat).correct];
                events.categories(ci).sbj_resp = [events.categories(ci).sbj_resp events_old.categories(cat).sbj_resp];
                events.categories(ci).RT = [events.categories(ci).RT events_old.categories(cat).RT];
                events.categories(ci).wlist = [events.categories(ci).wlist events_old.categories(cat).wlist'];
            end
        end
        
    end
    
    categNames = newCatArray;
    new_events_fn = sprintf('%s/%s/%s/%s/events_%s.mat',results_root,task,sbj,block_name,block_name);
    save(new_events_fn,'events','categNames')
    %     clear events trials
end

%%
% for Logo
% 
% events_old = events;
% clear events
% 
% % old category order
% % categNames = {'foreign','letter','nonnumword','num_eqn','numword','number','scramble-letter','scramble-number','sentence','sym_eqn','text_eqn'};
% categNames = {'company_logo','company_logo','foreign','letter','meaningful_logo','num_sym','number','word_sym'};
% % categNames = {'letter','number','scramble-letter','scramble-number','foreign'};
% % new category order
% newCatArray =  {'company_logo','foreign','letter','meaningful_logo','num_sym','number','word_sym'};
% numcats = length(newCatArray);
% 
% for ci = 1:numcats
%     events.categories(ci).name = newCatArray{ci};
%     events.categories(ci).categNum = ci;
% 
%     cat_ind = find(strcmp(categNames,newCatArray{ci}));
%     if (~isempty(cat_ind))
%         trials = find(ismember(events_old.conds,cat_ind));
%         events.categories(ci).numEvents = length(trials);
%         events.categories(ci).start = events_old.start(trials);
%         events.categories(ci).duration = events_old.duration(trials);
%         events.categories(ci).stimNum = trials;
%         events.categories(ci).wlist = events_old.stimFile(trials);
%         events.categories(ci).RT = events_old.RT(trials);
%         events.categories(ci).sbj_resp = events_old.sbj_resp(trials);
%         %     events.categories(ci).correct = events_old.correct(trials);
%     else
%         trials = [];
%         events.categories(ci).numEvents = 0;
%         events.categories(ci).start = [];
%         events.categories(ci).duration = [];
%         events.categories(ci).stimNum = [];
%         events.categories(ci).wlist = {};
%         events.categories(ci).RT = [];
%         events.categories(ci).sbj_resp = {};
%         %     events.categories(ci).correct = events_old.correct(trials);
%     end
% 
% end
% 
% categNames = newCatArray;
