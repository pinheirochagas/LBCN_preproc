clear all; close all; clc;

%% Globar Variable elements
sbj_name= 'S12_41_KS';
project_name= 'Context';
block_name= 'KS_30';
% block_type = 'active'; %'passive' or 'active'

initialize_dirs;

load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',data_root,sbj_name,project_name,sbj_name,block_name));
globalVar.psych_dir = sprintf('%s/analysis_ECOG/psychData/%s/%s',comp_root,sbj_name,block_name);

iEEG_rate=globalVar.iEEG_rate;

%% Reading PsychData BAHAVIORAL DATA

load(sprintf('%s/73512542421_KS_6_all.mat',globalVar.psych_dir));

lsi= length(trials);
SOT= NaN*ones(1,lsi);
sbj_resp= NaN*ones(1,lsi);
RT = NaN*ones(1,lsi);
task = NaN*ones(1,lsi);
eq_corr = NaN*ones(1,lsi);
start_time=trials(1).instr_time(1);

%just get onset of first stimulus onset for each trial (#1 of 5, for each trial)
for si= 1:lsi
    SOT(si)= trials(1,si).time(1);
    temp_rsp = {trials(si).resp_b{9:end}};
    temp_rt = {trials(si).resp_t{9:end}};
    pressed = find(~cellfun(@isempty,temp_rsp),1);
    if isfield(trials(si),'eq_corr')
        eq_corr(si) = trials(si).eq_corr;
    else
        eq_corr(si) = context_get_eqn(trials(si).problem);
    end
    if (~isempty(pressed))
        sbj_resp(si)=str2num(temp_rsp{pressed});
        RT(si)=temp_rt{pressed}-trials(si).time(9);
    end
    if trials(si).instr == 1;
        task(si) = 1;
    else if trials(si).instr ==2;
            task(si) = 2;
        else
            task(si) = task(si-1);
        end
    end

end

eq_corr(eq_corr==0)=2;

% SOT = SOT(goodbehavtrials);
% sbj_resp = sbj_resp(goodbehavtrials);
% RT = RT(goodbehavtrials);



%% events and categories from psychtoolbox information

%condition names
% categNames= {'easy_add_corr','easy_add_incorr'...
%     'letter_add_corr','letter_add_incorr'...
%     'hard_add_corr','hard_add_incorr'...
%     'hard_sub_corr','hard_sub_incorr'};

categNames= {'all_num','all_word','one_word','one_num'};


% cond= [K.conds]';
cond = [trials(:).cond];
wlist = {trials(:).problem};

% cond=cond(goodbehavtrials);

stimNum= lsi;
events=[];

for ci=1:length(categNames)
    events.categories(ci).name= sprintf('%s',categNames{ci});
    events.categories(ci).categNum= ci;
    ind=find(cond==ci);
%     ind = intersect(ind,1:ngoodtrials);
    events.categories(ci).numEvents= length(ind);
    events.categories(ci).trialno= ind;
%     events.categories(ci).allonsets=all_stim_onset(ind,:);
    events.categories(ci).wlist={wlist(ind)};
    events.categories(ci).active = task(ind)==1;
%     events.categories(ci).active = task(ind)==2;
    events.categories(ci).eq_corr = eq_corr(ind);
%     events.categories(ci).wlistMemo=wlistMemo(ind);
%     events.categories(ci).wlistInfo=wlistInfo(ind);
    events.categories(ci).sbj_resp= sbj_resp(ind);
    events.categories(ci).RT = RT(ind);
    temp_accuracy = sbj_resp(ind)==eq_corr(ind);
    events.categories(ci).accuracy= temp_accuracy(task(ind)==1);
    
    ind=(((ind-1)*5)+1);
%     events.categories(ci).firststimno= ind;
%     events.categories(ci).onsets= stim_onset(ind);
%     events.categories(ci).stimdur= (stim_offset(ind+4)-stim_onset(ind));
end


%% making a saving directory

fn= sprintf('%s/%s/%s/%s/events_old_%s.mat',results_root,project_name,sbj_name,block_name,block_name);
save(fn,'events');

