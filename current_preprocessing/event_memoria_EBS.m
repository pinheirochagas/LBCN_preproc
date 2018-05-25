clear all; close all; clc;

%% Globar Variable elements
sbj_name= 'S17_107_JQ';
% project_name= 'Memoria_EBS';
project_name = 'Memoria_EBS';
block_name= 'E17-152_0040';

initialize_dirs;
% load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',data_root,sbj_name,project_name,sbj_name,block_name));
globalVar.psych_dir = sprintf('%s/analysis_ECoG/psychData/%s/%s',comp_root,sbj_name,block_name);
% sbj_name= globalVar.sbj_name;


% iEEG_rate=globalVar.iEEG_rate;
iEEG_rate = 1000;
globalVar.Pdio_rate = 10000;

%% Reading PsychData BAHAVIORAL DATA

K= load(sprintf('%s/sodata.S17_107_JQ_EBS_math.28.02.2017.11.23.mat',globalVar.psych_dir)); 

lsi= length(K.theData);

SOT= zeros(1,lsi);
sbj_resp= NaN*ones(1,lsi);
RT = [K.theData.RT];
for si= 1:lsi %
    SOT(si)= K.theData(si).flip.StimulusOnsetTime;
    if ~isnan(str2num(K.theData(si).keys))
       sbj_resp(si)= str2num(K.theData(si).keys(1));
    else
       sbj_resp(si)= NaN;
    end
end
%
%return
%% reading analog channel from neuralData directory
load(sprintf('%s/OriginalData/%s/%s/Pdio%s_01.mat',data_root,sbj_name,block_name,block_name));

%% varout is anlg (single percision)
downRatio= round(globalVar.Pdio_rate/iEEG_rate); 
pdio= decimate(double(anlg),downRatio); % down sample to the iEEG rate
clear anlg

if (abs(min(pdio))>max(pdio))
    peak = min(pdio);
else
    peak = max(pdio);
end
% pdio = pdio/peak;
pdio = (pdio-min(pdio))/(max(pdio)-min(pdio));
pdio = 1-pdio;


%% Thresholding the signal
ind_above= pdio > 0.5;
ind_df= diff(ind_above);
% clear ind_above
onset= find(ind_df==1);
offset= find(ind_df==-1);
% clear ind_df
pdio_onset= onset/iEEG_rate;
pdio_offset= offset/iEEG_rate;

% %remove onset flash

pdio_onset(1:9)=[]; % 
pdio_offset(1:9)=[]; % 
pdio_onset(end)=[];

% pdio_onset(end-1:end) = []; %block 18,22,24
% pdio_offset(end-1:end) = []; %block 18,22,24

%get osnets from diode
pdio_dur= pdio_offset - pdio_onset;
IpdioI= [pdio_onset(2:end)-pdio_offset(1:end-1) 0];
isi_ind = find(IpdioI > 0.1);

stim_offset= [pdio_offset(isi_ind) pdio_offset(end)];
stim_onset= [pdio_onset(isi_ind) pdio_onset(end)];

% stim_onset = [stim_onset(1:20) NaN stim_onset(21:end)];
% stim_offset = [stim_offset(1:20) NaN stim_offset(21:end)];

stim_onset = [NaN*ones(1,9) stim_onset(1:198) NaN stim_onset(199:201) stim_onset(202:end)];
stim_offset = [NaN*ones(1,9) stim_offset(1:198) NaN stim_offset(199:201) stim_offset(202:end)];

stim_dur= stim_offset - stim_onset;

%Ploting to check marks for STIM
marks_on= 0.5*ones(1,length(stim_onset));
marks_off= 0.4*ones(1,length(stim_offset));
figure, plot(pdio),hold on, 
plot(stim_onset*iEEG_rate,marks_on,'r*');hold on
plot(stim_offset*iEEG_rate,marks_off,'g*');


return
%%
%Get trials, insturuction onsets
all_stim_onset = NaN*ones(lsi,3);
rest_onset = [];
rest_offset = [];

counter = 1;
for ti = 1:lsi
    end_counter = min(counter+2,length(stim_onset));
    numinds = end_counter-counter+1;
    all_stim_onset(ti,1:numinds)=stim_onset(counter:counter+numinds-1);
    counter = counter + 3;
end


%plot each presentation in trial
figure, plot(pdio,'k'),hold on, 

plot(all_stim_onset(:,1)*iEEG_rate,0.9*ones(lsi,1),'b*');
plot(all_stim_onset(:,2)*iEEG_rate,0.7*ones(lsi,1),'y*');
plot(all_stim_onset(:,3)*iEEG_rate,0.5*ones(lsi,1),'c*');
% plot(all_stim_onset(:,4)*iEEG_rate,0.3*ones(lsi,1),'m*');
% plot(all_stim_onset(:,5)*iEEG_rate,0.1*ones(lsi,1),'g*');

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
% df_stim_onset= diff(stim_onset_fifth); %fifth? why?
df_stim_onset = diff(all_stim_onset(:,1))';
%plot overlay
figure, plot(df_SOT,'o','MarkerSize',8,'LineWidth',3),hold on, plot(df_stim_onset,'r*')
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

%% events and categories from psychtoolbox information

% categNames1 = {'Math_speak','Math_imagine'};
categNames1 = {'Math'};
% stim=0: speak; stim=1: imagine
% conds2 = ones(1,lsi);
conds2 = K.stim+1;

%%

for ti = 1:lsi
    subj_resp(ti) = K.theData(ti).keys(1);
end

for ci=1:length(categNames1)
    cat = categNames1(ci);
    events.categories(ci).name= sprintf('%s',categNames1{ci});
    events.categories(ci).categNum= ci;
    inds = find(conds2==ci);
    inds = 1:length(K.wlist);
    events.categories(ci).numEvents= length(inds);
    events.categories(ci).start= all_stim_onset(inds,1);
    events.categories(ci).allonset= all_stim_onset(inds,:);
    events.categories(ci).stimNum= inds;
    events.categories(ci).wlist= K.wlist(inds);
    events.categories(ci).RT= RT(inds);
    events.categories(ci).sbj_resp= sbj_resp(inds);
    events.categories(ci).duration = ((events.categories(ci).allonset(:,3)-events.categories(ci).allonset(:,1))'+events.categories(ci).RT)';
    events.categories(ci).stim = K.stim;
    events.categories(ci).decadecross = K.stiminfo;
end

categNames = categNames1;

%% Comparing reaction times to stimuli durations
% df= abs(stim_dur - rt);
% if ~all(abs(df)<.2)
%    disp('Reaction times and photodiod mismatch\n'),
%    fprintf('trials did not match:\n %d\n',find(abs(df)>.2))
%    return
% end

%% making a saving directory

fn= sprintf('%s/%s/%s/%s/events_%s.mat',results_root,project_name,sbj_name,block_name,block_name);
save(fn,'events','categNames');

