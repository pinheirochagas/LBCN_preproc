clear all; close all; clc;

%% Globar Variable elements
sbj_name= 'S14_69b_RT';
project_name= 'Memoria';
block_name= 'E17-438_0015';

initialize_dirs;
load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',data_root,sbj_name,project_name,sbj_name,block_name));
globalVar.psych_dir = sprintf('%s/analysis_ECoG/psychData/%s/%s',comp_root,sbj_name,block_name);
sbj_name= globalVar.sbj_name;


iEEG_rate=globalVar.iEEG_rate;

%% Reading PsychData BAHAVIORAL DATA

K= load(sprintf('%s/sodata.S14_69b_RT_run4.11.06.2017.11.20.mat',globalVar.psych_dir)); % block 55

lsi= length(K.theData);

SOT= nan(1,lsi);
sbj_resp= nan(1,lsi);
RT = [K.theData.RT];
for si= 1:lsi %
    if (~isempty(K.theData(si).flip))
        SOT(si)= K.theData(si).flip.StimulusOnsetTime;
        if ~isnan(str2num(K.theData(si).keys))
            sbj_resp(si)= str2num(K.theData(si).keys(1));
        else
            sbj_resp(si)= NaN;
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
clear anlg

pdio = pdio/max(pdio);


%% Thresholding the signal
ind_above= pdio > 0.5;
ind_df= diff(ind_above);
clear ind_above
onset= find(ind_df==1);
offset= find(ind_df==-1);
clear ind_df
pdio_onset= onset/iEEG_rate;
pdio_offset= offset/iEEG_rate;

% %remove onset flash

pdio_onset(1:12)=[]; % 
pdio_offset(1:12)=[]; % 


%get osnets from diode
pdio_dur= pdio_offset - pdio_onset;
IpdioI= [pdio_onset(2:end)-pdio_offset(1:end-1) 0];
isi_ind = find(IpdioI > 0.2);

stim_offset= [pdio_offset(isi_ind) pdio_offset(end)];
stim_onset= [pdio_onset(isi_ind) pdio_onset(end)];
% stim_onset = [stim_onset(1:96) NaN stim_onset(97:end)];
% stim_offset = [stim_offset(1:96) NaN stim_offset(97:end)];

stim_dur= stim_offset - stim_onset;

%Ploting to check marks for STIM
marks_on= 0.5*ones(1,length(stim_onset));
marks_off= 0.4*ones(1,length(stim_offset));
figure, plot(pdio),hold on, 
plot(stim_onset*iEEG_rate,marks_on,'r*');hold on
plot(stim_offset*iEEG_rate,marks_off,'g*');


% return
%%
%Get trials, insturuction onsets
all_stim_onset = NaN*ones(lsi,5);
rest_onset = [];
rest_offset = [];

bsize = K.bSize;
bType = K.bType;

counter = 1;
for ti = 1:lsi
%     for ti = 1:22
    if (K.conds(ti) == 1) %autobio
        end_counter = min(counter+4,length(stim_onset));
        numinds = end_counter-counter;
        all_stim_onset(ti,1:numinds) = stim_onset(counter:counter+numinds-1);
        all_stim_onset(ti,5) = NaN;
        if (mod(ti,bsize)==0)
            rest_onset = [rest_onset all_stim_onset(ti,4)+RT(ti)+K.ITI];
            rest_offset = [rest_offset all_stim_onset(ti,4)+RT(ti)+K.ITI+K.FixTime];
        end
        counter = counter + 4;
    else %math
        end_counter = min(counter+5,length(stim_onset));
        numinds = end_counter-counter;
        all_stim_onset(ti,1:numinds) = stim_onset(counter:counter+numinds-1);
        if (mod(ti,bsize)==0)
            rest_onset = [rest_onset all_stim_onset(ti,5)+RT(ti)+K.ITI];
            rest_offset = [rest_offset all_stim_onset(ti,5)+RT(ti)+K.ITI+K.FixTime];
        end
        counter = counter + 5;
    end
end

%plot each presentation in trial
figure, plot(pdio,'k'),hold on, 

plot(all_stim_onset(:,1)*iEEG_rate,0.9*ones(lsi,1),'b*');
plot(all_stim_onset(:,2)*iEEG_rate,0.7*ones(lsi,1),'y*');
plot(all_stim_onset(:,3)*iEEG_rate,0.5*ones(lsi,1),'c*');
plot(all_stim_onset(:,4)*iEEG_rate,0.3*ones(lsi,1),'m*');
plot(all_stim_onset(:,5)*iEEG_rate,0.1*ones(lsi,1),'g*');

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

