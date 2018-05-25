clear all; close all; clc;

%% Globar Variable elements
sbj_name= 'S17_116';
project_name= 'NumberComparison';
block_name= 'E17-789_0030';

initialize_dirs;
load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',data_root,sbj_name,project_name,sbj_name,block_name));
globalVar.psych_dir = sprintf('%s/analysis_ECoG/psychData/%s/%s',comp_root,sbj_name,block_name);
sbj_name= globalVar.sbj_name;


iEEG_rate=globalVar.iEEG_rate;

%% Reading PsychData BAHAVIORAL DATA

K= load(sprintf('%s/sodata.S17_116.31.10.2017.19.24.mat',globalVar.psych_dir)); 
load(sprintf('%s/Run4/permutedTrials.mat',globalVar.psych_dir)); 
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

stim_dur= stim_offset - stim_onset;

%Ploting to check marks for STIM
marks_on= 0.5*ones(1,length(stim_onset));
marks_off= 0.4*ones(1,length(stim_offset));
figure, plot(pdio),hold on, 
plot(stim_onset*iEEG_rate,marks_on,'r*');hold on
plot(stim_offset*iEEG_rate,marks_off,'g*');


return
%%

stim_offset= [pdio_offset(isi_ind) pdio_offset(end)];
stim_onset= [pdio_onset(isi_ind) pdio_onset(end)];
instr_onset = stim_onset(1:33:end);
stim_onset(1:33:end)=[];
stim_offset(1:33:end)=[];
stim1_onset = stim_onset(1:2:end);
stim2_onset = stim_onset(2:2:end);
% counter = 1;
% while counter <= length(stim_onset)
%     stim1_onset = [stim1_onset stim_onset(counter)];
%     counter = counter+1;
%     if (stim_onset(counter)-stim_onset(counter-1)>1.2 && stim_onset(counter)-stim_onset(counter-1)<1.4)
%         stim2_onset = [stim2_onset stim_onset(counter)];
%         counter=counter+1;
%     else
%         stim2_onset = [stim2_onset stim_onset(counter-1)+1.27];
%     end
% end

all_stim_onset(:,1)=stim1_onset;
all_stim_onset(:,2)=stim2_onset;

%plot each presentation in trial
figure, plot(pdio,'k'),hold on, 

plot(instr_onset*iEEG_rate,0.9*ones(length(instr_onset),1),'m*');
plot(all_stim_onset(:,1)*iEEG_rate,0.7*ones(lsi,1),'b*');
plot(all_stim_onset(:,2)*iEEG_rate,0.5*ones(lsi,1),'y*');

% plot(stim1_onset*iEEG_rate,0.7*ones(length(stim1_onset),1),'b*');
% plot(stim2_onset*iEEG_rate,0.5*ones(length(stim2_onset),1),'y*');
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

categNames = {'LumNum','LumDot','QuantNum','QuantDot'}; %Luminance vs quantity judgment; numbers vs dots
cat_conds = [1 1 2 2];
cat_stimtype = [1 2 1 2];

numrefs = [35];
numdiffs = [-22:6:-4 4:6:22]/35; %ratios
lumrefs = 0.5;
lumdiffs = [-0.22:0.06:-0.04 0.04:0.06:0.22]/0.5; %ratios
           

for ci=1:length(categNames)
    cat = categNames(ci);
    events.categories(ci).name= sprintf('%s',categNames{ci});
    events.categories(ci).categNum= ci;
    inds = find(permconds == cat_conds(ci) & permstimtype == cat_stimtype(ci)); 
    events.categories(ci).numEvents= length(inds);
    events.categories(ci).start= all_stim_onset(inds,1);
    events.categories(ci).allonset= all_stim_onset(inds,:);
    events.categories(ci).stimNum= inds;
    events.categories(ci).quant(1,:)= permnum1(inds);
    events.categories(ci).quant(2,:)= permnum2(inds);
    events.categories(ci).lum(1,:)= permlum1(inds);
    events.categories(ci).lum(2,:)= permlum2(inds);
    events.categories(ci).RT= RT(inds);
    events.categories(ci).sbj_resp= sbj_resp(inds);
    events.categories(ci).duration = RT(inds)'+all_stim_onset(inds,2)-all_stim_onset(inds,1);
    ref_num = [];
    other_num = [];
    diff_ratio_num = [];
    diff_ind_num = [];
    ref_lum = [];
    other_lum = [];
    diff_ratio_lum = [];
    diff_ind_lum = [];
    for ti = 1:length(inds)
        ref_num_ind = find(ismember(events.categories(ci).quant(:,ti),numrefs));
        ref_num_temp = events.categories(ci).quant(ref_num_ind,ti);
        ref_num = [ref_num ref_num_temp];
        other_num_ind = setdiff([1 2],ref_num_ind);
        other_num_temp = events.categories(ci).quant(other_num_ind,ti);
        other_num = [other_num other_num_temp];
        diff_num_temp = (ref_num_temp-other_num_temp)/ref_num_temp;
        [~,diff_ind_num_temp] = min(abs(diff_num_temp-numdiffs));
        diff_ratio_num = [diff_ratio_num  diff_num_temp];
        diff_ind_num = [diff_ind_num diff_ind_num_temp];
        
        ref_lum_ind = find(ismember(events.categories(ci).lum(:,ti),lumrefs));
        ref_lum_temp = events.categories(ci).lum(ref_lum_ind,ti);
        ref_lum = [ref_lum ref_lum_temp];
        other_lum_ind = setdiff([1 2],ref_lum_ind);
        other_lum_temp = events.categories(ci).lum(other_lum_ind,ti);
        other_lum = [other_lum other_lum_temp];
        diff_lum_temp = (ref_lum_temp-other_lum_temp)/ref_lum_temp;
        [~,diff_ind_lum_temp] = min(abs(diff_lum_temp-lumdiffs));
        diff_ratio_lum = [diff_ratio_lum  diff_lum_temp];
        diff_ind_lum = [diff_ind_lum diff_ind_lum_temp];
    end
    events.categories(ci).refNum = ref_num;
    events.categories(ci).otherNum = other_num;
    events.categories(ci).diffratioNum = diff_ratio_num;
    events.categories(ci).diffindNum = diff_ind_num;
    events.categories(ci).refLum = ref_lum;
    events.categories(ci).otherLum = other_lum;
    events.categories(ci).diffratioLum = diff_ratio_lum;
    events.categories(ci).diffindLum = diff_ind_lum;
end


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

