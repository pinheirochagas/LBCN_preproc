clear all; close all; clc;

%% Globar Variable elements
sbj_name= 'S13_57_TVD';
project_name= 'Context';
block_name= 'TVD_26';
% block_type = 'active'; %'passive' or 'active'

initialize_dirs;

load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',data_root,sbj_name,project_name,sbj_name,block_name));
globalVar.psych_dir = sprintf('%s/analysis_ECOG/psychData/%s/%s',comp_root,sbj_name,block_name);

iEEG_rate=globalVar.iEEG_rate;

%% Reading PsychData BAHAVIORAL DATA

load(sprintf('%s/TVD_dv3_5_all.mat',globalVar.psych_dir));

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


%% reading analog channel from neuralData directory
load(sprintf('%s/Pdio%s_02.mat',globalVar.data_dir,block_name));

%% varout is anlg (single percision)
downRatio= round(globalVar.Pdio_rate/iEEG_rate);
pdio= decimate(double(anlg),downRatio); % down sample to the iEEG rate
pdio = pdio/max(pdio);
clear anlg

%% Thresholding the signal
ind_above= pdio >0.5;
ind_df= diff(ind_above);
clear ind_above
onset= find(ind_df==1);
offset= find(ind_df==-1);
clear ind_df
pdio_onset= onset/iEEG_rate;
pdio_offset= offset/iEEG_rate;
% %remove onset flash
% 
pdio_onset(1:12)=[];
pdio_offset(1:12)=[];

%get osnets from diode
pdio_dur= pdio_offset - pdio_onset;
IpdioI= [pdio_onset(2:end)- pdio_offset(1:end-1) 0];
isi_ind = find(IpdioI > 0.05);

stim_offset= [pdio_offset(isi_ind) pdio_offset(end)];
stim_onset= [pdio_onset(isi_ind) pdio_onset(end)];

stim_dur= stim_offset - stim_onset;

%Ploting to check marks for STIM
marks_on= 0.6*ones(1,length(stim_onset));
marks_off= 0.4*ones(1,length(stim_offset));
figure, plot(pdio),hold on,
plot(stim_onset*iEEG_rate,marks_on,'r*');hold on
plot(stim_offset*iEEG_rate,marks_off,'g*');


return
%%
%Get trials, insturuction onsets
instruct_onset = stim_onset(1:5*6+1:end); %KS2_24 26 28 29: stim_onset(1:5*4+1:end)  KS2_25 KS2_27: stim_onset(1:5*4+1:end)
%remove instruction onsets
stim_onset_noInstruct = stim_onset;
stim_onset_noInstruct(1:5*6+1:end) = []; %KS2_24 26 28 29: stim_onset(1:5*4+1:end)  KS2_25 KS2_27: stim_onset(1:5*4+1:end)
%get each stim onset (5 stim per trial)
stim_onset_first = stim_onset_noInstruct(1:5:end);%(1:5:end)
stim_onset_second = stim_onset_noInstruct(2:5:end);
stim_onset_third = stim_onset_noInstruct(3:5:end);
stim_onset_fourth = stim_onset_noInstruct(4:5:end);
stim_onset_fifth = stim_onset_noInstruct(5:5:end);

%check with plot (instruction and stim onsets)
marks_on= 0.7*ones(1,length(instruct_onset));
marks_first= 0.6*ones(1,length(stim_onset_first));
marks_second= 0.5*ones(1,length(stim_onset_second));
marks_third= 0.4*ones(1,length(stim_onset_third));
marks_fourth= 0.3*ones(1,length(stim_onset_fourth));
marks_fifth= 0.2*ones(1,length(stim_onset_fifth));

%plot each presentation in trial
figure, plot(pdio,'k'),hold on, 
plot(instruct_onset*iEEG_rate,marks_on,'r*');hold on
plot(stim_onset_first*iEEG_rate,marks_first,'b*');
plot(stim_onset_second*iEEG_rate,marks_second,'y*');
plot(stim_onset_third*iEEG_rate,marks_third,'c*');
plot(stim_onset_fourth*iEEG_rate,marks_fourth,'m*');
plot(stim_onset_fifth*iEEG_rate,marks_fifth,'g*');

