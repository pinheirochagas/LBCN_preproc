function EventIdentifier (sbj_name, project_name, block_names, dirs, pdio_chan)
%% Globar Variable elements

%% loop across blocks
for i = 1:length(block_names)
    bn = block_names{i};
    
    switch project_name
        case 'MMR'
            n_stim_per_trial = 1;
        case 'UCLA'
            n_stim_per_trial = 1;
        case 'Memoria'
            n_stim_per_trial = 5;
        case 'Calculia'
            n_stim_per_trial = 5;
        case 'Calculia_production'
            n_stim_per_trial = 3;
        case 'Calculia_China'
            n_stim_per_trial = 5;
        case 'Number_comparison'
            n_stim_per_trial = 2;
    end
    
    %% Load globalVar
    load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn));
    iEEG_rate=globalVar.iEEG_rate;
    
    %% reading analog channel from neuralData directory
    load(sprintf('%s/Pdio%s_%.2d.mat',globalVar.originalData, bn, pdio_chan)); % going to be present in the globalVar
    
    %% varout is anlg (single precision)
    pdio = anlg/max(double(anlg));
    [n_initpulse_onset, n_initpulse_offset] = find_skip(anlg, 0.001, globalVar.Pdio_rate);
    clear anlg
    
    %% Add exceptions
    [n_initpulse_onset, n_initpulse_offset] = EventIdentifierExceptions(sbj_name, project_name, bn);
    
    %% Thresholding the signal
    if strcmp(project_name, 'Calculia_production')
        ind_above= pdio < -5;
    else
        ind_above= pdio > 0.5;
    end
    
    ind_df= diff(ind_above);
    clear ind_above
    onset= find(ind_df==1);
    offset= find(ind_df==-1);
    clear ind_df
    pdio_onset= onset/globalVar.Pdio_rate;
    pdio_offset= offset/globalVar.Pdio_rate;
    if length(pdio_onset) < length(pdio_offset)
        pdio_onset = [0 pdio_onset];
        warning('Adding additional onset as 0, since recording started in the middle of the photodiode signal')
    else
    end
    
    % %remove onset flash
    pdio_onset(1:n_initpulse_onset)=[]; % Add in calculia production the finisef to experiment to have 12 pulses
    pdio_offset(1:n_initpulse_offset)=[]; %
    clear n_initpulse_onset; clear n_initpulse_offset;
    
    %get osnets from diode
    pdio_dur= pdio_offset - pdio_onset;
    IpdioI= [pdio_onset(2:end)-pdio_offset(1:end-1) 0];
    isi_ind = find(IpdioI > 0.1);
    clear stim_offset stim_onset
    stim_offset= [pdio_offset(isi_ind) pdio_offset(end)];
    stim_onset= [pdio_onset(isi_ind) pdio_onset(end)];
    % stim_onset = [stim_onset(1:115) stim_onset(117:end)];
    % stim_offset = [stim_offset(1:115) stim_offset(117:end)];
    
    stim_dur= stim_offset - stim_onset;
    
    %% Load trialinfo
    % ---------------------------------------------
    % Create specific subfunctions to extract the relevant info for each
    % project_name
    load([globalVar.psych_dir '/trialinfo_', bn '.mat'], 'trialinfo');
    
    % Add the all_stim_onset
    
    event_trials = find(~strcmp(trialinfo.condNames, 'rest'));
    rest_trials = find(strcmp(trialinfo.condNames, 'rest'));
    
    StimulusOnsetTime = trialinfo.StimulusOnsetTime(event_trials,1); % **
    
    %% match the trigger onset with behaviral data
    beh_sot_all=trialinfo.StimulusOnsetTime(event_trials,:);
    beh_sot_all=beh_sot_all(~isnan(beh_sot_all));
    beh_sot=sort(reshape(beh_sot_all,1,numel(beh_sot_all)));
    beh_sot=beh_sot-beh_sot(1)+stim_onset(1);
    
    if length(stim_onset)<length(beh_sot)
        disp('Warning: Missing trigger in Pdio.');
        stim_onset(1,length(stim_onset)+1:length(beh_sot))=nan;
        for i=1:length(beh_sot)
            if stim_onset(i)-beh_sot(i)>1
                stim_onset(1,i+1:end+1)=stim_onset(1,i:end);
                stim_onset(i)=beh_sot(i);
                disp('Complementing')
            end
        end
        stim_onset=stim_onset(~isnan(stim_onset));
        disp('Notice:  Trigger has been Complemented.')
        figure;
        plot(beh_sot,'o','MarkerSize',8,'LineWidth',3) % psychtoolbox
        hold on
        plot(stim_onset,'r*') % photodiode/trigger
        
    end
    
    %% Get trials, insturuction onsets
    %% modified for Memoria
    colnames = trialinfo.Properties.VariableNames;
    ntrials = size(trialinfo,1);
    if ismember('nstim',colnames) % for cases where each trial has diff # of stim
        all_stim_onset = nan(ntrials,max(trialinfo.nstim));
        
        counter = 1;
        for ti = 1:ntrials
            inds = counter:(counter+trialinfo.nstim(ti)-1);
            all_stim_onset(ti,1:trialinfo.nstim(ti))=stim_onset(inds);
            counter = counter+trialinfo.nstim(ti);
        end
    else
        
        all_stim_onset = reshape(stim_onset,n_stim_per_trial,length(stim_onset)/n_stim_per_trial)';
    end
    
    
    % Add other kind of exceptions for when there is more triggers in the end - Calculia
    stim_onset = EventIdentifierExceptions_moreTriggersCalculia(stim_onset, sbj_name, project_name, bn);
    
    %% Reshape triggers
    all_stim_onset = reshape(stim_onset,n_stim_per_trial,length(stim_onset)/n_stim_per_trial)';
