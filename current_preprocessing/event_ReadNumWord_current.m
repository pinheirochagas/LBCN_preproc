clear all; close all; clc;

% Globar Variable elements
block_name= 'E17-107_0043';
sbj_name= 'S17_106';
project_name= 'ReadNumWord_EBS';

initialize_dirs;
% comp_root = sprintf('/Users/parvizilab/Desktop/Math Project'); % location of analysis_ECOG folder
% data_root= sprintf('%s/analysis_ECOG/neuralData',comp_root);
load(sprintf('%s/OriginalData/%s/global_%s_%s_%s.mat',data_root,sbj_name,project_name,sbj_name,block_name));

iEEG_rate=globalVar.iEEG_rate;
pdio_rate = globalVar.Pdio_rate;

%% Reading PsychData BEHAVIORAL DATA

K= load(sprintf('%s/sodata.S17_106_SD_LPT10-3.15.02.2017.11.46.mat',globalVar.psych_dir)); % KB

% return


%%
lsi= length(K.theData);
%SOT= zeros(1,lsi);

% sbj_resp= NaN*ones(1,lsi);
% for aa = [54:60]
%     K.theData(1,aa).keys = 'noanswer';
%     K.theData(1,aa).RT = '0';
%     K.theData(aa).flip.StimulusOnsetTime=NaN;
% end
for si= 1:lsi
    SOT(1,si)= K.theData(si).flip.StimulusOnsetTime; %stimulus onset
    % SOT(2,si)= K.theData(si).flip.StimulusOnsetTime+K.theData(si).RT(1);
end
df_SOT= diff(SOT);

%% reading analog channel from neuralData directory
load(sprintf('%s/Pdio%s_04.mat',globalVar.data_dir,block_name));
% load('/Users/parvizilab/Desktop/Math Project/analysis_ECOG/neuralData/OriginalData/S14_66_CZ/S14_66_CZ_12/PdioS14_66_CZ_12_02.mat');

%% varout is anlg (single percision)
downRatio= round(globalVar.Pdio_rate/iEEG_rate); 
pdio= decimate(double(anlg),downRatio); % down sample to the iEEG rate
% pdio = pdio/max(pdio);
pdio = (pdio-min(pdio))/(max(pdio)-min(pdio));
clear anlg

%Ploting to check marks
%  t= (1:length(pdio))/iEEG_rate;
%  figure,plot(t,pdio);
%  return

%% Thresholding the signal
%pdio = pdio(14*iEEG_rate:end); %To chop diode so offset is correct
%t = 1:length(pdio);
ind_above= pdio >0.3;
ind_df= diff(ind_above);
clear ind_above
onset= find(ind_df==1);
offset= find(ind_df==-1);
clear ind_df
pdio_onset= onset/iEEG_rate;
pdio_offset= offset/iEEG_rate;
% pdio_onset= onset/pdio_rate;
% pdio_offset= offset/pdio_rate;
% pdio_onset(end)=[];
pdio_dur= pdio_offset - pdio_onset;
IpdioI= [pdio_onset(2:end)-pdio_offset(1:end-1) 0];

stim_ind= find(pdio_dur>.01);
stim_ind(1:12)=[]; %to skip misc. diode MMR1:stim_ind(1:7)=[];
% stim_ind(end)=[];
stim_onset= pdio_onset(stim_ind);
rsp_onset= pdio_offset(stim_ind);

bad_isi = find(stim_onset(2:end)-rsp_onset(1:end-1)<.2);

stim_onset(bad_isi+1)=[];
rsp_onset(bad_isi)= [];

% stim_onset = stim_onset(1:end-1);

stim_onset = [stim_onset(1)-df_SOT(1) stim_onset(1:48) stim_onset(48)+df_SOT(48) stim_onset(49:end)];
rsp_onset = [rsp_onset(1)-df_SOT(1) rsp_onset(1:48) rsp_onset(48)+df_SOT(48) rsp_onset(49:end)];
stim_dur= rsp_onset - stim_onset;

%Ploting to check marks 
marks_stim= 0.4*ones(1,length(stim_onset));
marks_rsp= 0.2*ones(1,length(rsp_onset));
figure, plot(pdio),hold on, 
plot(stim_onset*iEEG_rate,marks_stim,'r*');hold on
plot(rsp_onset*iEEG_rate,marks_rsp,'g*');
return

% 
% [C,IA,IB]= intersect(rest_offset,stim_onset);
% if length(IB)<length(rest_onset), error('check rest_onset'), end

% %% 
% marks_rsp = marks_rsp(1:53);
% marks_stim = marks_stim(1:53);
% rsp_onset=rsp_onset(1:53);
% stim_dur=stim_dur(1:53);
% stim_ind=stim_ind(1:53);
% %stim_offset=stim_offset(1:53);
% stim_onset=stim_onset(1:53);

%% Comparing photodiod with behavioral data

df_stim_onset= diff(stim_onset);
figure, plot(df_SOT,'o','MarkerSize',8,'LineWidth',3),hold on, plot(df_stim_onset,'r*')
df= df_SOT - df_stim_onset;
%figure, hist(df)
if ~all(abs(df)<.1)
   disp('behavioral data and photodiod mismatch'),
   find(abs(df)>.1)
   return
end


%% events and categories from psychtoolbox information
clear events
% lsi=lsi-1;
wlist= K.wlist;
cond= K.conds;
% rt=zeros(1,length(K.theData));
rt= NaN*ones(1,length(K.theData));
for ii=1:length(K.theData)
    % rt(ii)=K.theData(ii).RT;
    % tmp= K.theData(ii).RT;
    rt(ii)=K.theData(ii).RT;
end

categNames  = {'Num','RhymingWord','NumWord','Word','PseudoWord'};

stimNum= [1:length(stim_onset)];

for ci=1:length(categNames)
    cat = categNames(ci);
    events.categories(ci).name= sprintf('%s',categNames{ci});
    events.categories(ci).categNum= ci;
    events.categories(ci).numEvents= sum(cond==ci);
    events.categories(ci).start= stim_onset(find(cond==ci));
    events.categories(ci).duration= stim_dur(find(cond==ci));
    events.categories(ci).stimNum= stimNum(find(cond==ci));
    events.categories(ci).wlist= wlist(find(cond==ci));
    events.categories(ci).RT= rt(find(cond==ci));
%     events.categories(ci).sbj_resp= sbj_resp(find(cond==ci));
end



%% making a saving directory
fn= sprintf('%s/events_%s.mat',globalVar.result_dir,block_name);
save(fn,'events');