%group all, rearrange for trials (trials as rows, with 5 stimuli as columns)
all_stim_onset = [];
for ti = 1:length(trials); 
    all_stim_onset(ti,1) = stim_onset_first(ti); 
    all_stim_onset(ti,2) = stim_onset_second(ti); 
    all_stim_onset(ti,3) = stim_onset_third(ti); 
    all_stim_onset(ti,4) = stim_onset_fourth(ti);  
    all_stim_onset(ti,5) = stim_onset_fifth(ti);  
end

%% Start-end experiment times
%add 500ms either side to avoid window errors during epoching later on
globalVar.exp_start_point = stim_onset(1)-0.5; %-500ms
globalVar.exp_end_point = stim_offset(end)+0.5; %+500ms

%save updated globals
fn=sprintf('%s/originalData/%s/global_%s_%s_%s.mat',data_root,sbj_name,project_name,sbj_name,block_name);
save(fn,'globalVar');
close all
return

%% Comparing photodiod with behavioral data
%for just the first stimulus of each trial
% pdio([1:5 47:50 57:59 66:71 78:88 120])=NaN; % OD 05
% SOT([9:18 20 22 23 25:31 38:41 48])=[]; % OD 05
% K.conds([9:18 20 22 23 25:31 38:41 48])=[];

df_SOT= diff(SOT);
df_stim_onset= diff(stim_onset_fifth); %fifth? why?
ngoodtrials = length(stim_onset_fifth);
%plot overlay
figure, plot(df_SOT(1:ngoodtrials-1),'o','MarkerSize',8,'LineWidth',3),hold on, plot(df_stim_onset(1:ngoodtrials-1),'r*')
df= df_SOT(1:ngoodtrials-1) - df_stim_onset(1:ngoodtrials-1);

%plot diffs, across experiment and histogram
figure
subplot(1,2,1)
plot(df), ylim([-.05 .05]);
title('Diff. behavior diode (exp)');
xlabel('Trial number');
ylabel('Time (s)');
subplot(1,2,2)
hist(df), xlim([-.05 .05])
title('Diff. behavior diode (hist)');
xlabel('Time (s)');
ylabel('Count');

%flag large difference
if ~all(abs(df)<.1)
    disp('behavioral data and photodiod mismatch'),return
end

return

%%

%group all, rearrange for trials (trials as rows, with 5 stimuli as columns)
% lsi=23;
all_stim_onset = [];
for ti = 1:ngoodtrials; %23 for OD5, lsi for others
    all_stim_onset(ti,1) = stim_onset_first(ti);
    all_stim_onset(ti,2) = stim_onset_second(ti);
    all_stim_onset(ti,3) = stim_onset_third(ti);
    all_stim_onset(ti,4) = stim_onset_fourth(ti);
    all_stim_onset(ti,5) = stim_onset_fifth(ti);
end

return
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
    ind = intersect(ind,1:ngoodtrials);
    events.categories(ci).numEvents= length(ind);
    events.categories(ci).trialno= ind;
    events.categories(ci).allonsets=all_stim_onset(ind,:);
    events.categories(ci).wlist={wlist(ind)};
    events.categories(ci).active = task(ind)==1;
    events.categories(ci).eq_corr = eq_corr(ind);
%     events.categories(ci).wlistMemo=wlistMemo(ind);
%     events.categories(ci).wlistInfo=wlistInfo(ind);
    events.categories(ci).sbj_resp= sbj_resp(ind);
    events.categories(ci).RT = RT(ind);
    temp_accuracy = sbj_resp(ind)==eq_corr(ind);
    events.categories(ci).accuracy= temp_accuracy(task(ind)==1);
    
    ind=(((ind-1)*5)+1);
    events.categories(ci).firststimno= ind;
    events.categories(ci).onsets= stim_onset(ind);
    events.categories(ci).stimdur= (stim_offset(ind+4)-stim_onset(ind));
end


%% making a saving directory

fn= sprintf('%s/%s/%s/%s/events_Sep27_%s.mat',results_root,project_name,sbj_name,block_name,block_name);
save(fn,'events');