end


%%
% Plot photodiode segmented data
figureDim = [0 0 1 1];
figure('units', 'normalized', 'outerposition', figureDim)
subplot(2,3,1:3)
hold on
plot(pdio)

% Event onset
plot(stim_onset*globalVar.Pdio_rate,0.9*ones(length(stim_onset),1),'r*');


%% Comparing photodiod with behavioral data
% Add another exception for subjects who have 1 trialinfo less
all_stim_onset = EventIdentifierExceptions_oneTrialLess(all_stim_onset,sbj_name, project_name, bn);

% Add another exception for subjects who have additional photo/trigger trials in the middle
% and visual inspection shows good correspondence between photo/trigger and psychtoolbox output
all_stim_onset = EventIdentifierExceptions_extraTrialsMiddle(all_stim_onset, StimulusOnsetTime, sbj_name, project_name, bn);

%% Plot comparison photo/trigger 
df_SOT= diff(StimulusOnsetTime)';
df_stim_onset = diff(all_stim_onset(:,1))';

%plot overlay
subplot(2,3,4)
plot(df_SOT,'o','MarkerSize',8,'LineWidth',3) % psychtoolbox
hold on
plot(df_stim_onset,'r*') % photodiode/trigger
df= df_SOT - df_stim_onset;

%% Plot diffs, across experiment and histogram
subplot(2,3,5)
plot(df);
title('Diff. behavior diode (exp)');
xlabel('Trial number');
ylabel('Time (ms)');
subplot(2,3,6)
hist(df)
title('Diff. behavior diode (hist)');
xlabel('Time (ms)');
ylabel('Count');

%flag large difference
if ~all(abs(df)<.1)
    warning('behavioral data and photodiod mismatch')
end

%% Updating the events with onsets
 if ismember('nstim',colnames)
    nstim = trialinfo.nstim;
 else
    nstim = ones(size(trialinfo,1),1);
 end

trialinfo.allonsets(event_trials,:) = all_stim_onset;
trialinfo.RT_lock = nan(ntrials,1);
for ti = 1:ntrials
    trialinfo.RT_lock(ti) = trialinfo.RT(ti) + trialinfo.allonsets(ti,nstim(ti));
end
trialinfo.allonsets(rest_trials,:) = (trialinfo.StimulusOnsetTime(rest_trials,:)-trialinfo.StimulusOnsetTime(rest_trials-1,:))+trialinfo.allonsets(rest_trials-1,:);


%% Account for when recording started in the middle of photodiode signal
if trialinfo.allonsets(1) == 0
    warning('First trial excluded, since recording started in the middle of the photidiode signal')
else
end
trialinfo = trialinfo(trialinfo.allonsets(:,1) ~= 0,:);


%% Save trialinfo
fn= sprintf('%s/trialinfo_%s.mat',globalVar.result_dir,bn);
save(fn, 'trialinfo');

end