categNames1 = {'Autobio','MathNumber','MathNumberWord','Rest'};
            
conds2 = zeros(1,lsi);
counter = 1;
bsize = K.bSize;
bType = K.bType;
for bi = 1:length(bType)
    inds = counter:counter+bsize-1;
    conds2(inds) = bType(bi);
    counter=counter+bsize;
end
conds2 = conds2(1:lsi);
%'corr_num','corr_let','incorr_num','incorr_let'
%%

for ti = 1:lsi
    subj_resp(ti) = K.theData(ti).keys(1);
end

for ci=1:length(categNames1)
    cat = categNames1(ci);
    events.categories(ci).name= sprintf('%s',categNames1{ci});
    events.categories(ci).categNum= ci;
    if strcmp(cat,'Rest')
        events.categories(ci).numEvents = length(rest_onset);
        events.categories(ci).start = rest_onset;
        events.categories(ci).duration = rest_offset-rest_onset;
    else
        events.categories(ci).numEvents= sum(conds2==ci);
        events.categories(ci).start= all_stim_onset(find(conds2==ci),1);
        events.categories(ci).allonset= all_stim_onset(find(conds2==ci),:);
        events.categories(ci).stimNum= find(conds2==ci);
        events.categories(ci).wlist= K.wlist(find(conds2==ci));
        events.categories(ci).RT= RT(find(conds2==ci));
        events.categories(ci).sbj_resp= sbj_resp(find(conds2==ci));
    end
    if ismember(cat,{'MathNumber','MathNumberWord'})
        events.categories(ci).duration = ((events.categories(ci).allonset(:,5)-events.categories(ci).allonset(:,1))'+events.categories(ci).RT)';
    elseif strcmp(cat,'Autobio')
        events.categories(ci).duration = ((events.categories(ci).allonset(:,4)-events.categories(ci).allonset(:,1))'+events.categories(ci).RT)';
    end
end

otherAutoCats = {'AutoGenVerb','AutoSpecVerb','AutoRecent','AutoDist'};

    
otherAutoCatInds = cell(1,length(otherAutoCats));
for ti = 1:events.categories(1).numEvents
    tempstim = events.categories(1).wlist{ti};
    tempinds = findstr(',',tempstim);
    verb = tempstim(tempinds(2)+2:tempinds(3)-1);
    timeword = tempstim(1:tempinds(1)-1);
    if ismember(verb,{'gave','used','saw','had','took','sent','met','visited','attended'}) %general verb
        otherAutoCatInds{1}=[otherAutoCatInds{1} ti];
    else
        otherAutoCatInds{2}=[otherAutoCatInds{2} ti];
    end
    if ismember(timeword,{'Today','Yesterday'})
        otherAutoCatInds{3} = [otherAutoCatInds{3} ti];
    else
        otherAutoCatInds{4} = [otherAutoCatInds{4} ti];
    end
end

for ci = 1:length(otherAutoCats)
    cind = ci + length(categNames1);
    events.categories(cind).name = otherAutoCats{ci};
    events.categories(cind).categNum = cind;
    events.categories(cind).numEvents = length(otherAutoCatInds{ci});
    events.categories(cind).start = events.categories(1).start(otherAutoCatInds{ci});
    events.categories(cind).allonset = events.categories(1).allonset(otherAutoCatInds{ci},:);
    events.categories(cind).stimNum= events.categories(1).stimNum(otherAutoCatInds{ci});
    events.categories(cind).wlist= {events.categories(1).wlist{otherAutoCatInds{ci}}};
    events.categories(cind).RT= events.categories(1).RT(otherAutoCatInds{ci});
    events.categories(cind).sbj_resp= events.categories(1).sbj_resp(otherAutoCatInds{ci});
    events.categories(cind).duration=events.categories(1).duration(otherAutoCatInds{ci});
end

categNames = {categNames1{:},otherAutoCats{:}};

%% Comparing reaction times to stimuli durations
% df= abs(stim_dur - rt);
% if ~all(abs(df)<.2)
%    disp('Reaction times and photodiod mismatch\n'),
%    fprintf('trials did not match:\n %d\n',find(abs(df)>.2))
%    return
% end

%% making a saving directory

fn= sprintf('%s/events_%s.mat',globalVar.result_dir,block_name);
save(fn,'events','categNames');

