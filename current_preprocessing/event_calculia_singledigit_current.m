clear all; close all; clc;

%% Globar Variable elements
sbj_name= 'S16_94_DR';
project_name= 'calculia';
block_name= 'E16-168_0039';
block_type = 'active'; %'passive' or 'active'

initialize_dirs;

ISI = 0.8;
% num_goodtrials = 64; %only use if last trials are bad
goodtrials = [1:36,49:64];

load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',data_root,sbj_name,project_name,sbj_name,block_name));
globalVar.psych_dir = sprintf('%s/analysis_ECOG/psychData/%s/%s',comp_root,sbj_name,block_name);

iEEG_rate=globalVar.iEEG_rate;

%% Reading PsychData BAHAVIORAL DATA

% K= load(sprintf('%s/sodata.S16_94_DR.22.02.2016.16.21.mat',globalVar.psych_dir)); % E16-168_0020
% K= load(sprintf('%s/sodata.S16_94_DR.22.02.2016.16.31.mat',globalVar.psych_dir)); % E16-168_0021
% K= load(sprintf('%s/sodata.S16_94_DR.22.02.2016.16.43.mat',globalVar.psych_dir)); % E16-168_0022
% K= load(sprintf('%s/sodata.S16_94_DR.22.02.2016.18.35.mat',globalVar.psych_dir)); % E16-168_0023
K= load(sprintf('%s/sodata.S16_94_DR_39.24.02.2016.15.51.mat',globalVar.psych_dir)); % E16-168_0039

lsi= length(K.theData);

SOT= NaN*ones(1,lsi);
sbj_resp= NaN*ones(1,lsi);

for si= 1:lsi; %****
    if (~isempty(K.theData(si).flip))
        SOT(si)= K.theData(si).flip.StimulusOnsetTime;
        if K.theData(1,2).info.isActive==1;
            if ~isnan(str2num(K.theData(si).keys))
                sbj_resp(si)= str2num(K.theData(si).keys);
            else
                sbj_resp(si)= NaN;
            end
        end
    end
end
%
%return
%% reading analog channel from neuralData directory
load(sprintf('%s/Pdio%s_01.mat',globalVar.data_dir,block_name));

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
% pdio_onset([1:12 end])=[]; %%block 21
% pdio_offset([1:13 end])=[];

% pdio_onset([1:5])=[]; %%block 22
% pdio_offset([1:5])=[];

%get osnets from diode
pdio_dur= pdio_offset - pdio_onset;
IpdioI= [pdio_onset(2:end)-pdio_offset(1:end-1) 0];
isi_ind = find(IpdioI > 0.2);

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

%get each stim onset (5 stim per trial)
stim_onset_first = stim_onset(1:5:end);%(1:5:end)
stim_onset_second = stim_onset(2:5:end);
stim_onset_third = stim_onset(3:5:end);
stim_onset_fourth = stim_onset(4:5:end);
stim_onset_fifth = stim_onset(5:5:end);

%check with plot (instruction and stim onsets),
marks_first= 0.9*ones(1,length(stim_onset_first));
marks_second= 0.8*ones(1,length(stim_onset_second));
marks_third= 0.7*ones(1,length(stim_onset_third));
marks_fourth= 0.6*ones(1,length(stim_onset_fourth));
marks_fifth= 0.5*ones(1,length(stim_onset_fifth));

%plot each presentation in trial
figure, plot(pdio,'k'),hold on, 

plot(stim_onset_first*iEEG_rate,marks_first,'b*');
plot(stim_onset_second*iEEG_rate,marks_second,'y*');
plot(stim_onset_third*iEEG_rate,marks_third,'c*');
plot(stim_onset_fourth*iEEG_rate,marks_fourth,'m*');
plot(stim_onset_fifth*iEEG_rate,marks_fifth,'g*');

return

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

df_SOT= diff(SOT);
df_stim_onset= diff(stim_onset_fifth); %fifth? why?
%plot overlay
figure, plot(df_SOT(goodtrials(1:end-1)),'o','MarkerSize',8,'LineWidth',3),hold on, plot(df_stim_onset(goodtrials(1:end-1)),'r*')
df= df_SOT - df_stim_onset;

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
for ti = 1:length(goodtrials) %23 for OD5, lsi for others
    temp_trial = goodtrials(ti);
    all_stim_onset(ti,1) = stim_onset_first(temp_trial); 
    all_stim_onset(ti,2) = stim_onset_second(temp_trial); 
    all_stim_onset(ti,3) = stim_onset_third(temp_trial); 
    all_stim_onset(ti,4) = stim_onset_fourth(temp_trial);  
    all_stim_onset(ti,5) = stim_onset_fifth(temp_trial);  

%     all_stim_onset(ti,1) = stim_onset_first(ti); 
%     all_stim_onset(ti,2) = stim_onset_first(ti)+ ISI; 
%     all_stim_onset(ti,3) = stim_onset_first(ti)+ 2*ISI; 
%     all_stim_onset(ti,4) = stim_onset_first(ti)+ 3*ISI;  
%     all_stim_onset(ti,5) = stim_onset_first(ti)+ 4*ISI;  
end

return
%% events and categories from psychtoolbox information

% Conditions:			
% 1 : Add correct
% 2 : Add incorrect
% 3 : Sub correct
% 4 : Sub incorrect

%condition names
categNames= {'add_corr','add_incorr','sub_corr','sub_incorr'};

%%
wlist= K.wlist;
wlistMemo=K.wlistMemo;
wlistInfo=K.wlistInfo;

cond= [K.conds]';

cond=cond(goodtrials);
rt= NaN*ones(1,length(goodtrials));


%return
if K.theData(1,2).info.isActive==1;
    for ii=1:length(goodtrials)
        temp_trial = goodtrials(ii);
        rt(ii)=K.theData(temp_trial).RT;
    end
elseif K.theData(1,2).info.isActive==0;
    for ii=1:length(goodtrials)
        temp_trial = goodtrials(ii);
        for tt=1:2;
            rt(tt,ii)=K.theData(temp_trial).RT(tt);
        end
    end
end

stimNum= lsi;
events=[];

for ci=1:length(categNames)
        events.categories(ci).name= sprintf('%s',categNames{ci});
        events.categories(ci).categNum= ci;
        ind=find(cond==ci);
            
             events.categories(ci).numEvents= length(ind);
             events.categories(ci).trialno= ind;
             events.categories(ci).start=all_stim_onset(ind,:);
             events.categories(ci).wlist=wlist(ind);
             events.categories(ci).wlistMemo=wlistMemo(ind);
             events.categories(ci).wlistInfo=wlistInfo(ind);
             events.categories(ci).sbj_resp= sbj_resp(find(cond==ci));
             clear acc % accuracy
                 if (strcmp(block_type,'passive')) %passive runs
                     if ci==1 || ci==2 || ci==3 || ci==4;
                         accuracy=ones(1,8);
                     elseif ci==5 || ci==6 || ci==7 || ci==8;
                         accuracy=ones(1,4);
                     end
                 elseif (strcmp(block_type,'active'))
                     if ci==1 || ci==2 || ci==3 || ci==4;
                         accuracy=zeros(1,8);
                     elseif ci==5 || ci==6 || ci==7 || ci==8;
                         accuracy=zeros(1,4);
                     end
                     if ci==1 || ci==3 || ci==5 || ci==7;
                         acc=find(events.categories(ci).sbj_resp==1);
                         accuracy(acc)=1;
                     elseif ci==2 || ci==4 || ci==6 || ci==8
                         acc=find(events.categories(ci).sbj_resp==2);
                         accuracy(acc)=1;
                     end
                 end
                     events.categories(ci).accuracy= accuracy;
                     
             ind=(((ind-1)*5)+1);
             events.categories(ci).firststimno= ind;
             events.categories(ci).onsets= stim_onset(ind);
             events.categories(ci).stimdur= (stim_offset(ind+4)-stim_onset(ind));


end

%


%% Comparing reaction times to stimuli durations
% df= abs(stim_dur - rt);
% if ~all(abs(df)<.2)
%    disp('Reaction times and photodiod mismatch\n'),
%    fprintf('trials did not match:\n %d\n',find(abs(df)>.2))
%    return
% end

%% making a saving directory

fn= sprintf('%s/events_%s.mat',globalVar.result_dir,block_name);
save(fn,'events')

